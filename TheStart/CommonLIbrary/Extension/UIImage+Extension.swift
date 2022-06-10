//
//  UIImage+Extension.swift
 //
//  Created by YuliangTao on 16/2/25.
//  Copyright © 2016年 Berchina.Mobile. All rights reserved.
//  UIImage的扩展

import Foundation
import UIKit

extension UIImage {
    
    
    class func image(for named: String?) -> UIImage? {
        return self.init(named: named!)
    }
    
    func scaleSuitableSize() -> UIImage? {
        var imageSize = self.size
        while imageSize.width * imageSize.height > 3 * 1000 * 1000 {
            imageSize.width *= 0.5
            imageSize.height *= 0.5
        }
        return self.scaleToFillSize(size: imageSize)
    }
    func scaleToFillSize(size: CGSize) -> UIImage? {
        if __CGSizeEqualToSize(self.size, size) {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    class func image(for color: UIColor?, havingSize: CGSize) -> UIImage? {
        if let color = color {
            let rect: CGRect
            if havingSize.equalTo(CGSize.zero) {
                rect = CGRect(x: 0, y: 0, width: 1, height: 1)
            }else {
                rect = CGRect(x: 0, y: 0, width: havingSize.width, height: havingSize.height)
            }
            UIGraphicsBeginImageContext(rect.size)
            let context = UIGraphicsGetCurrentContext()
            context?.setFillColor(color.cgColor)
            context?.fill(rect)
        
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
        return nil
    }
    
    func normalizedImage() -> UIImage? {
        if imageOrientation == .up {
            return self
        }
        return repaintImage()
    }
    func repaintImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    class func gradualShadowImage(_ havingSize: CGSize) -> UIImage? {
        let layer = CAGradientLayer.init()
        layer.contentsScale = UIScreen.main.scale
        let blackColor = UIColor.black
        layer.colors = [blackColor.withAlphaComponent(0).cgColor,
                        blackColor.withAlphaComponent(0.3).cgColor,
                        blackColor.withAlphaComponent(0.4).cgColor,
                        blackColor.withAlphaComponent(0.5).cgColor,
                        blackColor.withAlphaComponent(0.6).cgColor]
        layer.startPoint = CGPoint(x: 0, y: 1)
        layer.endPoint = CGPoint(x: 0, y: 0)
        layer.locations = [0.1, 0.3, 0.5, 0.7, 0.9]
        layer.borderWidth = 0.0
        layer.frame = CGRect(origin: .zero, size: havingSize)
        UIGraphicsBeginImageContextWithOptions(havingSize, false, UIScreen.main.scale)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    
    // 图片拉伸
    class func stretchImageWithName(imageName: String)-> UIImage {
    
    // 加载原有图片
    let norImage = UIImage(named: imageName)
    // 获取原有图片的宽高的一半
    let w: CGFloat = norImage!.size.width * 0.5;
    let top: CGFloat = norImage!.size.height * 0.5;
    let bottom: CGFloat = norImage!.size.height-top;
    // 生成可以拉伸指定位置的图片
        let newImage = norImage?.resizableImage(withCapInsets: UIEdgeInsets(top: top, left: w, bottom: bottom, right: w), resizingMode: .stretch)
        
    return newImage!
        
    }
    
    //按照尺寸裁剪图片大小
    class func cropImage2NewImage(image: UIImage, newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(origin: CGPoint(), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func cropImage2NewImage(newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        draw(in: CGRect(origin: CGPoint(), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    //颜色转图片
    class func imageWithColor(color:UIColor) -> UIImage {
        let rect:CGRect = CGRect.init(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
         UIGraphicsBeginImageContext(rect.size)
        let context:CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

//    //通过颜色
//    func imageWithColor(color:UIColor) ->UIImage{
//        let rect = CGRect.init(x: 0, y: 0, width: 1, height: 1)
//        UIGraphicsBeginImageContext(rect.size)
//        let context = UIGraphicsGetCurrentContext()
//
//        context?.setFillColor(color.cgColor)
//        context?.fill(rect)
//
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext();
//        return image!
//
//    }
    // 置灰
    func grayScaleImage() -> UIImage {
        _ = CGRect.init(x: 0.0, y: 0.0, width:self.size.width, height:self.size.height)
        let colorSpace = CGColorSpaceCreateDeviceGray();

        let width = Int(self.size.width)
        let height = Int(self.size.height)
        let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: 0);
        
        //CGContextDrawImage(context, imageRect, self.CGImage!);

        let imageRef = context!.makeImage();
        let newImage = UIImage.init(cgImage: imageRef!)
        //(CGImage: imageRef!)
        return newImage
    }
    
    
    //gif处理
    
    public class func gif(data: Data) -> UIImage? {
        // Create source from data
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            //print("SwiftGif: Source for the image does not exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    public class func gif(url: String) -> UIImage? {
        // Validate URL
        guard let bundleURL = URL(string: url) else {
            //print("SwiftGif: This image named \"\(url)\" does not exist")
            return nil
        }
        
        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            //print("SwiftGif: Cannot turn image named \"\(url)\" into NSData")
            return nil
        }
        
        return gif(data: imageData)
    }
    
    public class func gif(name: String) -> UIImage? {
        // Check for existance of gif
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                //print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        
        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            //print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gif(data: imageData)
    }
    
    internal class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        // Get dictionaries
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        if CFDictionaryGetValueIfPresent(cfProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque(), gifPropertiesPointer) == false {
            return delay
        }
        
        let gifProperties:CFDictionary = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)
        
        // Get delay time
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                             Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as? Double ?? 0
        
        if delay < 0.1 {
            delay = 0.1 // Make sure they're not too fast
        }
        
        return delay
    }
    
    internal class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        // Check if one of them is nil
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        // Swap for modulo
        if a! < b! {
            let c = a
            a = b
            b = c
        }
        
        // Get greatest common divisor
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b! // Found it
            } else {
                a = b
                b = rest
            }
        }
    }
    
    internal class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    internal class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        // Fill arrays
        for i in 0..<count {
            // Add image
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            // At it's delay in cs
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                                                            source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        // Calculate full duration
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        // Get frames
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        // Heyhey
        let animation = UIImage.animatedImage(with: frames,
                                              duration: Double(duration) / 1000.0)
        
        return animation
    }
    
    
}

// 创建高斯模糊效果的背景
func createBlurBackground(image: UIImage, view: UIView, blurRadius: Float) {
    //处理原始NSData数据
    let originImage = UIImage.init(cgImage: image.cgImage!)
     //创建高斯模糊滤镜
    let filter = CIFilter(name: "CIGaussianBlur")
    filter!.setValue(originImage, forKey: kCIInputImageKey)
    filter!.setValue(NSNumber(value: blurRadius), forKey: "inputRadius")
    //生成模糊图片
    let context = CIContext(options: nil)
    let result:CIImage = filter!.value(forKey: kCIOutputImageKey) as! CIImage
    let blurImage = UIImage.init(cgImage: context.createCGImage(result, from: result.extent)!)
    //将模糊图片加入背景
    let w = view.frame.width
    let h = view.frame.height
    
    
    let blurImageView = UIImageView(frame: CGRect.init(x: -w/2, y: -h/2, width:w, height:h)) //模糊背景是界面的4倍大小
    blurImageView.contentMode = UIView.ContentMode.scaleAspectFill //使图片充满ImageView
    blurImageView.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
    blurImageView.autoresizingMask = UIView.AutoresizingMask.flexibleHeight//保持原图长宽比
    blurImageView.image = blurImage
    view.insertSubview(blurImageView, belowSubview: view) //保证模糊背景在原图片View的下层
}
