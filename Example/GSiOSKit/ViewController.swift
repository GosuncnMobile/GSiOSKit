//
//  ViewController.swift
//  GSiOSKit
//
//  Created by zoelam020@gmail.com on 04/25/2019.
//  Copyright (c) 2019 zoelam020@gmail.com. All rights reserved.
//

import UIKit
import Eureka
import GSiOSKit

class ViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        form +++ Section("Section1")
            +++ ButtonRow(){
                $0.title = "QRScan"
                $0.tag = "QRScan"
                }.onCellSelection({ (row, row1) in
                    let scanViewController = QRCodeScanViewController.init()
                    scanViewController.scanResultObservable.subscribe(onNext: { (result) in
                        print("扫描结果:\(result)")
                    })
                    self.navigationController?.pushViewController(scanViewController, animated: true)
                })
            <<< GirdImageRow(){ row in
                row.tag = "address" 
                row.title = "地址"
                row.value = NSMutableArray()
                row.value?.add(URL(string: "http://www/vancheerfile/images/2019/2/20190221105546911.jpg"))
                row.value?.add(GridUrl(girdUrl: "http://www/vancheerfile/images/2019/2/20190221105546911.jpg"))
                row.value?.add(GridUrl(girdUrl: "http://www/vancheerfile/images/2019/2/20190221105546911.jpg"))
                
        }
            <<< ButtonRow(){
                $0.title = "ImagePicker"
                $0.tag = "ImagePicker"
                }.onCellSelection({ (row, row1) in
                    self.navigationController?.pushViewController(GSImagePickerViewController(), animated: true)
                })
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

