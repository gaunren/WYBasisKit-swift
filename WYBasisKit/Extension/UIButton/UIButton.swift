//
//  UIButton.swift
//  WYBasisKit
//
//  Created by 官人 on 2020/8/29.
//  Copyright © 2020 官人. All rights reserved.
//

import UIKit

/// UIButton图片控件和文本控件显示位置
@frozen public enum WYButtonPosition {
    
    /** 图片在左，文字在右，默认 */
    case imageLeftTitleRight
    /** 图片在右，文字在左 */
    case imageRightTitleLeft
    /** 图片在上，文字在下 */
    case imageTopTitleBottom
    /** 图片在下，文字在上 */
    case imageBottomTitleTop
}

/// 自定义Button，此Button可以实现设置Button内部的imageView和titleLabel的size，弥补iOS15以后分类方法wy_updateInsets只能调整imageView和titleLabel的位置，而不能设置imageView和titleLabel的size的遗憾
public class WYButton: UIButton {
    
    /// 按钮中imageView和titleLabe的展示位置
    public var position: WYButtonPosition = .imageLeftTitleRight
    
    /// 按钮中imageView和titleLabe的间距
    public var spacing: CGFloat = 0
    
    /// 按钮中imageView的自定义size(可选)
    public var imageViewSize: CGSize?
    
    /// 按钮中titleLabe的自定义size(可选)
    public var titleLabelSize: CGSize?
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let imageView = self.imageView, let titleLabel = self.titleLabel else {
            return
        }
        
        let buttonWidth = self.frame.size.width
        let buttonHeight = self.frame.size.height
        let imageWidth = imageViewSize?.width ?? imageView.frame.size.width
        let imageHeight = imageViewSize?.height ?? imageView.frame.size.height
        let labelWidth = titleLabelSize?.width ?? titleLabel.frame.size.width
        let labelHeight = titleLabelSize?.height ?? titleLabel.frame.size.height
        
        let totalWidth = imageWidth + labelWidth + spacing
        
        switch position {
        case .imageLeftTitleRight:
            imageView.frame = CGRect(
                x: (buttonWidth - totalWidth) / 2,
                y: (buttonHeight - imageHeight) / 2,
                width: imageWidth,
                height: imageHeight
            )
            titleLabel.frame = CGRect(
                x: imageView.frame.maxX + spacing,
                y: (buttonHeight - labelHeight) / 2,
                width: labelWidth,
                height: labelHeight
            )
            
        case .imageRightTitleLeft:
            titleLabel.frame = CGRect(
                x: (buttonWidth - totalWidth) / 2,
                y: (buttonHeight - labelHeight) / 2,
                width: labelWidth,
                height: labelHeight
            )
            imageView.frame = CGRect(
                x: titleLabel.frame.maxX + spacing,
                y: (buttonHeight - imageHeight) / 2,
                width: imageWidth,
                height: imageHeight
            )
            
        case .imageTopTitleBottom:
            imageView.frame = CGRect(
                x: (buttonWidth - imageWidth) / 2,
                y: (buttonHeight - imageHeight - labelHeight - spacing) / 2,
                width: imageWidth,
                height: imageHeight
            )
            titleLabel.frame = CGRect(
                x: (buttonWidth - labelWidth) / 2,
                y: imageView.frame.maxY + spacing,
                width: labelWidth,
                height: labelHeight
            )
            
        case .imageBottomTitleTop:
            titleLabel.frame = CGRect(
                x: (buttonWidth - labelWidth) / 2,
                y: (buttonHeight - imageHeight - labelHeight - spacing) / 2,
                width: labelWidth,
                height: labelHeight
            )
            imageView.frame = CGRect(
                x: (buttonWidth - imageWidth) / 2,
                y: titleLabel.frame.maxY + spacing,
                width: imageWidth,
                height: imageHeight
            )
        }
    }
}

public extension UIButton {
    
