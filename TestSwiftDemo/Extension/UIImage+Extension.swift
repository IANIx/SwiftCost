//
//  UIImage+Extension.swift
//  EJYUIKit
//
//  Created by macxjn on 2021/12/8.
//

import Foundation
import UIKit

// MARK: 1.1、基本的扩展
public extension UIImage {

    /// layer 转 image
    /// - Parameters:
    ///   - layer: layer 对象
    ///   - scale: 缩放比例
    /// - Returns: 返回转化后的 image
    static func image(from layer: CALayer, scale: CGFloat = 0.0) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, layer.isOpaque, scale)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: ctx)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }
    
    /// 将gif图分解为图片数组
    /// - Parameters:
    ///   - gif: gif名称
    /// - Returns: 带圆角的渐变的图片
    static func gifImgs(_ gif: String) -> [UIImage]? {
        let gifPath = Bundle.main.path(forResource: gif, ofType: "gif")
        
        guard let gifPath = gifPath else {
            print("\(gif).gif图不存在！")
            return nil
        }
        
        var gifData: Data?
        do {
            gifData = try Data.init(contentsOf: URL.init(fileURLWithPath: gifPath))
        } catch {
           print(error)
        }
        
        guard let gifData = gifData else {
            return nil
        }
        let gifDataSource: CGImageSource = CGImageSourceCreateWithData(gifData as CFData, nil)!
        let gifImageCount: NSInteger = CGImageSourceGetCount(gifDataSource)
        
        var images: [UIImage] = []
        for index in 0...gifImageCount-1 {
            let imageref: CGImage? = CGImageSourceCreateImageAtIndex(gifDataSource, index, nil)
            let image: UIImage = UIImage.init(cgImage: imageref!, scale: UIScreen.main.scale, orientation: .up)
            images.append(image)
        }
        return images
    }
    
    /// 生成指定的二维码图片
    /// - Parameters:
    ///   - codeString: 二维码字符串
    ///   - image: 二维码中心图片
    /// - Returns: 二维码图片
    static func qrcodeImage(_ codeString: String, image: UIImage? = nil) -> UIImage? {
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        filter?.setValue(codeString.data(using: String.Encoding.utf8), forKey: "inputMessage")

        if let outputImage = filter?.outputImage {
            let qrCodeImage = UIImage.highImage(outputImage, size: 300)
            if var image = image {
                image = image.border()
                let newImage = UIImage.syntheticImage(topImg: image,
                                                          bottomImg: qrCodeImage,
                                                          size: CGSize(width: 100, height: 100))
                return newImage
            }
            
            return qrCodeImage
        }
        return UIImage()
    }
    
    /// 生成高清图片
    /// - Parameters:
    ///   - image: 原始图片
    ///   - size: 图片大小
    /// - Returns: 高清图片
    static func highImage(_ image: CIImage, size: CGFloat) -> UIImage {
        let integral: CGRect = image.extent.integral
        let proportion: CGFloat = min(size/integral.width, size/integral.height)
        
        let width = integral.width * proportion
        let height = integral.height * proportion
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImage = context.createCGImage(image, from: integral)!
        
        bitmapRef.interpolationQuality = CGInterpolationQuality.none
        bitmapRef.scaleBy(x: proportion, y: proportion);
        bitmapRef.draw(bitmapImage, in: integral);
        let image: CGImage = bitmapRef.makeImage()!
        return UIImage(cgImage: image)
    }
    
    /// 合成两张图片
    /// - Parameters:
    ///   - image: 原始图片
    ///   - size: 图片大小
    /// - Returns: 高清图片
    static func syntheticImage(topImg: UIImage, bottomImg: UIImage, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(bottomImg.size)
        bottomImg.draw(in: CGRect(origin: CGPoint.zero, size: bottomImg.size))
        
        let x = (bottomImg.size.width - size.width) * 0.5
        let y = (bottomImg.size.height - size.height) * 0.5
        topImg.draw(in: CGRect(x: x, y: y, width: size.width, height: size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let newImage = newImage {
            return newImage
        }
        return UIImage()
    }
    
}

// MARK: 1.2、基础扩展
public extension UIImage {
    
    /// 设置图片的圆角
    /// - Parameters:
    ///   - radius: 圆角大小 (默认:3.0,图片大小)
    ///   - corners: 切圆角的方式
    ///   - imageSize: 图片的大小
    /// - Returns: 剪切后的图片
    func isRoundCorner(radius: CGFloat = 3, byRoundingCorners corners: UIRectCorner = .allCorners, imageSize: CGSize?) -> UIImage? {
        let weakSize = imageSize ?? size
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: weakSize)
        // 开始图形上下文
        UIGraphicsBeginImageContextWithOptions(weakSize, false, UIScreen.main.scale)
        guard let contentRef: CGContext = UIGraphicsGetCurrentContext() else {
            // 关闭上下文
            UIGraphicsEndImageContext();
            return nil
        }
        // 绘制路线
        contentRef.addPath(UIBezierPath(roundedRect: rect,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius)).cgPath)
        // 裁剪
        contentRef.clip()
        // 将原图片画到图形上下文
        draw(in: rect)
        contentRef.drawPath(using: .fillStroke)
        guard let output = UIGraphicsGetImageFromCurrentImageContext() else {
        // 关闭上下文
            UIGraphicsEndImageContext();
            return nil
        }
       // 关闭上下文
        UIGraphicsEndImageContext();
        return output
    }
    
    /// 设置图片边框
    /// - Parameters:
    ///   - borderWidth: 边框宽度
    ///   - borderColor: 边框颜色
    /// - Returns: 剪切后的图片
    func border(borderWidth: CGFloat = 5, borderColor: UIColor = .white) -> UIImage {
        let imageWidth = size.width + 2 * borderWidth
        let imageHeight = size.height + 2 * borderWidth
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: imageWidth, height: imageHeight), false, 0.0)
        UIGraphicsGetCurrentContext()
        
        let radius = (size.width < size.height ? size.width : size.height) * 0.5
        let bezierPath = UIBezierPath(arcCenter: CGPoint(x: imageWidth * 0.5, y: imageHeight * 0.5),
                                      radius: radius,
                                      startAngle: 0,
                                      endAngle: .pi * 2,
                                      clockwise: true)
        bezierPath.lineWidth = borderWidth
        borderColor.setStroke()
        bezierPath.stroke()
        bezierPath.addClip()
        draw(in: CGRect(x: borderWidth, y: borderWidth, width: size.width, height: size.height))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }

    /// 设置圆形图片
    /// - Returns: 圆形图片
    func isCircleImage() -> UIImage? {
        return isRoundCorner(radius: (self.size.width < self.size.height ? self.size.width : self.size.height) / 2.0, byRoundingCorners: .allCorners, imageSize: self.size)
    }
    
    /// 设置图片透明度
    /// alpha: 透明度
    /// - Returns: newImage
    func imageByApplayingAlpha(_ alpha: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        let area = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context?.scaleBy(x: 1, y: -1)
        context?.translateBy(x: 0, y: -area.height)
        context?.setBlendMode(.multiply)
        context?.setAlpha(alpha)
        context?.draw(self.cgImage!, in: area)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self
    }

    /// 裁剪给定区域
    /// - Parameter crop: 裁剪区域
    /// - Returns: 剪裁后的图片
     func cropWithCropRect( _ crop: CGRect) -> UIImage? {
        let cropRect = CGRect(x: crop.origin.x * self.scale, y: crop.origin.y * self.scale, width: crop.size.width * self.scale, height: crop.size.height *  self.scale)
        if cropRect.size.width <= 0 || cropRect.size.height <= 0 {
            return nil
        }
       var image:UIImage?
        autoreleasepool{
            let imageRef: CGImage?  = self.cgImage!.cropping(to: cropRect)
            if let imageRef = imageRef {
                image = UIImage(cgImage: imageRef)
            }
        }
        return image
    }

    /// 给图片添加文字水印
    /// - Parameters:
    ///   - drawTextframe: 水印的 frame
    ///   - drawText: 水印文字
    ///   - withAttributes: 水印富文本
    /// - Returns: 返回水印图片
    func drawTextInImage(drawTextframe: CGRect, drawText: String, withAttributes: [NSAttributedString.Key : Any]? = nil) -> UIImage {
        // 开启图片上下文
        UIGraphicsBeginImageContext(self.size)
        // 图形重绘
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        // 水印文字属性
        let attributes = withAttributes
        // 水印文字和大小
        let text = NSString(string: drawText)
        // 获取富文本的 size
        // let size = text.size(withAttributes: attributes)
        // 绘制文字
        text.draw(in: drawTextframe, withAttributes: attributes)
        // 从当前上下文获取图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        // 关闭上下文
        UIGraphicsEndImageContext()
    
        return image!
    }
    
    /// 将图片压缩到指定大小
    /// - Parameters:
    ///   - maxLength: 最大图片data大小
    /// - Returns: 图片data
    func zip(_ maxLength: Int) -> Data? {
        
        var compression: CGFloat = 1
        var data = jpegData(compressionQuality: compression)
        
        while let length = data?.count,
              length > maxLength && compression > 0 {
            compression -= 0.02
            data = jpegData(compressionQuality: compression)
        }
        return data
    }
    
    /// 根据尺寸重新生成图片
     ///
     /// - Parameter size: 设置的大小
     /// - Returns: 新的image
    func newSize(size: CGSize) -> UIImage? {
     
         if self.size.height > size.height {
             
             let width = size.height / self.size.height * self.size.width
             let newImgSize = CGSize(width: width, height: size.height)
             UIGraphicsBeginImageContext(newImgSize)
             self.draw(in: CGRect(x: 0, y: 0, width: newImgSize.width, height: newImgSize.height))
             let theImage = UIGraphicsGetImageFromCurrentImageContext()
             UIGraphicsEndImageContext()
             
             guard let newImg = theImage else { return  nil}
             return newImg
             
         } else {
             
             let newImgSize = CGSize(width: size.width, height: size.height)
             UIGraphicsBeginImageContext(newImgSize)
             self.draw(in: CGRect(x: 0, y: 0, width: newImgSize.width, height: newImgSize.height))
             let theImage = UIGraphicsGetImageFromCurrentImageContext()
             UIGraphicsEndImageContext()
             
             guard let newImg = theImage else { return  nil}
             return newImg
         }
     
     }

}

