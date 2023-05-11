//
//  WYChatView.swift
//  WYBasisKit
//
//  Created by 官人 on 2023/3/30.
//  Copyright © 2023 官人. All rights reserved.
//

import UIKit

@objc public protocol WYChatViewDelegate {
    
    /// 点击了 文本/语音按钮 切换按钮
    @objc optional func didClickTextVoiceView(_ isText: Bool)
    
    /// 点击了 表情/文本 切换按钮
    @objc optional func didClickEmojiTextView(_ isEmoji: Bool)
    
    /// 点击了 更多 按钮
    @objc optional func didClickMoreView(_ isText: Bool)
    
    /// 输入框文本发生变化
    @objc optional func textDidChanged(_ text: String)
    
    /// 点击了 发送 按钮
    @objc optional func sendMessage(_ text: String)
    
    /// 将要显示表情预览控件(仅限WYEmojiPreviewStyle == other时才会回调)
    @objc optional func willShowPreviewView(_ imageName: String, _ imageView: UIImageView)
}

public class WYChatView: UIView {
    
    public weak var delegate: WYChatViewDelegate? = nil
    
    public lazy var chatInput: WYChatInputView = {
        let inputView = WYChatInputView()
        inputView.delegate = self
        addSubview(inputView)
        inputView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
        }
        return inputView
    }()
    
    public lazy var tableView: UITableView = {

        let tableView = UITableView.wy_shared(style: .plain, separatorStyle: .singleLine, delegate: self, dataSource: self, superView: self)
        tableView.wy_swipeOrTapCollapseKeyboard()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(chatInput.snp.top)
        }
        return tableView
    }()
    
    public lazy var emojiView: WYChatEmojiView? = {
        guard inputBarConfig.emojiTextButtonSize != CGSize.zero else {
            return nil
        }
        let emojiView: WYChatEmojiView = WYChatEmojiView()
        emojiView.delegate = self
        emojiView.isHidden = true
        addSubview(emojiView)
        emojiView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(emojiViewConfig.contentHeight)
            make.bottom.equalToSuperview().offset(emojiViewConfig.contentHeight)
        }
        return emojiView
    }()
    
    public init() {
        super.init(frame: .zero)
        self.tableView.backgroundColor = .white
        self.emojiView?.backgroundColor = .clear
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDismiss), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        updateInputViewOffset(offsety: keyboardRect.size.height - wy_tabbarSafetyZone)
        updateEmojiViewConstraints(false)
    }
    
    @objc private func keyboardWillDismiss() {
        
        let offsety: CGFloat = chatInput.emojiView.isSelected ? emojiViewConfig.contentHeight : 0
        updateInputViewOffset(offsety: offsety)
    }
    
    private func updateInputViewOffset(offsety: CGFloat) {
        UIView.animate(withDuration: 0.25) { [weak self] in
            if let self = self {
                self.chatInput.snp.updateConstraints({ make in
                    make.bottom.equalToSuperview().offset(-offsety)
                })
                self.chatInput.superview?.layoutIfNeeded()
            }
        }completion: {[weak self] _ in
            if let self = self {
                self.chatInput.updateTextViewOffset()
            }
        }
    }
    
    private func updateEmojiViewConstraints(_ isEmoji: Bool) {
        
        if (isEmoji == false) && (emojiView?.isHidden == true) {
            return
        }
        
        emojiView?.isHidden = false
        
        if chatInput.textView.isFirstResponder == false {
            keyboardWillDismiss()
        }
        
        if inputBarConfig.emojiTextButtonSize != CGSize.zero {
            let emojiOffset: CGFloat = isEmoji ? 0 : emojiViewConfig.contentHeight
            UIView.animate(withDuration: 0.25) { [weak self] in
                self?.emojiView?.snp.updateConstraints { make in
                    make.bottom.equalToSuperview().offset(emojiOffset)
                }
                self?.emojiView?.superview?.layoutIfNeeded()
            }completion: {[weak self] _ in
                self?.emojiView?.isHidden = !isEmoji
            }
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        chatInput.emojiView.isSelected = false
        updateEmojiViewConstraints(false)
        emojiView?.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension WYChatView: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        chatInput.textView.resignFirstResponder()
        scrollViewDidScroll(tableView)
    }
}

