//
//  WYChatEmojiView.swift
//  WYBasisKit
//
//  Created by 官人 on 2023/4/3.
//  Copyright © 2023 官人. All rights reserved.
//

private let emojiViewRecentlyCountKey: String = "emojiViewRecentlyCountKey"

import UIKit

public struct WYEmojiViewConfig {

    /// 自定义Emoji控件背景色
    public var backgroundColor: UIColor = .wy_hex("#ECECEC")
    
    /// 自定义Emoji控件的滚动方向
    public var scrollDirection: UICollectionView.ScrollDirection = .vertical
    
    /// 自定义Emoji控件z是否需要翻页模式
    public var isPagingEnabled: Bool = false

    /// 自定义Emoji控件的高度
    public var contentHeight: CGFloat = wy_screenWidth(350)
    
    /// 自定义Emoji控件内collectionView底部距离Emoji控件底部的偏移量
    public var collectionViewBottomOffset: CGFloat = 0

    /// 自定义Emoji数据源，示例：["[玫瑰](表情图片名)","[色](表情图片名)","[嘻嘻](表情图片名)"]
    public var emojiSource: [String] = []

    /// 自定义Emoji控件是否需要显示最近使用的表情
    public var showRecently: Bool = true

    /// 自定义Emoji控件最近使用的表情显示几个(表情默认显示8列，这里就默认设置8个)
    public var recentlyCount: Int = 8

    /// 自定义Emoji控件最近使用表情Header文本(设置后会显示一个Header, 仅限scrollDirection == .vertical时生效)
    public var recentlyHeaderText: String = "最近使用"

    /// 自定义Emoji控件所有表情Header文本(设置后会显示一个Header，仅限scrollDirection == .vertical时生效)
    public var totalHeaderText: String = "所有表情"

    /// 自定义Emoji控件Header文本字体、字号
    public var headerTextFont: UIFont = .systemFont(ofSize: wy_screenWidth(15))

    /// 自定义Emoji控件Header文本字体颜色
    public var headerTextColor: UIColor = .wy_hex("#1B1B1B")

    /// 自定义Emoji控件HeaderView背景色
    public var headerBackgroundColor: UIColor = .wy_hex("#ECECEC")

    /// 自定义Emoji控件HeaderView高度
    public var headerHeight: CGFloat = wy_screenWidth(30)

    /// 自定义Emoji控件HeaderView中TextView的偏移量
    public var headerTextOffset: CGPoint = CGPoint(x: wy_screenWidth(15), y: (wy_screenWidth(30) - UIFont.systemFont(ofSize: wy_screenWidth(15)).lineHeight) / 2)

    /// 自定义Emoji控件每行显示几个表情
    public var minimumLineCount: Int = 8

    /// 自定义Emoji控件单元格的Size
    public var itemSize: CGSize = CGSize(width: wy_screenWidth(30), height: wy_screenWidth(30))

    /// 自定义Emoji控件全部表情的sectionInset
    public var sectionInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: wy_screenWidth(15), bottom: wy_screenWidth(20), right: wy_screenWidth(15))

    /// 自定义Emoji控件最近使用分区的sectionInset
    public var recentlySectionInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: wy_screenWidth(15), bottom: wy_screenWidth(15), right: wy_screenWidth(15))

    /// 自定义Emoji控件的行间距
    public var minimumLineSpacing: CGFloat = wy_screenWidth(16)

    /// 自定义Emoji控件右下角功能区配置
    public var funcAreaConfig: WYEmojiFuncAreaConfig = WYEmojiFuncAreaConfig()
    
    /// Emoji表情长按预览控件配置
    public var previewConfig: WYEmojiPreviewConfig = WYEmojiPreviewConfig()
    
    public init() {}
}

@objc public protocol WYChatEmojiViewDelegate {
    
    /// 监控Emoji点击事件
    @objc optional func didClick(_ emojiView: WYChatEmojiView, _ emoji: String)
    
    /// 长按了表情预览控件(仅限WYEmojiPreviewStyle == other时才会回调)
    @objc optional func willShowPreviewView(_ imageName: String, _ imageView: UIImageView)
    
    /// 点击了删除按钮
    @objc optional func didClickEmojiDeleteView()
    
    /// 点击了发送按钮
    @objc optional func sendMessage()
}

public class WYChatEmojiView: UIView, WYEmojiFuncAreaViewDelegate {
    
    /// 点击或长按事件代理
    public weak var delegate: WYChatEmojiViewDelegate?
    
