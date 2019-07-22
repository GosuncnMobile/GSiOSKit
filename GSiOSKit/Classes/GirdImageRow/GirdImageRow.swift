//
// GirdImageRow.swift 
// SwiftDemo 
// 用于采集图片,不会随着图片数目变换排版方式
// 不管图片上限有多少,固定平分九宫格
//  [1 2 3]
//  [4 5 6]
//  [7 8 9]
// Created by Linzy on 2019/4/4. 
// Copyright © 2019 Gosuncn. All rights reserved.
// 


import Foundation
import UIKit
import SnapKit
import Kingfisher
import Eureka
import Gallery

public final class _GridImageCell : Cell<NSMutableArray>, UICollectionViewDataSource,UICollectionViewDelegate,CellType {
    let screenWidth = UIScreen.main.bounds.size.width
   
    public var maxImageCount = 9
    
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
        collectView.register(GirdAddImageCollectionCell.self, forCellWithReuseIdentifier: String(describing: GirdAddImageCollectionCell.self))
        collectView.register(GirdImageCollectionCell.self, forCellWithReuseIdentifier: String(describing: GirdImageCollectionCell.self))
    }
    
    public func updateSize(){
        guard let flowLayout = collectView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        guard let itemcount = row.value?.count else {
            return
        }
        let itemSize = (screenWidth - 16) / 3
        switch itemcount {
        case 0...2:
            collectView.snp.updateConstraints { (maker) in
                maker.height.equalTo(itemSize + 16)
                maker.width.equalTo(screenWidth)
            }
        case 3...5:
            collectView.snp.updateConstraints { (maker) in
                maker.height.equalTo(itemSize * 2 + 16)
                maker.width.equalTo(screenWidth)
            }
        default:
            collectView.snp.updateConstraints { (maker) in
                maker.height.equalTo(screenWidth)
                maker.width.equalTo(screenWidth)
            }
        }
        flowLayout.itemSize = CGSize(width: itemSize, height: itemSize)
    }
    
    
    public override func update() {
        super.update()
        collectView.reloadData()
        updateSize()
        
    }
    
    public override func cellCanBecomeFirstResponder() -> Bool {
        return false;
    }
    
    //MARK: - CollectionView
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = row.value?.count ?? 0
        if count < maxImageCount{
            return count + 1
        }
        return maxImageCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        if indexPath.row == row.value?.count ?? 0{
            guard let cell = collectView.dequeueReusableCell(withReuseIdentifier: String(describing: GirdAddImageCollectionCell.self), for: indexPath) as? GirdAddImageCollectionCell else{
                return UICollectionViewCell.init()
            }
            return cell
        }else{
            guard let cell = collectView.dequeueReusableCell(withReuseIdentifier: String(describing: GirdImageCollectionCell.self), for: indexPath) as? GirdImageCollectionCell else{
                return UICollectionViewCell.init()
            }
            guard let datasource = row.value?.object(at: indexPath.row) as? GirdImageRowDateSource else{
                cell.imageView.image = nil
                return cell
            }
            cell.setDelete(show: true, indexPath: indexPath)
            cell.girdImageCollectionCellDelegate = self
            cell.bindViewModel(datasource: datasource, moreCount: 0)
            return cell
        }  
        return UICollectionViewCell.init()
    }
    

    
    lazy var imagePicker =  GSImagePicker.init(presentationController: UIApplication.shared.getTopUINavigationController() ?? UINavigationController.init())
  //  lazy var config = YPImagePickerConfiguration()
    lazy var galleryController : GalleryController = {
        let gallery = GalleryController.init()
        Config.Camera.recordLocation = false
        Config.tabsToShow = [.imageTab, .cameraTab]
        Config.Camera.imageLimit = 9
        Config.initialTab = .imageTab
        Config.Grid.ArrowButton.tintColor = UIApplication.shared.keyWindow?.tintColor ?? UIColor.blue
        Config.Grid.FrameView.borderColor = UIApplication.shared.keyWindow?.tintColor ?? UIColor.blue
        return gallery
        }()
    var cacheCart : Cart?
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == row.value?.count ?? 0,
            let topUINavigationController  = UIApplication.shared.getTopUINavigationController(){
            galleryController.delegate = self
            if let cacheImages = cacheCart?.images{
                galleryController.cart.reload(cacheImages)
            }
            topUINavigationController.present(galleryController, animated: true, completion: nil)
        }else if indexPath.row < row.value?.count ?? 0,
            let photos = row.value{
            var dataSource = [GirdImageRowDateSource].init()
            for photo in photos{
                if let pp = photo as? GirdImageRowDateSource {
                    dataSource.append(pp)
                }
            }
            UIApplication.shared.getTopUINavigationController()?.pushViewController(PhotosPreviewViewController.init(dateSource: dataSource, currentPage: indexPath.row, title: "照片"), animated: true)
            return
        }
    }
    
    
}

extension _GridImageCell : GalleryControllerDelegate{
    public func galleryController(_ controller: GalleryController, didSelectImages images: [Gallery.Image]) {
        cacheCart = controller.cart
        row.value?.removeAllObjects()
        Gallery.Image.resolve(images: images) { [weak self](resolveImages) in
            for image in resolveImages{
                if image != nil{
                    self?.row.value?.add(image)
                }
            }
            if let rowIndexPath = self?.row.indexPath{
                self?.formViewController()?.tableView.reloadRows(at: [rowIndexPath], with: .none)
            }else{
                self?.formViewController()?.tableView.reloadData()
            }
        }
         controller.dismiss(animated: true, completion: nil)
    }
    
    public func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    public func galleryController(_ controller: GalleryController, requestLightbox images: [Gallery.Image]) {
        print("requestLightbox")
      //  controller.dismiss(animated: true, completion: nil)
    }
    
    public func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}

extension _GridImageCell : GirdImageCollectionCellDelegate{
    public func didTapDelete(_ indexPath: IndexPath) {
        row.value?.removeObject(at: indexPath.row)
        if indexPath.row < cacheCart?.images.count ?? 0,
            let image = cacheCart?.images[indexPath.row]{
            cacheCart?.remove(image)
        }
        
        if let rowIndexPath = row.indexPath{
            formViewController()?.tableView.reloadRows(at: [rowIndexPath], with: .none)
//                .reloadRows(at: [rowIndexPath], with: .automatic)
        }else{
            formViewController()?.tableView.reloadData()
        }
    }
}



public final class GirdImageRow : Row<_GridImageCell>,RowType{
    
    public var maxImageCount = 9
    
    public required init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<_GridImageCell>.init()
        self.value = NSMutableArray.init()
    }
    
    public override func updateCell() {
        super.updateCell()
    }
    
    
}

