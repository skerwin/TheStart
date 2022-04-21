//
//  UIView+Extension.swift
//
//

import Foundation
import UIKit


extension UIView {
    
    /**
     依照图片轮廓对控制进行裁剪
     
     - parameter stretchImage:  模子图片
     - parameter stretchInsets: 模子图片的拉伸区域
     */
    func clipShape(stretchImage: UIImage, stretchInsets: UIEdgeInsets) {
        // 绘制 imageView 的 bubble layer
        let bubbleMaskImage = stretchImage.resizableImage(withCapInsets: stretchInsets, resizingMode: .stretch)
        
        // 设置图片的mask layer
        let layer = CALayer()
        layer.contents = bubbleMaskImage.cgImage
        layer.contentsCenter = self.CGRectCenterRectForResizableImage(bubbleMaskImage)
        layer.frame = self.bounds
        layer.contentsScale = UIScreen.main.scale
        layer.opacity = 1
        self.layer.mask = layer
        self.layer.masksToBounds = true
    }
    
    func CGRectCenterRectForResizableImage(_ image: UIImage) -> CGRect {
        return CGRect(
            x: image.capInsets.left / image.size.width,
            y: image.capInsets.top / image.size.height,
            width: (image.size.width - image.capInsets.right - image.capInsets.left) / image.size.width,
            height: (image.size.height - image.capInsets.bottom - image.capInsets.top) / image.size.height
        )
    }
    
    /// 裁剪 view 的圆角
    func clipRectCorner(direction: UIRectCorner, cornerRadius: CGFloat) {
        let cornerSize = CGSize(width: cornerRadius, height: cornerRadius)
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: direction, cornerRadii: cornerSize)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.addSublayer(maskLayer)
        layer.mask = maskLayer
    }
    
    /// 将View画成图
    func trans2Image() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0)
        let ctx = UIGraphicsGetCurrentContext()
        self.layer.render(in: ctx!)
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImg
    }
    
    public var x: CGFloat{
        get{
            return self.frame.origin.x
        }
        set{
            var r = self.frame
            r.origin.x = newValue
            self.frame = r
        }
    }

    public var y: CGFloat{
        get{
            return self.frame.origin.y
        }
        set{
            var r = self.frame
            r.origin.y = newValue
            self.frame = r
        }
    }
    /// 右边界的x值
    public var rightX: CGFloat{
        get{
            return self.x + self.width
        }
        set{
            var r = self.frame
            r.origin.x = newValue - frame.size.width
            self.frame = r
        }
    }
    /// 下边界的y值
    public var bottomY: CGFloat{
        get{
            return self.y + self.height
        }
        set{
            var r = self.frame
            r.origin.y = newValue - frame.size.height
            self.frame = r
        }
    }

    public var centerX : CGFloat{
        get{
            return self.center.x
        }
        set{
            self.center = CGPoint(x: newValue, y: self.center.y)
        }
    }

    public var centerY : CGFloat{
        get{
            return self.center.y
        }
        set{
            self.center = CGPoint(x: self.center.x, y: newValue)
        }
    }

    public var width: CGFloat{
        get{
            return self.frame.size.width
        }
        set{
            var r = self.frame
            r.size.width = newValue
            self.frame = r
        }
    }
    public var height: CGFloat{
        get{
            return self.frame.size.height
        }
        set{
            var r = self.frame
            r.size.height = newValue
            self.frame = r
        }
    }


    public var origin: CGPoint{
        get{
            return self.frame.origin
        }
        set{
            self.x = newValue.x
            self.y = newValue.y
        }
    }

    public var size: CGSize{
        get{
            return self.frame.size
        }
        set{
            self.width = newValue.width
            self.height = newValue.height
        }
    }

    
    
    
    
    func addcornerRadius(radius:CGFloat){
         self.layer.cornerRadius = radius
         self.layer.masksToBounds = true;
    }
    
    func addOnClickListener(target: AnyObject, action: Selector) {
        let gr = UITapGestureRecognizer(target: target, action: action)
        gr.numberOfTapsRequired = 1
        isUserInteractionEnabled = true
        addGestureRecognizer(gr)
    }
    
  
    
 
     func removeAllSubViews() {
        for subView: UIView in self.subviews {
            subView.removeFromSuperview()
        }
    }
    
    func showLoading() {
        hideLoading()
        let loadingView = UIActivityIndicatorView(style:
            UIActivityIndicatorView.Style.gray)
        loadingView.center = self.center
        addSubview(loadingView)
        bringSubviewToFront(loadingView)
        loadingView.startAnimating()
    }
    
    func hideLoading() {
        for subView: UIView in self.subviews {
            if subView.isKind(of:UIActivityIndicatorView.self) {
                var indicatorView = subView as? UIActivityIndicatorView
                if indicatorView!.isAnimating {
                    indicatorView!.stopAnimating()
                    indicatorView = nil
                }
            }
        }
    }
    
    //画线
    private func drawBorder(rect:CGRect,color:UIColor){
        let line = UIBezierPath(rect: rect)
        let lineShape = CAShapeLayer()
        lineShape.path = line.cgPath
        lineShape.fillColor = color.cgColor
        self.layer.addSublayer(lineShape)
    }
    
    //设置右边框
    public func rightBorder(width:CGFloat,borderColor:UIColor,height:CGFloat){
        let rect = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: height)
        drawBorder(rect: rect, color: borderColor)
    }
    //设置左边框
    public func leftBorder(width:CGFloat,borderColor:UIColor,height:CGFloat){
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        drawBorder(rect: rect, color: borderColor)
    }
    
    //设置上边框
    public func topBorder(width:CGFloat,borderColor:UIColor){
        let rect = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        drawBorder(rect: rect, color: borderColor)
    }
    
    
    //设置底边框
    public func buttomBorder(width:CGFloat,borderColor:UIColor){
        let rect = CGRect(x: 0, y: self.frame.size.height-width, width: self.frame.size.width, height: width)
        drawBorder(rect: rect, color: borderColor)
    }
    
    public func getWidth() -> CGFloat{
       
        return self.frame.size.width
        
    }
    
    
    public func getHight() -> CGFloat{
        return self.frame.size.height
    }
 
    public func left() -> CGFloat{
        return self.frame.origin.x
    }
 
    public func right() -> CGFloat{
        return self.frame.origin.x + self.frame.size.width
    }
    
 
    public func top() -> CGFloat{
        return self.frame.origin.y
    }
    
    public func bottom() -> CGFloat{
        return self.frame.origin.y + self.frame.size.height
    }
    
    
    
}