// MARK: 2.1、UIColor 生成的图片 和 生成渐变色图片
public extension UIImage {

    /// 生成指定尺寸的纯色图像
    /// - Parameters:
    ///   - color: 图片颜色
    ///   - size: 图片尺寸
    /// - Returns: 返回对应的图片
    static func image(color: UIColor, size: CGSize = CGSize(width: 1.0, height: 1.0)) -> UIImage? {
        return image(color: color, size: size, corners: .allCorners, radius: 0)
    }

    /// 生成指定尺寸和圆角的纯色图像
    /// - Parameters:
    ///   - color: 图片颜色
    ///   - size: 图片尺寸
    ///   - corners: 剪切的方式
    ///   - round: 圆角大小
    /// - Returns: 返回对应的图片
    static func image(color: UIColor, size: CGSize, corners: UIRectCorner, radius: CGFloat) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        if radius > 0 {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            color.setFill()
            path.fill()
        } else {
            context?.setFillColor(color.cgColor)
            context?.fill(rect)
        }
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }

    enum GradientDirection {
        case horizontal // 水平从左到右
        case vertical // 垂直从上到下
        case leftOblique // 左上到右下
        case rightOblique // 右上到左下
        case other(CGPoint, CGPoint)
    
        public func point(size: CGSize) -> (CGPoint, CGPoint) {
            switch self {
            case .horizontal:
                return (CGPoint.init(x: 0, y: 0), CGPoint.init(x: size.width, y: 0))
            case .vertical:
                return (CGPoint.init(x: 0, y: 0), CGPoint.init(x: 0, y: size.height))
            case .leftOblique:
                return (CGPoint.init(x: 0, y: 0), CGPoint.init(x: size.width, y: size.height))
            case .rightOblique:
                return (CGPoint.init(x: size.width, y: 0), CGPoint.init(x: 0, y: size.height))
            case .other(let stat, let end):
                return (stat, end)
            }
        }
    }

    /// 生成渐变色的图片 ["#B0E0E6", "#00CED1", "#2E8B57"]
    /// - Parameters:
    ///   - hexsString: 十六进制字符数组
    ///   - size: 图片大小
    ///   - locations: locations 数组
    ///   - direction: 渐变的方向
    /// - Returns: 渐变的图片
    static func gradient(_ hexsString: [String], size: CGSize = CGSize(width: 10, height: 10), locations:[CGFloat]? = nil, direction: GradientDirection = .horizontal) -> UIImage? {
        return gradient(hexsString.map{ UIColor.hexStringColor(hexString: $0) }, size: size, locations: locations, direction: direction)
    }

    /// 生成渐变色的图片 [UIColor, UIColor, UIColor]
    /// - Parameters:
    ///   - colors: UIColor 数组
    ///   - size: 图片大小
    ///   - locations: locations 数组
    ///   - direction: 渐变的方向
    /// - Returns: 渐变的图片
    static func gradient(_ colors: [UIColor], size: CGSize = CGSize(width: 10, height: 10), locations:[CGFloat]? = nil, direction: GradientDirection = .horizontal) -> UIImage? {
        return gradient(colors, size: size, radius: 0, locations: locations, direction: direction)
    }

    /// 生成带圆角渐变色的图片 [UIColor, UIColor, UIColor]
    /// - Parameters:
    ///   - colors: UIColor 数组
    ///   - size: 图片大小
    ///   - radius: 圆角
    ///   - locations: locations 数组
    ///   - direction: 渐变的方向
    /// - Returns: 带圆角的渐变的图片
    static func gradient(_ colors: [UIColor],
                         size: CGSize = CGSize(width: 10, height: 10),
                         radius: CGFloat,
                         locations:[CGFloat]? = nil,
                         direction: GradientDirection = .horizontal) -> UIImage? {
        if colors.count == 0 { return nil }
        if colors.count == 1 {
            return UIImage.image(color: colors[0])
        }
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height), cornerRadius: radius)
        path.addClip()
        context?.addPath(path.cgPath)
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors.map{$0.cgColor} as CFArray, locations: locations?.map { CGFloat($0) }) else { return nil
        }
        let directionPoint = direction.point(size: size)
        context?.drawLinearGradient(gradient, start: directionPoint.0, end: directionPoint.1, options: .drawsBeforeStartLocation)
    
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