    /**
     *  实现Button内部文字和图片的自由排列
     *  注意：这个方法需要在设置图片和文字之后才可以调用，且button的大小要大于 图片大小+文字大小+spacing
     *  什么都不设置默认为图片在左，文字在右，居中且挨着排列的
     *  @param spacing 图片和文字的间隔
     */
    func wy_updateInsets(position: WYButtonPosition, spacing: CGFloat = 0) {
        
        DispatchQueue.main.async {
            
            if self.imageView?.image == nil || self.currentImage == nil || self.currentTitle?.isEmpty == true || self.titleLabel?.text?.isEmpty == true {
                
                //wy_print("wy_layouEdgeInsets方法 需要在设置图片、文字与约束或者frame之后才可以调用，且button的size最好大于 图片大小+文字大小+spacing")
                return
            }
            self.superview?.layoutIfNeeded()
            
            let imageWidth: CGFloat = (self.imageView?.frame.size.width)!
            let imageHeight: CGFloat = (self.imageView?.frame.size.height)!
            let labelWidth: CGFloat = CGFloat(self.titleLabel!.intrinsicContentSize.width)
            let labelHeight: CGFloat = CGFloat(self.titleLabel!.intrinsicContentSize.height)
            
            switch position {
                
            case .imageRightTitleLeft:
                
                if #available(iOS 15.0, *) {
                    
                    var configuration: UIButton.Configuration = .plain()
                    configuration.imagePlacement = .trailing
                    configuration.imagePadding = spacing
                    self.configuration = configuration
                    
                }else {
                    self.imageEdgeInsets = UIEdgeInsets(top:0, left:labelWidth+spacing/2.0, bottom: 0, right: -labelWidth-spacing/2.0)
                    self.titleEdgeInsets =  UIEdgeInsets(top:0, left:-imageWidth-spacing/2.0, bottom: 0, right:imageWidth+spacing/2.0)
                }
                break
                
            case .imageLeftTitleRight:
                
                if #available(iOS 15.0, *) {
                    
                    var configuration: UIButton.Configuration = .plain()
                    configuration.imagePlacement = .leading
                    configuration.imagePadding = spacing
                    self.configuration = configuration
                    
                }else {
                    self.titleEdgeInsets = UIEdgeInsets(top:0, left:spacing/2.0, bottom: 0, right: -spacing/2.0)
                    self.imageEdgeInsets = UIEdgeInsets(top:0, left:-spacing/2.0, bottom: 0, right:spacing/2.0)
                }
                break
                
            case .imageTopTitleBottom:
                
                if #available(iOS 15.0, *) {
                    
                    var configuration: UIButton.Configuration = .plain()
                    configuration.imagePlacement = .top
                    configuration.imagePadding = spacing
                    self.configuration = configuration
                    
                }else {
                    self.imageEdgeInsets = UIEdgeInsets(top: -labelHeight - spacing/2.0, left: 0, bottom: 0, right:  -labelWidth)
                    self.titleEdgeInsets =  UIEdgeInsets(top:0, left: -imageWidth, bottom: -imageHeight-spacing/2.0, right: 0)
                }
                break
                
            case .imageBottomTitleTop:
                
                if #available(iOS 15.0, *) {
                    
