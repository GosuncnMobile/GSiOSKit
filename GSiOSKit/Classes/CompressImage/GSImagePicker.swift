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
    
    public init(presentationController: UIViewController) {
        self.pickerController = UIImagePickerController()
        super.init()
        self.presentationController = presentationController
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = false
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
    
    
}

extension GSImagePicker : UIImagePickerControllerDelegate{
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if (picker.allowsEditing) {
            guard let  image = info[.editedImage] as? UIImage else{
                return
            }
            resultHandler?(image)
        }else {
            guard let  image = info[.originalImage] as? UIImage else{
                return
            }
            resultHandler?(image)
        }
        
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension GSImagePicker: UINavigationControllerDelegate {
    
}
