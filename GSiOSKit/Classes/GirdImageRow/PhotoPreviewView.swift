//
// PhotoPreviewView.swift 
// SwiftDemo 
// 
// Created by Linzy on 2019/4/22. 
// Copyright © 2019 Gosuncn. All rights reserved.
// 


import UIKit
import SnapKit

public protocol PhotoPreviewViewDelegate : NSObjectProtocol {
    func tapNoZoom()
}

public class PhotoPreviewView: UIView {
    private let scrollView = UIScrollView()
    public let imageView = UIImageView()
    public var photoPreviewDelegate : PhotoPreviewViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(scrollView)
        setUpScrollView()
        scrollView.addSubview(imageView)
        setUpImageView()
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(doubleTap))
        tap2.numberOfTapsRequired = 2
        self.addGestureRecognizer(tap2)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(tapNoZoom))
        tap1.numberOfTapsRequired = 1
        self.addGestureRecognizer(tap1)
    }
    
    @objc func doubleTap(tap:UITapGestureRecognizer) {
        let centerPoint = tap.location(in: self.imageView)
        let xSize = self.frame.size.width / 2;
        let ySize = self.frame.size.width / 2;
        let tranRect = CGRect(x: centerPoint.x - xSize/2, y: centerPoint.y - ySize/2, width: xSize, height: ySize)
        scrollView.zoom(to:tranRect , animated: true)
    }
    
    @objc func tapNoZoom(tap:UITapGestureRecognizer) {
        if scrollView.zoomScale == 1 {
            photoPreviewDelegate?.tapNoZoom()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpScrollView() {
        scrollView.snp.makeConstraints { (maker) in
            maker.leading.bottom.trailing.top.equalToSuperview()
        }
        scrollView.bouncesZoom = true;
        scrollView.maximumZoomScale = 3.0
        scrollView.minimumZoomScale = 1.0
        scrollView.isMultipleTouchEnabled = true
        scrollView.scrollsToTop = false
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.autoresizingMask = .flexibleWidth
        scrollView.delaysContentTouches = false
        scrollView.canCancelContentTouches = true
        scrollView.alwaysBounceVertical = false
        scrollView.delegate = self
    }
    
    func setUpImageView() {
        imageView.snp.makeConstraints { (maker) in
            maker.leading.bottom.trailing.top.equalToSuperview()
            maker.width.equalTo(UIScreen.main.bounds.size.width)
        }
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.black
    }
    
    
    
}

extension PhotoPreviewView : UIScrollViewDelegate{
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
}