extension WYChatView: WYChatInputViewDelegate {
    
    public func didClickMoreView(_ isText: Bool) {
        if isText {
            wy_print("显示键盘")
        }else {
            wy_print("显示更多")
        }
        delegate?.didClickMoreView?(isText)
    }
    
    public func didClickEmojiTextView(_ isEmoji: Bool) {
        if isEmoji {
            wy_print("显示表情")
            updateEmojiFuncAreaViewState()
        }else {
            wy_print("显示键盘")
        }
        updateEmojiViewConstraints(isEmoji)
        delegate?.didClickEmojiTextView?(isEmoji)
    }
    
    public func didClickTextVoiceView(_ isText: Bool) {
        if isText {
            wy_print("显示键盘")
        }else {
            wy_print("显示语音")
            updateEmojiViewConstraints(false)
            emojiView?.isHidden = true
        }
        delegate?.didClickTextVoiceView?(isText)
    }
    
    public func textDidChanged(_ text: String) {
        chatInput.textView.attributedText = chatInput.sharedEmojiAttributed(string: text)
        updateEmojiFuncAreaViewState()
        delegate?.textDidChanged?(text)
        wy_print("输入的文本：\(text)")
    }
    
    public func didClickKeyboardEvent(_ text: String) {
        emojiView?.updateRecentlyEmoji(chatInput.textView.attributedText)
        chatInput.textView.text = ""
        updateEmojiFuncAreaViewState()
        chatInput.textViewDidChange(chatInput.textView)
        delegate?.sendMessage?(text)
        wy_print("发送文本消息：\(text)")
    }
    
    public func updateEmojiFuncAreaViewState() {
        
        let userInteractionEnabled: Bool = (chatInput.textView.attributedText.string.utf16.count > 0)
        emojiView?.funcAreaView?.sendView.isUserInteractionEnabled = userInteractionEnabled
        emojiView?.funcAreaView?.deleteView.isUserInteractionEnabled = userInteractionEnabled
        emojiView?.funcAreaView?.sendView.isSelected = !userInteractionEnabled
        emojiView?.funcAreaView?.deleteView.isSelected = !userInteractionEnabled
    }
}

extension WYChatView: WYChatEmojiViewDelegate {
    
    public func didClick(_ emojiView: WYChatEmojiView, _ emoji: String) {
        
        let textContent = chatInput.textView.attributedText.string
        let textNum = textContent.utf16.count - (textContent.utf16.count - textContent.count) + 1
        if (textNum > inputBarConfig.inputTextLength) && (inputBarConfig.inputTextLength > 0) {
            return
        }

        let cursorPosition = chatInput.textView.offset(from: chatInput.textView.beginningOfDocument, to: chatInput.textView.selectedTextRange?.start ?? chatInput.textView.beginningOfDocument)
        
        chatInput.textView.insertText(emoji)
        chatInput.textViewDidChange(chatInput.textView)
        
        let start: UITextPosition = chatInput.textView.position(from: chatInput.textView.beginningOfDocument, offset: cursorPosition + (inputBarConfig.emojiPattern.isEmpty ? emoji.utf16.count : 1))!
        let end: UITextPosition = chatInput.textView.position(from: start, offset: 0)!

        chatInput.textView.selectedTextRange = chatInput.textView.textRange(from: start, to: end)
    }
    
    public func willShowPreviewView(_ imageName: String, _ imageView: UIImageView) {
        delegate?.willShowPreviewView?(imageName, imageView)
    }
    
    public func didClickEmojiDeleteView() {
        chatInput.textView.deleteBackward()
    }
    
    public func sendMessage() {
        let emojiText: String = NSMutableAttributedString(attributedString: chatInput.textView.attributedText).wy_convertEmojiAttributedString(textColor: inputBarConfig.textColor, textFont: inputBarConfig.textFont).string
        didClickKeyboardEvent(wy_safe(emojiText))
    }
}