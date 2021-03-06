//
// QRCodeScanViewController.swift 
// SwiftDemo 
// 
// Created by Linzy on 2019/4/23. 
// Copyright © 2019 Gosuncn. All rights reserved.
// 


import Foundation
import UIKit
import SnapKit
import AVFoundation
import RxSwift
import RxCocoa

public class QRCodeScanViewController : UIViewController {
    
    public var allowPhotoLibrary = false
    public var navigationTitle = "二维码扫描"
    public let scanResultObservable =  PublishSubject<String>()
    public var scanTintcolor = UIColor.darkGray
    public let maskColor = UIColor.init(white: 0, alpha: 0.3)
    var scanAnimation : QRCodeScanAnimation?
    public let tipLabel = UILabel()
    public let flashLightBtn = UIButton()
    private var hadReturn = false//是否已经返回过了
    private var hadReturnLock = NSLock()//是否已经返回过了
    let disposeBag = DisposeBag()
    
    override public func viewDidLoad() {
        super.viewDidLoad();
        setUpUI()
        checkAuthorized()
        scanAnimation?.startAnimation()
        setUpCustomUI()
    }
    //MARK: - Bussiness
    
    func checkAuthorized(){
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
             print("checkAuthorized denied")
            showCameraAlert()
        case .authorized:
             print("checkAuthorized authorized")
            setUpScan(preview: self.view)
            session.startRunning()
        default:
            print("checkAuthorized default")
            setUpScan(preview: self.view)
            session.startRunning()
        }
    }
    
    func showCameraAlert(){
        print("showCameraAlert")
        let alertVC = UIAlertController.init(title: "请打开摄像头权限", message: "二维码扫描需要摄像头权限", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { [weak self](action) in
            self?.openCameraAuthorized()
        }))
        alertVC.addAction(UIAlertAction.init(title: "返回", style: .default, handler: { [weak self](action) in
            self?.navigationController?.popViewController(animated: true)
        }))
        present(alertVC, animated: true, completion: nil)
    }
    
    func openCameraAuthorized(){
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else{
            return
        }
        if UIApplication.shared.canOpenURL(settingsURL) {
            if #available(iOS 10, *){
                UIApplication.shared.open(settingsURL, options: [:]) { [weak self](isSuccess) in
                   self?.checkAuthorized()
                }
            }
        }
        
    }
    //MARK: - UI
    //自定义UI,给子类复写用a
    open func setUpCustomUI() {
        
    }
    open func setUpUI() {
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title  = navigationTitle
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 0
        horizontalStackView.distribution = .fill
        horizontalStackView.alignment = .fill
        self.view.addSubview(horizontalStackView)
        horizontalStackView.snp.makeConstraints { (maker) in
            maker.top.leading.bottom.trailing.equalToSuperview()
        }
        let leadingSpace = getEmptySpace()
        let trailingSpace = getEmptySpace()
        horizontalStackView.addArrangedSubview(leadingSpace)
        horizontalStackView.addArrangedSubview(verticalStackView)
        horizontalStackView.addArrangedSubview(trailingSpace)
        trailingSpace.snp.makeConstraints { (maker) in
            maker.width.equalToSuperview().multipliedBy(0.2)
        }
        
        leadingSpace.snp.makeConstraints { (maker) in
            maker.width.equalToSuperview().multipliedBy(0.2)
        }

        let topSpace = getEmptySpace()
        let bottomSpace = getEmptySpace()
        tipLabel.text = "二位码置于框内,自动开始扫描"
        tipLabel.textColor = UIColor.white
        tipLabel.textAlignment = .center
        tipLabel.font = UIFont.systemFont(ofSize: 14)
        tipLabel.backgroundColor = maskColor
        tipLabel.snp.makeConstraints { (maker) in
            maker.height.equalTo(32)
        }
        
        let scanView = setUpScanView()
        verticalStackView.addArrangedSubview(topSpace)
        verticalStackView.addArrangedSubview(scanView)
        verticalStackView.addArrangedSubview(tipLabel)
        verticalStackView.addArrangedSubview(bottomSpace)
        scanView.snp.makeConstraints { (maker) in
            maker.height.equalTo(scanView.snp.width)
        }
        topSpace.snp.makeConstraints { (maker) in
            maker.height.equalToSuperview().multipliedBy(0.2)
        }

    }
    
    
    func setUpFlashLight() {
        //手电筒
        view.addSubview(flashLightBtn)
        flashLightBtn.setTitle("手电筒:关", for: .normal)
        flashLightBtn.setTitle("手电筒:开", for: .selected)
        flashLightBtn.setTitleColor(UIColor.white, for: .normal)
        flashLightBtn.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.bottom.equalToSuperview().offset(-48)
        }
        
        flashLightBtn.rx.tap.subscribe(onNext: {[weak self] _ in
            self?.switchTorch()
        }).disposed(by: disposeBag);
    }
    
    func switchTorch()  {
        print("switchTorch")
        if (device == nil ||  !device!.hasTorch){
             showScanHUD(message: "无法打开闪光灯")
            print("device == nil ||  device!.hasTorch")
            return
        }
        do
        {
            try input?.device.lockForConfiguration()
            input?.device.torchMode = flashLightBtn.isSelected ? AVCaptureDevice.TorchMode.off : AVCaptureDevice.TorchMode.on
            flashLightBtn.isSelected = !flashLightBtn.isSelected
            input?.device.unlockForConfiguration()
        }
        catch let error as NSError {
            showScanHUD(message: error.localizedDescription)
            
        }
    
    }
    
    
    open func setUpScanView() -> UIView{
        let scanView = UIView()
        scanView.backgroundColor = UIColor.clear
        let scanBorderWidth = 5
        
        //左上
        let tl = UIView()
        tl.backgroundColor = scanTintcolor
        scanView.addSubview(tl)
        tl.snp.makeConstraints { (maker) in
            maker.leading.top.equalToSuperview()
            maker.height.equalTo(scanBorderWidth)
            maker.width.equalToSuperview().multipliedBy(0.2)
        }
        let lt = UIView()
        lt.backgroundColor = scanTintcolor
        scanView.addSubview(lt)
        lt.snp.makeConstraints { (maker) in
            maker.top.leading.equalToSuperview()
            maker.width.equalTo(scanBorderWidth)
            maker.height.equalToSuperview().multipliedBy(0.2)
        }
        //右上
        let tr = UIView()
        tr.backgroundColor = scanTintcolor
        scanView.addSubview(tr)
        tr.snp.makeConstraints { (maker) in
            maker.top.trailing.equalToSuperview()
            maker.height.equalTo(scanBorderWidth)
            maker.width.equalToSuperview().multipliedBy(0.2)
        }
        let rt = UIView()
        rt.backgroundColor = scanTintcolor
        scanView.addSubview(rt)
        rt.snp.makeConstraints { (maker) in
            maker.top.trailing.equalToSuperview()
            maker.width.equalTo(scanBorderWidth)
            maker.height.equalToSuperview().multipliedBy(0.2)
        }
        //左下
        let bl = UIView()
        bl.backgroundColor = scanTintcolor
        scanView.addSubview(bl)
        bl.snp.makeConstraints { (maker) in
            maker.leading.bottom.equalToSuperview()
            maker.height.equalTo(scanBorderWidth)
            maker.width.equalToSuperview().multipliedBy(0.2)
        }
        let lb = UIView()
        lb.backgroundColor = scanTintcolor
        scanView.addSubview(lb)
        lb.snp.makeConstraints { (maker) in
            maker.bottom.leading.equalToSuperview()
            maker.width.equalTo(scanBorderWidth)
            maker.height.equalToSuperview().multipliedBy(0.2)
        }
         //右下
        let br = UIView()
        br.backgroundColor = scanTintcolor
        scanView.addSubview(br)
        br.snp.makeConstraints { (maker) in
            maker.bottom.trailing.equalToSuperview()
            maker.height.equalTo(scanBorderWidth)
            maker.width.equalToSuperview().multipliedBy(0.2)
        }
        let rb = UIView()
        rb.backgroundColor = scanTintcolor
        scanView.addSubview(rb)
        rb.snp.makeConstraints { (maker) in
            maker.bottom.trailing.equalToSuperview()
            maker.width.equalTo(scanBorderWidth)
            maker.height.equalToSuperview().multipliedBy(0.2)
        }
        scanAnimation = QRCodeScanAnimation(scanView: scanView,color: scanTintcolor)
        return scanView
    }
    
    func getEmptySpace() -> UIView {
        let emptySpace = UIView()
        emptySpace.backgroundColor = maskColor
        return emptySpace
    }

    //MARK : Scan
    let session =  AVCaptureSession()
    var input : AVCaptureDeviceInput?
    var output = AVCaptureMetadataOutput()
    var previewLayer : AVCaptureVideoPreviewLayer?
    var photoOutput = AVCapturePhotoOutput()
    let device = AVCaptureDevice.default(for: AVMediaType.video)
    
    
    func setUpScan(preview: UIView) {
        
        do{
            input = try AVCaptureDeviceInput(device: device!)
        }catch let error as NSError{
            showScanHUD(message: error.localizedDescription)
            return
        }
        
        guard let input = input else {
            showScanHUD(message: "无法打开摄像头")
            return
        }
        if session.canAddInput(input){
            session.addInput(input)
        }
        
        if session.canAddOutput(output){
            session.addOutput(output)
        }
        output.metadataObjectTypes = [.qr]
        output.setMetadataObjectsDelegate(self, queue: .main)
        
        if session .canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
        }
        setUpPreView(preview)
        setUpFlashLight()
    }
    
    func setUpPreView(_ preview: UIView) {
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        var frame = preview.frame
        frame.origin = CGPoint.zero
        previewLayer?.frame = frame
        
        preview.layer.insertSublayer(previewLayer!, at: 0)
    }
    
    

}
extension QRCodeScanViewController : AVCaptureMetadataOutputObjectsDelegate{
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection){
        if metadataObjects.count > 0{
            session.stopRunning()
        }
        if hadReturn{
            return
        }
        if !hadReturnLock.try(){
            return
        }
        for scanResult in metadataObjects {
            guard let readablResult = scanResult as? AVMetadataMachineReadableCodeObject else{
                continue
            }
            if let codeContent = readablResult.stringValue , codeContent.count > 0{
                hadReturn = true
                scanResultObservable.onNext(codeContent)
                scanResultObservable.onCompleted()
                self.navigationController?.popViewController(animated: true)
                hadReturnLock.unlock()
                return
            }
            
        }
        hadReturnLock.unlock()
        session.startRunning()
        return
    }
    
    public func detectImage(inputImage : UIImage) -> String{
        let ciimage = CIImage(cgImage: inputImage.cgImage!)
        let detector = CIDetector(ofType:CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy : CIDetectorAccuracyHigh])
        let resultArry = detector!.features(in: ciimage)
        guard let result = resultArry[0] as? CIQRCodeFeature else{
            return ""
        }
        return  result.messageString ?? ""
    }
    
    open func showScanHUD(isSuccess:Bool = false,message:String?){
        let alertVC = UIAlertController.init(title: message, message: nil, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction.init(title: "返回", style: .default, handler: { [weak self](action) in
            self?.navigationController?.popViewController(animated: true)
        }))
        present(alertVC, animated: true, completion: nil)

    }
    
}

