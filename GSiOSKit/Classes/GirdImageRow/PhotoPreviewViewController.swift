//
// PhotoPreviewViewController.swift 
// SwiftDemo 
// 
// Created by Linzy on 2019/4/22. 
// Copyright © 2019 Gosuncn. All rights reserved.
// 


import Foundation
import UIKit
import SnapKit

public class PhotoPreviewViewController: UIViewController {
    let photoPreviewView = PhotoPreviewView()
    var imagesource : Any?
    
   convenience init(imagesource:Any) {
        self.init()
        self.imagesource = imagesource
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad();
        self.view.addSubview(photoPreviewView)
        self.view.backgroundColor = UIColor.black
        self.navigationItem.title = "图片预览"
        photoPreviewView.snp.makeConstraints { (maker) in
            maker.leading.top.trailing.bottom.equalToSuperview()
        }
        let datasource = imagesource
        if let url = datasource as? URL{
            photoPreviewView.imageView.kf.setImage(with: url)
        }else if let tImage = datasource as? UIImage{
            photoPreviewView.imageView.image = tImage
        }
        else if let imageholder = datasource as? GirdImageRowDateSource{
            imageholder.setGirdImageView(imageView: photoPreviewView.imageView)
        }else {
            print("datasource as not GirdImageRowDateSource")
        }
    }
}
