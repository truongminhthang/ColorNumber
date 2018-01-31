
//
//  UIImage+Extention.swift
//  ColorNumber
//
//  Created by ChungTran on 12/27/17.
//  Copyright © 2017 BigZero. All rights reserved.
//

import UIKit
import AVFoundation

extension UIImage {
    
    func imageWithColor(tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        tintColor.setFill()
        let context = UIGraphicsGetCurrentContext()! as CGContext
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0);
        context.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context.clip(to: rect, mask: self.cgImage!)
        //        tintColor.setFill()
        context.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

extension UIImage {
    func imageWithFixedOrientation() -> UIImage {
        
        if imageOrientation == UIImageOrientation.up {
            return self
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch imageOrientation {
        case UIImageOrientation.down, UIImageOrientation.downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
            break
        case UIImageOrientation.left, UIImageOrientation.leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi/2)
            break
        case UIImageOrientation.right, UIImageOrientation.rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: -(CGFloat.pi/2))
            break
        case UIImageOrientation.up, UIImageOrientation.upMirrored:
            break
        }
        
        switch imageOrientation {
        case UIImageOrientation.upMirrored, UIImageOrientation.downMirrored:
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case UIImageOrientation.leftMirrored, UIImageOrientation.rightMirrored:
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case UIImageOrientation.up, UIImageOrientation.down, UIImageOrientation.left, UIImageOrientation.right:
            break
        }
        
        let ctx: CGContext = CGContext(data: nil,
                                       width: Int(size.width),
                                       height: Int(size.height),
                                       bitsPerComponent: self.cgImage!.bitsPerComponent,
                                       bytesPerRow: 0,
                                       space: self.cgImage!.colorSpace!,
                                       bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        
        ctx.concatenate(transform)
        
        switch imageOrientation {
        case UIImageOrientation.left, UIImageOrientation.leftMirrored, UIImageOrientation.right, UIImageOrientation.rightMirrored:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            break
        }
        
        let cgImage: CGImage = ctx.makeImage()!
        
        return UIImage(cgImage: cgImage)
    }
}

extension UIImage {
    convenience init?(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        view.layer.render(in: context)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {return nil}
        UIGraphicsEndImageContext()
        self.init(cgImage: image.cgImage!)
    }
}




extension UIImage {
    func cropImageIfNeed(_ maxSize: CGSize) -> UIImage {
        let isTooBig = size.width  > maxSize.width || size.height > maxSize.height
        if isTooBig {
            let
            maxRect       = CGRect(origin: CGPoint.zero, size: maxSize),
            scaledRect    = AVMakeRect(aspectRatio: self.size, insideRect: maxRect),
            scaledSize    = scaledRect.size,
            targetRect    = CGRect(origin: CGPoint.zero, size: scaledSize),
            width         = Int(scaledSize.width),
            height        = Int(scaledSize.height),
            cgImage       = self.cgImage,
            bitsPerComp   = cgImage?.bitsPerComponent,
            compsPerPixel = 4, // RGBA
            bytesPerRow   = width * compsPerPixel,
            colorSpace    = cgImage?.colorSpace,
            bitmapInfo    = cgImage?.bitmapInfo,
            context       = CGContext(
                data: nil,
                width: width,
                height: height,
                bitsPerComponent: bitsPerComp!,
                bytesPerRow: bytesPerRow,
                space: colorSpace!,
                bitmapInfo: (bitmapInfo?.rawValue)!)
            
            if context != nil {
                context!.interpolationQuality = CGInterpolationQuality.low
                context?.draw(cgImage!, in: targetRect)
                if let scaledCGImage = context?.makeImage() {
                    return UIImage(cgImage: scaledCGImage)
                }
            }
        }
        return self
    }
}

// MARK: - <#Mark#>

extension UIImage {
    convenience init?(sampleBuffer : CMSampleBuffer) {
        // Get a CMSampleBuffer's Core Video image buffer for the media data
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil}
        // Lock the base address of the pixel buffer
        CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags.readOnly)
        
        
        // Get the number of bytes per row for the pixel buffer
        let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer)
        
        // Get the number of bytes per row for the pixel buffer
        let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer)
        // Get the pixel buffer width and height
        let width = CVPixelBufferGetWidth(imageBuffer)
        let height = CVPixelBufferGetHeight(imageBuffer)
        
        // Create a device-dependent RGB color space
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // Create a bitmap graphics context with the sample buffer data
        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Little.rawValue
        bitmapInfo |= CGImageAlphaInfo.premultipliedFirst.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        //let bitmapInfo: UInt32 = CGBitmapInfo.alphaInfoMask.rawValue
        let context = CGContext.init(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        // Create a Quartz image from the pixel data in the bitmap graphics context
        guard let quartzImage = context?.makeImage() else {return nil}
        
        // Unlock the pixel buffer
        CVPixelBufferUnlockBaseAddress(imageBuffer, CVPixelBufferLockFlags.readOnly)
        
        // Create an image object from the Quartz image
        self.init(cgImage: quartzImage, scale: 1, orientation: UIImageOrientation.right)
    }
}
