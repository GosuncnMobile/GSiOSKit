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

public protocol GirdImageCollectionCellDelegate : NSObjectProtocol {
    func didTapDelete(_ indexPath:IndexPath)
}

public class GirdImageCollectionCell : UICollectionViewCell{
    public let imageView = UIImageView()
    public weak var girdImageCollectionCellDelegate : GirdImageCollectionCellDelegate?
    
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
    
    var indexPath : IndexPath?
    @objc func deleteAction(){
        if let indexPath = indexPath{
            girdImageCollectionCellDelegate?.didTapDelete(indexPath)
        }
    }
    
    public func setDelete(show:Bool = false ,indexPath:IndexPath){
        self.indexPath = indexPath
        deleteBtn.isHidden = !show
    }
    
    let moreLabel = UILabel.init()
    let deleteBtn = UIButton.init()
    func setUpUI() {
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.lightGray
        imageView.layer.masksToBounds = true
        imageView.snp.makeConstraints { (maker) in
            maker.leading.top.equalToSuperview().offset(4)
            maker.trailing.bottom.equalToSuperview().offset(-4)
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
        
        addSubview(deleteBtn)
        deleteBtn.setImage(UIImage.init(GSAssetName: "btn_imgdelete"), for: .normal)
        deleteBtn.snp.makeConstraints { (maker) in
            maker.trailing.top.equalToSuperview()
            maker.width.height.equalTo(48)
        }
        deleteBtn.isHidden = true
        deleteBtn.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
    }
}


public class GirdAddImageCollectionCell : UICollectionViewCell{
    public let imageView = UIImageView()
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func bindViewModel(datasource : GirdImageRowDateSource? = nil,moreCount:Int = 0){
     
    }

    
    let moreLabel = UILabel.init()
  
    func setUpUI() {
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.lightGray
        imageView.layer.masksToBounds = true
        imageView.snp.makeConstraints { (maker) in
            maker.leading.top.equalToSuperview().offset(4)
            maker.trailing.bottom.equalToSuperview().offset(-4)
        }
        addSubview(moreLabel)
        moreLabel.textColor = UIColor.white
        moreLabel.text = "+"
        moreLabel.font = UIFont.systemFont(ofSize: 60)
        moreLabel.textAlignment = .center
        moreLabel.snp.makeConstraints { (maker) in
            maker.leading.top.equalToSuperview()
            maker.trailing.bottom.equalToSuperview()
        }

    }
}
