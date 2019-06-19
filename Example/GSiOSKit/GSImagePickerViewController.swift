//
// GSImagePickerViewController.swift 
// GSiOSKit_Example 
// 
// Created by Linzy on 2019/6/19. 
// Copyright © 2019 Gosuncn. All rights reserved.
// 


import UIKit
import SnapKit
import GSiOSKit
class GSImagePickerViewController: UIViewController {
    var picker : GSImagePicker?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        title = "ImagePicker"
    }
    
    @objc func imagePicker(){
        guard let navigationVC = self.navigationController else{
            return
        }
        picker = GSImagePicker.init(presentationController: navigationVC)
        picker?.showImagePickerSheet { [weak self](result) in
            self?.imageV.image = result
            guard let source = result else{
                self?.compressImageV.image = nil
                return
            }
            self?.setCompressImage(source: source)
        }
    }
    
    func setCompressImage(source:UIImage){
        print("\(source.size.width),\(source.size.height),\(source.jpegData(compressionQuality: 1)?.count)")
        guard  let comData = source.gs_compressImage() else {
            return
        }
        let comImage = UIImage.init(data: comData)
        print("\(comImage?.size.width),\(comImage?.size.height),\(comData.count)")
        compressImageV.image = comImage
    }
    
    let imagePickerButton = UIButton.init(type: .roundedRect)
    let imageV = UIImageView.init()
    let compressImageV = UIImageView.init()
    func setUpUI() {
        view.backgroundColor = UIColor.white
        view.addSubview(imagePickerButton)
        imagePickerButton.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(16)
            maker.centerX.equalToSuperview()
            maker.height.equalTo(48)
        }
        imagePickerButton.setTitle("选择图片", for: .normal)
        imagePickerButton.addTarget(self, action: #selector(imagePicker), for: .touchUpInside)
        
        view.addSubview(imageV)
        imageV.backgroundColor = UIColor.gray
        imageV.snp.makeConstraints { (maker) in
            maker.top.equalTo(imagePickerButton.snp.bottom).offset(16)
            maker.leading.equalToSuperview().offset(16)
            maker.trailing.equalToSuperview().offset(-16)
            maker.bottom.equalTo(view.snp.centerY).offset(16)
        }
        imageV.contentMode = .scaleAspectFit
        
        view.addSubview(compressImageV)
        compressImageV.backgroundColor = UIColor.gray
        compressImageV.snp.makeConstraints { (maker) in
            maker.top.equalTo(imageV.snp.bottom).offset(16)
            maker.leading.equalToSuperview().offset(16)
            maker.trailing.equalToSuperview().offset(-16)
            maker.bottom.equalToSuperview().offset(-16)
        }
        compressImageV.contentMode = .scaleAspectFit
    }

}
