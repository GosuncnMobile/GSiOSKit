//
//  GSGridImageCollectionViewModel.swift
//  GSiOSKit
//
//  Created by Linzy on 2019/7/17.
//

import UIKit


public class GSGridImageCollectionViewModel : NSObject{
    let collectView = UICollectionView(frame: CGRect.zero, collectionViewLayout:UICollectionViewFlowLayout())
    var itemSize:CGFloat = 64
    var space:CGFloat = 8
    var maxSize:Int = 3
    public var photoDateSource = [GirdImageRowDateSource].init()
    
    override init() {
        super.init()
        setUpCollectView()
    }
    
    public convenience init(itemSize:CGFloat,space:CGFloat,maxSize:Int) {
        self.init()
        self.itemSize = itemSize
        self.space = space
        self.maxSize = maxSize
    }
    
    public func updataData(_ dateSource : [GirdImageRowDateSource]){
        photoDateSource.removeAll()
        photoDateSource.append(contentsOf: dateSource)
        collectView.reloadData()
    }
    
    func setUpCollectView()  {
        collectView.backgroundColor = UIColor.white
        collectView.dataSource = self
        collectView.delegate = self
        collectView.register(GirdImageCollectionCell.self, forCellWithReuseIdentifier: GirdImageCollectionCell.description())
    }
    
}

extension GSGridImageCollectionViewModel : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectView.dequeueReusableCell(withReuseIdentifier:GirdImageCollectionCell.description(), for: indexPath) as? GirdImageCollectionCell else{
            return UICollectionViewCell.init()
        }
        
        if indexPath.row >= photoDateSource.count{
            return cell
        }
        cell.bindViewModel(datasource: photoDateSource[indexPath.row],moreCount: (indexPath.row == (maxSize - 1)) ? (photoDateSource.count - maxSize) : 0)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if photoDateSource.count < maxSize{
            return photoDateSource.count
        }
        return maxSize
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: itemSize, height: itemSize)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return space
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIApplication.shared.getTopUINavigationController()?.pushViewController(PhotosPreviewViewController.init(dateSource: photoDateSource, currentPage: indexPath.row, title: "照片"), animated: true)
    }
    
}