    lazy var collectionView: UICollectionView = {
        
        let emojiViewMinimumInteritemSpacing: CGFloat = (wy_screenWidth - emojiViewConfig.sectionInset.left - emojiViewConfig.sectionInset.right - (CGFloat(emojiViewConfig.minimumLineCount) * emojiViewConfig.itemSize.width)) / (CGFloat(emojiViewConfig.minimumLineCount) - 1.0)
        
        var collectionView: UICollectionView!
        if emojiViewConfig.scrollDirection == .vertical {
            collectionView = UICollectionView.wy_shared(scrollDirection: emojiViewConfig.scrollDirection, minimumLineSpacing: emojiViewConfig.minimumLineSpacing, minimumInteritemSpacing: emojiViewMinimumInteritemSpacing, itemSize: emojiViewConfig.itemSize, delegate: self, dataSource: self, superView: self)
        }else {            
//            let flowLayout: WYHorizontalFlowLayout = WYHorizontalFlowLayout()
//            flowLayout.itemSize = emojiViewConfig.itemSize
//            flowLayout.scrollDirection = emojiViewConfig.scrollDirection
//            flowLayout.minimumLineSpacing = emojiViewConfig.minimumLineSpacing
//            flowLayout.minimumInteritemSpacing = emojiViewMinimumInteritemSpacing
//            flowLayout.itemSize = emojiViewConfig.itemSize
//            collectionView = UICollectionView.wy_shared(flowLayout: flowLayout, delegate: self, dataSource: self, superView: self)
        }
        
        collectionView.register(WYEmojiViewCell.self, forCellWithReuseIdentifier: "WYEmojiViewCell")
        collectionView.register(WYEmojiHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "WYEmojiHeaderView")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "UICollectionReusableView")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "UICollectionReusableView")
        collectionView.isPagingEnabled = emojiViewConfig.isPagingEnabled
        collectionView.showsVerticalScrollIndicator = !collectionView.isPagingEnabled
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-emojiViewConfig.collectionViewBottomOffset)
        }
        return collectionView
    }()
    
    lazy var funcAreaView: WYEmojiFuncAreaView? = {
        
        guard emojiViewConfig.funcAreaConfig.show == true else {
            return nil
        }
        
        let funcAreaView: WYEmojiFuncAreaView = WYEmojiFuncAreaView()
        funcAreaView.delegate = self
        addSubview(funcAreaView)
        funcAreaView.snp.makeConstraints { make in
            make.size.equalTo(emojiViewConfig.funcAreaConfig.areaSize)
            make.right.equalToSuperview().offset(-emojiViewConfig.funcAreaConfig.areaRightOffset)
            make.bottom.equalToSuperview().offset(-emojiViewConfig.funcAreaConfig.areaBottomOffset)
        }
        return funcAreaView
    }()
    
    lazy private var recentlyEmoji: [String] = {
        
        guard emojiViewConfig.showRecently == true else {
            return []
        }
        
        var recentlyEmoji: [String] = UserDefaults.standard.array(forKey: emojiViewRecentlyCountKey) as? [String] ?? []
        if recentlyEmoji.count > emojiViewConfig.recentlyCount {
            let range: Range =  Range(NSMakeRange(emojiViewConfig.recentlyCount - 1, recentlyEmoji.count - emojiViewConfig.recentlyCount))!
            recentlyEmoji.replaceSubrange(range, with: [])
            
            UserDefaults.standard.setValue(recentlyEmoji, forKey: emojiViewRecentlyCountKey)
            UserDefaults.standard.synchronize()
        }
        return recentlyEmoji
    }()
    
    private var appendEmoji: [String] = []
    
    lazy private var dataSource: [[String]] = {
        var dataSource: [[String]] = []
        if (emojiViewConfig.showRecently == true) && (recentlyEmoji.isEmpty == false) {
            dataSource.append(recentlyEmoji)
        }
        
        if (emojiViewConfig.funcAreaConfig.show == true) && (emojiViewConfig.funcAreaConfig.wrapLastLineOfEmoji == true) {
            
            let flowLayout: UICollectionViewFlowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            
            var leftx: CGFloat = emojiViewConfig.sectionInset.left
            var line: Int = 0
            for index: Int in 0..<emojiViewConfig.minimumLineCount {
                leftx += emojiViewConfig.itemSize.width
                if leftx > (self.wy_width - emojiViewConfig.funcAreaConfig.areaRightOffset - emojiViewConfig.funcAreaConfig.sendViewRightOffset - emojiViewConfig.funcAreaConfig.sendViewSize.width - emojiViewConfig.funcAreaConfig.deleteViewSize.width - emojiViewConfig.funcAreaConfig.sendViewLeftOffsetWithDeleteView) {
                    break
                }
                leftx += flowLayout.minimumInteritemSpacing
                line += 1
            }
            
            var offsetCount: Int = 0
            let residual: Int = (emojiViewConfig.emojiSource.count % emojiViewConfig.minimumLineCount)
            
            if residual > line {
                offsetCount = (residual - line)
            }
            if residual == 0 {
                offsetCount = (emojiViewConfig.minimumLineCount - line)
            }
            
            var emojiSource: [String] = []
            emojiSource.append(contentsOf: emojiViewConfig.emojiSource)
            for _ in 0..<offsetCount {
                let lastEmoji: String = emojiSource.last ?? ""
                emojiSource.removeLast()
                appendEmoji.append(lastEmoji)
            }
            dataSource.append(emojiSource)
            if appendEmoji.isEmpty == false {
                dataSource.append(appendEmoji)
            }
            
        }else {
            dataSource.append(emojiViewConfig.emojiSource)
        }
        return dataSource
    }()
    
    public init() {
        super.init(frame: .zero)
        self.collectionView.backgroundColor = emojiViewConfig.backgroundColor
        self.funcAreaView?.backgroundColor = .clear
    }
    
    public func updateRecentlyEmoji(_ attributedText: NSAttributedString) {
        guard emojiViewConfig.showRecently == true else {
            return
        }
        
        let mutableString: NSMutableString = NSMutableString(string: attributedText.string)
        attributedText.enumerateAttribute(NSAttributedString.Key.attachment, in: NSMakeRange(0, attributedText.string.utf16.count), options: NSAttributedString.EnumerationOptions.longestEffectiveRangeNotRequired) { value, range, stop in
            if value is WYTextAttachment {
                // 拿到文本附件
                let attachment: WYTextAttachment = value as! WYTextAttachment
                let emoji: String = String(format: "%@", attachment.imageName)
                // 更新最近使用的表情
                var recently: [String] = UserDefaults.standard.array(forKey: emojiViewRecentlyCountKey) as? [String] ?? []
                if recently.contains(emoji) {
                    recently.remove(at: recently.firstIndex(of: emoji)!)
                }
                recently.insert(emoji, at: 0)
                if recently.count > emojiViewConfig.recentlyCount {
                    recently.removeLast()
                }
                UserDefaults.standard.setValue(Array(recently), forKey: emojiViewRecentlyCountKey)
                UserDefaults.standard.synchronize()

                if recentlyEmoji.isEmpty == false {
                    dataSource[0] = Array(recently)
                }else {
                    dataSource.insert(Array(recently), at: 0)
                }

                recentlyEmoji = Array(recently)

                if range == NSMakeRange(0, 1) {
                    collectionView.reloadData()
                }
            }
        }
    }
    
    @objc public func didClickSendView() {
        delegate?.sendMessage?()
    }

    @objc public func didClickDeleteView() {
        delegate?.didClickEmojiDeleteView?()
    }
    
    private func sectionInset(_ section: Int) -> UIEdgeInsets {
        
        if appendEmoji.isEmpty == true {
            return emojiViewConfig.sectionInset
        }else {
            if section == (dataSource.count - 1) {
                return UIEdgeInsets(top: emojiViewConfig.minimumLineSpacing, left: emojiViewConfig.sectionInset.left, bottom: emojiViewConfig.sectionInset.bottom, right: emojiViewConfig.sectionInset.right)
            }else {
                
                if (emojiViewConfig.showRecently == true) && (recentlyEmoji.isEmpty == false) {
                   
                    if section == 0 {
                        return UIEdgeInsets(top: emojiViewConfig.recentlySectionInset.top, left: emojiViewConfig.recentlySectionInset.left, bottom: emojiViewConfig.recentlySectionInset.bottom, right: emojiViewConfig.recentlySectionInset.right)
                    }else {
                        return UIEdgeInsets(top: emojiViewConfig.sectionInset.top, left: emojiViewConfig.sectionInset.left, bottom: 0, right: emojiViewConfig.sectionInset.right)
                    }
                }else {
                    return UIEdgeInsets(top: emojiViewConfig.sectionInset.top, left: emojiViewConfig.sectionInset.left, bottom: 0, right: emojiViewConfig.sectionInset.right)
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension WYChatEmojiView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if (recentlyEmoji.isEmpty == false) && (emojiViewConfig.showRecently == true) {
            if (section == 0) {
                return emojiViewConfig.recentlySectionInset
            }else {
                return sectionInset(section)
            }
        }else {
            return sectionInset(section)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard (recentlyEmoji.isEmpty == false) && (emojiViewConfig.showRecently == true)  else {
            return CGSize.zero
        }
        return CGSize(width: wy_width, height: (section < 2) ? emojiViewConfig.headerHeight : 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard (recentlyEmoji.isEmpty == false) && (emojiViewConfig.showRecently == true)  else {
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "UICollectionReusableView", for: indexPath)
        }
        
        if (kind == UICollectionView.elementKindSectionHeader) && (indexPath.section < 2) {
            let headerView: WYEmojiHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "WYEmojiHeaderView", for: indexPath) as! WYEmojiHeaderView
            headerView.textView.text = [emojiViewConfig.recentlyHeaderText, emojiViewConfig.totalHeaderText][indexPath.section]
            return headerView
        }
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "UICollectionReusableView", for: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: WYEmojiViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WYEmojiViewCell", for: indexPath) as! WYEmojiViewCell
        cell.emoji = dataSource[indexPath.section][indexPath.item]
        cell.delegate = self
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let emojiName: String = dataSource[indexPath.section][indexPath.item]
        delegate?.didClick?(self, emojiName)
    }
}

extension WYChatEmojiView: WYEmojiViewCellDelegate {
    
    public func willShowPreviewView(_ imageName: String, _ imageView: UIImageView) {
        delegate?.willShowPreviewView?(imageName, imageView)
    }
}