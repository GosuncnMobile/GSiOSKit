//
// GirdImageCell.swift 
// SwiftDemo 
// 
// Created by Linzy on 2019/4/9. 
// Copyright © 2019 Gosuncn. All rights reserved.
// 


import Foundation
import Eureka
import SnapKit



extension URL : GirdImageRowDateSource{
    public func setGirdImageView(imageView: UIImageView) {
        imageView.kf.setImage(with: self)
    }
}

public final class GridImageCell : Cell<NSMutableArray>, UICollectionViewDataSource,UICollectionViewDelegate,CellType {
    let screenWidth = UIScreen.main.bounds.size.width
    
    required public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let collectView = UICollectionView(frame: CGRect.zero, collectionViewLayout:UICollectionViewFlowLayout())
    
    public override func setup() {
        super.setup()
        self.addSubview(collectView)
        self.collectView.backgroundColor = UIColor.white
        
        let itemSize : CGFloat = ( screenWidth - 16 ) / 3
        
        collectView.snp.makeConstraints { (maker) in
            maker.leading.top.trailing.bottom.equalToSuperview()
            maker.height.equalTo(screenWidth)
            maker.width.equalTo(screenWidth)
        }
        guard let flowLayout = collectView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flowLayout.itemSize = CGSize(width: itemSize, height: itemSize)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        collectView.dataSource = self
        collectView.delegate = self
        collectView.register(GirdImageCollectionCell.self, forCellWithReuseIdentifier: String(describing: GirdImageCollectionCell.self))
    }
    
    public func updateSize(){
        guard let flowLayout = collectView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        guard let itemcount = row.value?.count else {
            return
        }
        var itemSize = screenWidth
        switch itemcount {
        case 1:
            itemSize = (screenWidth - 16)
            collectView.snp.updateConstraints { (maker) in
                maker.height.equalTo(screenWidth)
                maker.width.equalTo(screenWidth)
            }
        case 2:
            itemSize = (screenWidth - 16) / 2
            collectView.snp.updateConstraints { (maker) in
                maker.height.equalTo(screenWidth/2)
                maker.width.equalTo(screenWidth)
            }
        case 3...4:
            itemSize = (screenWidth - 16) / 2
            collectView.snp.updateConstraints { (maker) in
                maker.height.equalTo(screenWidth)
                maker.width.equalTo(screenWidth)
            }
        default:
            itemSize = (screenWidth - 16) / 3
            collectView.snp.updateConstraints { (maker) in
                maker.height.equalTo(screenWidth)
                maker.width.equalTo(screenWidth)
            }
        }
        flowLayout.itemSize = CGSize(width: itemSize, height: itemSize)
    }
    
    
    public override func update() {
        super.update()
        updateSize()
        collectView.reloadData()
    }
    
    public override func cellCanBecomeFirstResponder() -> Bool {
        return false;
    }
    
    //MARK: - CollectionView
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return row.value?.count ?? 0;
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectView.dequeueReusableCell(withReuseIdentifier: String(describing: GirdImageCollectionCell.self), for: indexPath) as? GirdImageCollectionCell else{
            return UICollectionViewCell.init()
        }
        
        guard let datasource = row.value?.object(at: indexPath.row) else{
            cell.imageView.image = nil
            return cell
        }
        if let url = datasource as? URL{
            cell.imageView.kf.setImage(with: url)
        }else if let tImage = datasource as? UIImage{
            cell.imageView.image = tImage
        }
        else if let imageholder = datasource as? GirdImageRowDateSource{
            imageholder.setGirdImageView(imageView: cell.imageView)
        }else {
            print("datasource as not GirdImageRowDateSource")
        }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let datasource = row.value?.object(at: indexPath.row) else{
           return
        }
        guard let rootVC = UIApplication.shared.keyWindow?.rootViewController else{
            print("rootVC nil")
            return;
        }
        var topVC = rootVC
        while let tVC = topVC.presentedViewController{
            topVC = tVC
        }
        guard let natVC = topVC as? UINavigationController else {
            let natVC = UINavigationController(rootViewController: PhotoPreviewViewController(imagesource: datasource))
                  natVC.pushViewController(PhotoPreviewViewController(imagesource: datasource), animated: true)
            return
        }
        natVC.pushViewController(PhotoPreviewViewController(imagesource: datasource), animated: true)
    }
    
    
    
}
