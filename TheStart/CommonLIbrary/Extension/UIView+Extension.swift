//
//  UIColor+Extension.swift
//  BossJob
//
//  Created by zhaoyuanjing on 2017/09/26.
//  Copyright © 2017年 zhaoyuanjing. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIView的扩展
extension UIView {
    
    
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
    
    public func x() -> CGFloat{
        return self.frame.origin.x
    }
    
    
    public func y() -> CGFloat{
        return self.frame.origin.y
    }
    
}
