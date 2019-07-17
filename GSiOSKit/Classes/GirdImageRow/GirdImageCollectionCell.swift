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
    
    public func bindViewModel(datasource : GirdImageRowDateSource? = nil,moreCount:Int = 0){
        datasource?.setGirdImageView(imageView: imageView)
        if moreCount > 0{
            moreLabel.isHidden = false
            moreLabel.text = "+ \(moreCount)"
        }else{
            moreLabel.isHidden = true
        }
    }
    
    let moreLabel = UILabel.init()
    func setUpUI() {
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.lightGray
        imageView.layer.masksToBounds = true
        imageView.snp.makeConstraints { (maker) in
            maker.leading.top.equalToSuperview()
            maker.trailing.bottom.equalToSuperview()
        }
        addSubview(moreLabel)
        moreLabel.textColor = UIColor.white
        moreLabel.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        moreLabel.textAlignment = .center
        moreLabel.snp.makeConstraints { (maker) in
            maker.leading.top.equalToSuperview()
            maker.trailing.bottom.equalToSuperview()
        }
        moreLabel.isHidden = true
    }
}
