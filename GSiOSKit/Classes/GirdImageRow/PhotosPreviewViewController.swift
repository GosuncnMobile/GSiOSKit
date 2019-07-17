//
//  PhotosPreviewViewController.swift
//  GSiOSKit
//
//  Created by Linzy on 2019/7/17.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit

public class GSPhotosPreviewCollectionCell : UICollectionViewCell,PhotoPreviewViewDelegate{
    public func tapNoZoom() {
        UIApplication.shared.getTopUINavigationController()?.popViewController(animated: true)
    }
    
    public let imageView = PhotoPreviewView()
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindViewModel(datasource : GirdImageRowDateSource? = nil){
        datasource?.setGirdImageView(imageView: imageView.imageView)
    }
    
    func setUpUI() {
        addSubview(imageView)
        imageView.contentMode = .center
        imageView.backgroundColor = UIColor.black
        imageView.layer.masksToBounds = true
        imageView.snp.makeConstraints { (maker) in
            maker.leading.top.equalToSuperview()
            maker.trailing.bottom.equalToSuperview()
        }
      //  imageView.isUserInteractionEnabled = false
        imageView.photoPreviewDelegate = self
    }
    
    
}

public class PhotosPreviewViewController: UIViewController {
    //MARK: lifecycle
    let disposeBag = DisposeBag()
    public var photoDateSource = [GirdImageRowDateSource].init()
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.navigationBar.isHidden = true
        delayInit()
        //self.navigationController?.navigationBar.isTranslucent = false
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.navigationBar.isHidden = false
        
    }
    
    var currentPage = 0
    public convenience init(dateSource:[GirdImageRowDateSource],currentPage:Int,title:String) {
        self.init()
        photoDateSource.append(contentsOf: dateSource)
        setUpUI()
        pageControl.numberOfPages = dateSource.count
        collectView.dataSource = self
        collectView.delegate = self
        if currentPage < dateSource.count {
            self.currentPage = currentPage
            // pageControl.currentPage = currentPage
            print("scrollToItem")
            
        }
        self.title = title
    }
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        //collectView.reloadData()
        //        collectView.setContentOffset(CGPoint.init(x: (collectView.frame.size.width * CGFloat.init(currentPage)), y: 0),
        //                                                 animated: true)
        //       collectView.selectItem(at: IndexPath.init(row: currentPage, section: 0), animated: true, scrollPosition: .right)
        //        collectView.layoutIfNeeded()
        //        collectView.setContentOffset(CGPoint.init(x: (collectView.frame.size.width * CGFloat.init(currentPage)), y: 0),
        //                                                         animated: true)
        // collectView.scrollToItem(at: IndexPath.init(row: 1, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    //    public override func viewDidAppear(_ animated: Bool) {
    //        collectView.layoutIfNeeded()
    //        collectView.setContentOffset(CGPoint.init(x: (collectView.frame.size.width * CGFloat.init(currentPage)), y: 0),
    //                                     animated: false)
    //    }
    
    //MARK: - Business
    var hadDelayInit = false
    func delayInit() {
        if !hadDelayInit {
            hadDelayInit = true
            collectView.layoutIfNeeded()
            collectView.scrollToItem(at: IndexPath.init(row: currentPage, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    @objc func pageControlAction(){
          collectView.scrollToItem(at: IndexPath.init(row: pageControl.currentPage, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    
    
    //MARK: - SignalBinding
    func setupBinding() {
        
    }
    
    
    //MARK: - UI
    // let nextBtn = UIButton.init()
    let pageControl = UIPageControl.init()
    let collectView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        flowLayout.itemSize = UIScreen.main.bounds.size
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height), collectionViewLayout: flowLayout)
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.black
        collectionView.isScrollEnabled = true
        collectionView.register(GSPhotosPreviewCollectionCell.self, forCellWithReuseIdentifier: GSPhotosPreviewCollectionCell.description())
        return collectionView
    }()
    func setUpUI() {
        view.backgroundColor = UIColor.black
        view.addSubview(collectView)
        collectView.snp.makeConstraints { (maker) in
            maker.leading.trailing.top.bottom.equalToSuperview()
        }
        
        
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(16)
            maker.trailing.bottom.equalToSuperview().offset(-16)
        }
        
        pageControl.addTarget(self, action: #selector(pageControlAction), for: .touchUpInside)
    }
    
}


extension PhotosPreviewViewController : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectView.dequeueReusableCell(withReuseIdentifier: String(describing: GSPhotosPreviewCollectionCell.description()), for: indexPath) as? GSPhotosPreviewCollectionCell else{
            return UICollectionViewCell.init()
        }
        if indexPath.row >= photoDateSource.count{
            return cell
        }
        cell.bindViewModel(datasource: photoDateSource[indexPath.row])
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoDateSource.count
    }
    
    //    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //        return CGSize.init(width: collectionView.frame.width, height: collectionView.frame.height)
    //    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / UIScreen.main.bounds.width)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.popViewController(animated: true)
    }
}
