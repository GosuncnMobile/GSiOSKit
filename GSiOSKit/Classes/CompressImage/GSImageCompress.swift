//
// GSImageCompress.swift 
// GSiOSKit 
//
// 图片压缩算法
// Created by Linzy on 2019/6/19. 
// Copyright © 2019 Gosuncn. All rights reserved.
// 


import UIKit

extension UIImage{
    //仿微信策略,压缩图片成jpg
    //参考:https://github.com/ssj1314/SSJImage-Scan
    public func gs_compressImage(maxPx : Double = 1080,maxDataLength : Int = 204800) -> UIImage? {
        var newImage :UIImage? = nil
        
        let width = Double(self.size.width)
        let height = Double(self.size.height)
        var scaleFactor = 1.0
    
        //1.调整图片宽高
        //a.图片宽高均≤maxPx时，图片尺寸保持不变
        if width <= maxPx,height <= maxPx{
            
        }else if width > maxPx,height > maxPx{// b.宽或高均＞maxPx时
            if (width / height) > 2 {//超宽图片
                scaleFactor = maxPx / height
            }else if (height / width) > 2 {//超高图片
                scaleFactor = maxPx / width
            }else if height > width{
                scaleFactor =  maxPx / height
            }else {
                scaleFactor =   maxPx / width
            }
        }else if width > maxPx || height > maxPx{//c.只有一边＞maxPx时
            if !((width / height) > 2 || (height / width) > 2) {//超高图片,超宽图片不压缩
                 if height > width{
                    scaleFactor = maxPx / height
                }else {
                    scaleFactor = maxPx / width
                }
            }
        }
        
        if scaleFactor < 1.0{//图片大小压缩
            let resultSize = CGSize(width: scaleFactor * width, height: scaleFactor * height)
            UIGraphicsBeginImageContext(resultSize)
            self.draw(in: CGRect.init(x: 0, y: 0, width: resultSize.width, height: resultSize.height))
            newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }else{
            newImage = self
        }
        
        guard let resultImage = newImage else {
            return nil
        }
        
        guard let jpgData = resultImage.jpegData(compressionQuality: 1) else{
            return resultImage
        }
        //图片质量压缩
        //如果要必定压缩到maxDataLength,需要二分法确定到具体的compressionQuality
        //但是项目中不需要这么严格要求,所以简单制定一个策略,避免消耗太多性能
        if jpgData.count <= maxDataLength{
            return resultImage
        }else if jpgData.count <= (maxDataLength * 3),let tdata = resultImage.jpegData(compressionQuality: 0.4){
            return UIImage.init(data: tdata)
        }else if let tdata = resultImage.jpegData(compressionQuality: 0.1){
            return UIImage.init(data: tdata)
        }
        return nil
    }
    
    func fixOrientation() -> UIImage{
        if self.imageOrientation == .up {
            return self
        }
        
        var transform = CGAffineTransform.identity
        switch imageOrientation {
        case .down:
            fallthrough
        case .downMirrored:
            transform = CGAffineTransform.init(translationX: self.size.width, y: self.size.height)
            transform = CGAffineTransform.init(rotationAngle: 3.14159265358979323846264338327950288)
            break
        case .left:
            fallthrough
        case .leftMirrored:
            transform = CGAffineTransform.init(translationX: self.size.width, y: 0)
            transform = CGAffineTransform.init(rotationAngle: 1.57079632679489661923132169163975144)
            break
        case .right:
            fallthrough
        case .rightMirrored:
            transform = CGAffineTransform.init(translationX: 0, y: self.size.height)
            transform = CGAffineTransform.init(rotationAngle: -1.57079632679489661923132169163975144)
            break
         default:
            break
        }
        
        switch imageOrientation {
        case .upMirrored:
            fallthrough
        case .downMirrored:
            transform = CGAffineTransform.init(translationX: self.size.width, y: 0)
            transform = CGAffineTransform.init(scaleX: -1, y: 1)
            break
        case .leftMirrored:
            fallthrough
        case .rightMirrored:
            transform = CGAffineTransform.init(translationX: self.size.height, y: 0)
            transform = CGAffineTransform.init(scaleX: -1, y: 1)
            break
        default:
            break
        }
        
        guard let pCGImage = self.cgImage,
        let pcolorSpace = pCGImage.colorSpace else {
            return self
        }
        let tctx = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height),
                            bitsPerComponent: pCGImage.bitsPerComponent, bytesPerRow: 0,
                            space: pcolorSpace,
                            bitmapInfo: pCGImage.bitmapInfo.rawValue)
        guard let ctx = tctx else {
                return self
        }
        ctx.concatenate(transform)
        switch imageOrientation {
        case .left:
            fallthrough
        case .leftMirrored:
            fallthrough
        case .right:
            fallthrough
        case .rightMirrored:
            ctx.draw(pCGImage, in: CGRect.init(x: 0, y: 0, width: self.size.height, height: self.size.width))
            break;
        default:
            ctx.draw(pCGImage, in: CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height))
            break;
        }
        
        // And now we just create a new UIImage from the drawing context
        guard let cgimg = ctx.makeImage() else { return self };
        let img = UIImage.init(cgImage: cgimg)
        return img;
        
    }
    
}

public enum GSImageContentType : String {
    case jpeg = "jpeg"
    case png = "png"
}
