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
import Gallery

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
            <<< ShowGirdImageRow(){ row in
                row.tag = "ShowGirdImageRow"
                row.title = "展示图片"
                row.value = NSMutableArray()
                row.value?.add(URL(string: "http://www/vancheerfile/images/2019/2/20190221105546911.jpg"))
                row.value?.add(GridUrl(girdUrl: "http://www/vancheerfile/images/2019/2/20190221105546911.jpg"))
                row.value?.add(GridUrl(girdUrl: "http://www/vancheerfile/images/2019/2/20190221105546911.jpg"))
                
        }
            <<< GirdImageRow(){row in
                row.tag = "GirdImageRow"
                row.title = "选择图片"
            }
            <<< ButtonRow(){
                $0.title = "Gallery"
                $0.tag = "Gallery"
                }.onCellSelection({ [weak self](row, row1) in
                    let gallery = GalleryController.init()
                    gallery.delegate = self
                    Config.Camera.recordLocation = false
                    Config.tabsToShow = [.imageTab, .cameraTab]
                    Config.Camera.imageLimit = 9
                    Config.initialTab = .imageTab
                    Config.Grid.ArrowButton.tintColor = UIColor.red
                    Config.Grid.FrameView.borderColor = UIColor.blue
                    Config.Grid.FrameView.fillColor = UIColor.yellow
                     self?.present(gallery, animated: true, completion: nil)
                })
            <<< ButtonRow(){
                $0.title = "ImagePicker"
                $0.tag = "ImagePicker"
                }.onCellSelection({ (row, row1) in
                    self.navigationController?.pushViewController(GSImagePickerViewController(), animated: true)
                })
            <<< ButtonRow(){
                $0.title = "PhotosPreview"
                $0.tag = "PhotosPreview"
                }.onCellSelection({ (row, row1) in
                    self.navigationController?.pushViewController(PhotosPreviewViewController.init(dateSource: ["http://www/vancheerfile/images/2019/2/20190221105546911.jpg","http://www/vancheerfile/images/2019/2/20190221105546911.jpg","http://www/vancheerfile/images/2019/2/20190221105546911.jpg"], currentPage: 1, title: "PhotosPreview"), animated: true)
                })
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

extension ViewController : GalleryControllerDelegate{
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        print("didSelectImages:\(images.count)")
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
