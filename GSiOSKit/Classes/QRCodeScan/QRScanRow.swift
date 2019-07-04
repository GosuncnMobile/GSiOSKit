//
// QRScanRow.swift 
// ACS-OM 
// 
// Created by Linzy on 2019/6/11. 
// Copyright © 2019 Gosuncn. All rights reserved.
// 

import UIKit
import Eureka
import SnapKit
import RxSwift
import RxCocoa

open class QRScanCell: _FieldCell<String>, CellType {
    
    public let sendBtn : UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    open override func setup() {
        super.setup()
        selectionStyle = .none
        addSubview(sendBtn)
        sendBtn.snp.makeConstraints { (maker) in
            maker.trailing.equalToSuperview().offset(-16)
            maker.centerY.equalToSuperview()
            maker.width.height.equalTo(48)
        }
        sendBtn.addTarget(self, action: #selector(sendAction), for: .touchUpInside)
        textField.keyboardType = .asciiCapable
    }
    
    open override func update() {
        super.update()
        textLabel?.textColor = UIColor.black
        textField.textColor = UIColor.gray
        textField.textAlignment = .left
        textField.placeholder = "请扫描或输入\(row.title ?? "")"
        sendBtn.isHidden = row.isDisabled
    }
    
    let disposeBag = DisposeBag()
    var timeDisposable : Disposable?

    @objc func sendAction(){
        if let navigationController = formViewController()?.navigationController {
            row.value = ""
            textField.text = ""
            let scanViewController = setUPQRCodeScanViewController()
            scanViewController.scanResultObservable.subscribe(onNext: { [weak self](result) in
                if let scanRow = self?.row as? QRScanRow{
                    scanRow.checkQRScanResult(qrcodeStr: result)
                }
            }).disposed(by: disposeBag)
            navigationController.pushViewController(scanViewController, animated: true)
        }
    }
    
    open func setUPQRCodeScanViewController() -> QRCodeScanViewController {
        let scanViewController = QRCodeScanViewController.init()
        sendBtn.setTitle("扫描", for: .normal)
        return scanViewController
    }
    
    
}

open class QRScanRow: Row<QRScanCell> {
    required public init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<QRScanCell>.init()
    }
    
    
    
    open func checkQRScanResult(qrcodeStr: String){
        
    }
    
    
}

