//
// GirdImageCollectionCell.swift 
// SwiftDemo 
// 
// Created by Linzy on 2019/4/9. 
// Copyright © 2019 Gosuncn. All rights reserved.
// 


import Foundation
import UIKit
import SnapKit
import Kingfisher

public class GirdImageCollectionCell : UICollectionViewCell{
    public let imageView = UIImageView()
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI() {
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.lightGray
        imageView.layer.masksToBounds = true
        imageView.snp.makeConstraints { (maker) in
            maker.leading.top.equalToSuperview().offset(8)
            maker.trailing.bottom.equalToSuperview().offset(-8)
        }
    }
}
