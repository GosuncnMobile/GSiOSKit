//
//  GirdImageRowDateSource.swift
//  GSiOSKit
//
//  Created by Linzy on 2019/7/17.
//

import UIKit

public protocol GirdImageRowDateSource {
    func setGirdImageView(imageView:UIImageView);
}



public class GridUrl: GirdImageRowDateSource,Equatable {
    public static func == (lhs: GridUrl, rhs: GridUrl) -> Bool {
        return lhs.girdUrl == rhs.girdUrl
    }
    
    public func setGirdImageView(imageView: UIImageView) {
        imageView.kf.setImage(with: URL(string: girdUrl))
    }
    
    var girdUrl: String
    public init(girdUrl: String) { self.girdUrl = girdUrl }
    
    
}

extension URL : GirdImageRowDateSource{
    public func setGirdImageView(imageView: UIImageView) {
        imageView.kf.setImage(with: self)
    }
}

extension String : GirdImageRowDateSource{
    public func setGirdImageView(imageView: UIImageView) {
        if let url = URL.init(string: self){
            imageView.kf.setImage(with: url)
        }else{
            imageView.image = nil
        }
    }
}
extension UIImage : GirdImageRowDateSource{
    public func setGirdImageView(imageView: UIImageView) {
        imageView.image = self
    }
}


