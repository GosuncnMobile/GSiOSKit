//
// GSImagePicker.swift
// GSiOSKit
// 选择图片
//
// Created by Linzy on 2019/5/22.
// Copyright © 2019 Gosuncn. All rights reserved.
//


import UIKit

public class GSImagePicker: NSObject {
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private var resultHandler : ((UIImage?) -> Void)?
    private var isAllowPng = false//是否允许选择png
    private var isCompress = true//是否压缩
    
    /// 新建图片选择器
    ///
    /// - Parameters:
    ///   - presentationController: 一般为
    ///   - isAllowPng: 是否允许选择PNG图片
    ///   - isAllowsEditing: 是否允许编辑
    ///   - isCompress: 是否进行压缩
    public init(presentationController: UIViewController, isAllowPng:Bool = false,isAllowsEditing:Bool = false,isCompress :Bool = true) {
        self.pickerController = UIImagePickerController()
        super.init()
        self.presentationController = presentationController
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = isAllowsEditing
        self.isAllowPng = isAllowPng
        self.isCompress = isCompress
    }
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }
    
    public func showImagePickerSheet(completion :  @escaping(UIImage?) -> Void ) {
        resultHandler = completion
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let action = self.action(for: .camera, title: "拍照") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "相册") {
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.presentationController?.present(alertController, animated: true)
    }
    
    func showAlert(message:String) {
        let alertVC = UIAlertController.init(title: "", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction.init(title: "确定", style: .default, handler:nil))
        pickerController.present(alertVC, animated: true, completion: nil)
    }
    
    func didSelectImage(image:UIImage){
//        if !isAllowPng, image.pngData() != nil{
//            showAlert(message: "不支持png格式的图片")
//            return
//        }
      //  print("\(image.imageOrientation.rawValue)")
        if isCompress,let compressImage = image.gs_compressImage(){
           // print("\(compressImage.imageOrientation.rawValue)")
            resultHandler?(compressImage.fixOrientation())
        }else{
            resultHandler?(image)
        }
        pickerController.dismiss(animated: true, completion: nil)
    }
}

extension GSImagePicker : UIImagePickerControllerDelegate{
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if !isAllowPng,picker.sourceType != .camera ,let referenceURL = info[.referenceURL] as? URL,
            referenceURL.absoluteString.contains(".png"){
            showAlert(message: "不支持png格式的图片")
            return
        }
        if (picker.allowsEditing) {
            guard let  image = info[.editedImage] as? UIImage else{
                return
            }
              didSelectImage(image: image)
        }else {
            guard let  image = info[.originalImage] as? UIImage else{
                return
            }
          didSelectImage(image: image)
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension GSImagePicker: UINavigationControllerDelegate {
    
}