                    var configuration: UIButton.Configuration = .plain()
                    configuration.imagePlacement = .bottom
                    configuration.imagePadding = spacing
                    self.configuration = configuration
                    
                }else {
                    self.imageEdgeInsets = UIEdgeInsets(top:0, left:0, bottom: -labelHeight-spacing/2.0, right: -labelWidth)
                    self.titleEdgeInsets =  UIEdgeInsets(top:-imageHeight-spacing/2.0, left:-imageWidth, bottom: 0, right: 0)
                }
                break
            }
        }
    }
    
    /** 按钮默认状态文字 */
    var wy_nTitle: String {
        set {
            setTitle(newValue, for: .normal)
        }
        get {
            return title(for: .normal) ?? ""
        }
    }
    
    /** 按钮高亮状态文字 */
    var wy_hTitle: String {
        set {
            setTitle(newValue, for: .highlighted)
        }
        get {
            return title(for: .highlighted) ?? ""
        }
    }
    
    /** 按钮选中状态文字 */
    var wy_sTitle: String {
        set {
            setTitle(newValue, for: .selected)
        }
        get {
            return title(for: .selected) ?? ""
        }
    }
    
    /** 按钮默认状态文字颜色 */
    var wy_title_nColor: UIColor {
        set {
            setTitleColor(newValue, for: .normal)
        }
        get {
            return titleColor(for: .normal) ?? .clear
        }
    }
    
    /** 按钮高亮状态文字颜色 */
    var wy_title_hColor: UIColor {
        set {
            setTitleColor(newValue, for: .highlighted)
        }
        get {
            return titleColor(for: .highlighted) ?? .clear
        }
    }
    
    /** 按钮选中状态文字颜色 */
    var wy_title_sColor: UIColor {
        set {
            setTitleColor(newValue, for: .selected)
        }
        get {
            return titleColor(for: .selected) ?? .clear
        }
    }
    
    
    /** 按钮默认状态图片 */
    var wy_nImage: UIImage {
        set {
            setImage(newValue, for: .normal)
        }
        get {
            return image(for: .normal) ?? UIKit.UIImage.wy_createImage(from: .clear)
        }
    }
    
    /** 按钮高亮状态图片 */
    var wy_hImage: UIImage {
        set {
            setImage(newValue, for: .highlighted)
        }
        get {
            return image(for: .highlighted) ?? UIKit.UIImage.wy_createImage(from: .clear)
        }
    }
    
    /** 按钮选中状态图片 */
    var wy_sImage: UIImage {
        set {
            setImage(newValue, for: .selected)
        }
        get {
            return image(for: .selected) ?? UIKit.UIImage.wy_createImage(from: .clear)
        }
    }
    
    /** 设置按钮背景色 */
    func wy_backgroundColor(_ color: UIColor, forState: UIControl.State) {
        
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        setBackgroundImage(colorImage, for: forState)
    }
    
    /** 设置按钮字号 */
    var wy_titleFont: UIFont {
        
        set {
            titleLabel?.font = newValue
        }
        
        get {
            return (titleLabel?.font)!
        }
    }
    
    /** 设置按钮左对齐 */
    func wy_leftAlignment() {
        contentHorizontalAlignment = .left
    }
    
    /** 设置按钮中心对齐 */
    func wy_centerAlignment() {
        contentHorizontalAlignment = .center
    }
    
    /** 设置按钮右对齐 */
    func wy_rightAlignment() {
        contentHorizontalAlignment = .right
    }
    
    /** 设置按钮上对齐 */
    func wy_topAlignment() {
        contentVerticalAlignment = .top
    }
    
    /** 设置按钮下对齐 */
    func wy_bottomAlignment() {
        contentVerticalAlignment = .bottom
    }
    
    /**
     *  添加点击事件(interval > 0 时，可以在 interval 间隔时间内防止重复点击)
     *  interval 下次可点击的间隔时间
     */
    func wy_addHandler(interval: TimeInterval = 1, selector: @escaping IntervalSelector) {
        addTarget(self, action: #selector(buttonDelayHandler(_:)) , for: .touchUpInside)
        selectorInterval = interval
        intervalSelector = selector
    }
    
    /**
     *  添加点击事件(interval > 0 时，可以在 interval 间隔时间内防止重复点击, 建议不要大于2秒，会影响内存释放)
     *  interval 下次可点击的间隔时间
     */
    func wy_addHandler(interval: TimeInterval = 1, target: Any, action: Selector) {
        addTarget(target, action: action, for: .touchUpInside)
        wy_addHandler(interval: interval) { _ in }
    }
}

public typealias IntervalSelector = ((UIButton)->Void)
private extension UIButton {
    
    private var intervalSelector: IntervalSelector? {
        
        set(newValue) {
            objc_setAssociatedObject(self, WYAssociatedKeys.intervalSelector, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.intervalSelector) as? IntervalSelector
        }
    }
    
    private var selectorInterval: TimeInterval {
        set {
            objc_setAssociatedObject(self, WYAssociatedKeys.selectorInterval, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.selectorInterval) as? TimeInterval ?? 0
        }
    }
    
    @objc private func buttonDelayHandler(_ button: UIButton) {
        intervalSelector?(button)
        isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + selectorInterval) { [weak self] in
            DispatchQueue.main.async {
                self?.isUserInteractionEnabled = true
            }
        }
    }
    
    struct WYAssociatedKeys {
        static let intervalSelector = UnsafeRawPointer(bitPattern: "IntervalSelector".hashValue)!
        static let selectorInterval = UnsafeRawPointer(bitPattern: "selectorInterval".hashValue)!
        static let positionKey = UnsafeRawPointer(bitPattern: "positionKey".hashValue)!
        static var spacingKey = UnsafeRawPointer(bitPattern: "spacingKey".hashValue)!
        static var imageViewSizeKey = UnsafeRawPointer(bitPattern: "imageViewSizeKey".hashValue)!
        static var titleLabelSizeKey = UnsafeRawPointer(bitPattern: "titleLabelSizeKey".hashValue)!
    }
}
