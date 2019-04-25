//
// QRCodeScanAnimation.swift 
// SwiftDemo 
// 
// Created by Linzy on 2019/4/24. 
// Copyright © 2019 Gosuncn. All rights reserved.
// 


import Foundation
import QuartzCore
import UIKit
import SnapKit

class QRCodeScanAnimation : NSObject{
    var displayLink : CADisplayLink?
    var scanView : UIView?
    var scanLine : UIView?
    var scanLineFrame = CGRect.zero
    
    init(scanView : UIView, color:UIColor = UIColor.gray) {
        super.init()
        self.scanView = scanView
        scanLine = UIView()
        scanLine?.backgroundColor = color
        self.scanView?.addSubview(scanLine!)
        scanLine?.snp.makeConstraints({ (maker) in
            maker.leading.equalToSuperview().offset(8)
            maker.trailing.equalToSuperview().offset(-8)
            maker.top.equalToSuperview()
            maker.height.equalTo(0.5)
        })
        setUpDisplayLink()
    }
    
    func setUpDisplayLink(){
        displayLink = CADisplayLink(target: self, selector: #selector(animation))
        displayLink?.add(to: .current, forMode: .common)
        displayLink?.isPaused = true
    }
    
    @objc func animation() {
        guard let scanLine = scanLine,
            let scanView = scanView else {
            return
        }
        if scanLine.frame.minY > scanView.frame.height{
            scanLine.frame = CGRect.init(x: scanLine.frame.minX, y: 0, width: scanLine.frame.width, height: scanLine.frame.height)
        }
        scanLine.transform = CGAffineTransform(translationX: 0, y: 1).concatenating(scanLine.transform)
    }
    
    func startAnimation()  {
        scanLineFrame = scanView?.frame ?? CGRect.zero
        displayLink?.isPaused = false
    }
    
    func stopAnimation()  {
        displayLink?.isPaused = true
    }
}
