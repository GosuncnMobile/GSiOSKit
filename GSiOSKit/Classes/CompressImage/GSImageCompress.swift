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
    public func gs_compressImage(maxPx : Double = 1080,maxDataLength : Int = 204800) -> Data? {
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
            return resultImage.pngData()
        }
        //图片质量压缩
        //如果要必定压缩到maxDataLength,需要二分法确定到具体的compressionQuality
        //但是项目中不需要这么严格要求,所以简单制定一个策略,避免消耗太多性能
        if jpgData.count <= maxDataLength{
            return jpgData
        }else if jpgData.count <= (maxDataLength * 3){
            return resultImage.jpegData(compressionQuality: 0.4)
        }
        return resultImage.jpegData(compressionQuality: 0.1)
    }
    
}

public enum GSImageContentType : String {
    case jpeg = "jpeg"
    case png = "png"
}
