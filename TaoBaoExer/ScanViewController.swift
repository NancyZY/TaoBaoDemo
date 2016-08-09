//
//  ScanViewController.swift
//  TaoBaoExer
//
//  Created by Nancy's MacbookPro on 8/3/16.
//  Copyright © 2016 Nancy's MacbookPro. All rights reserved.
//

import UIKit
import AVFoundation

protocol ScancodeDelegate {
    func barcodeReaded(barcode: String)
}

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
//    var captureSession: AVCaptureSession!
//    var previewLayer: AVCaptureVideoPreviewLayer!
//    var vwQRCode:UIView?
//    
//    var code: String?
//    var delegate: ScancodeDelegate?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.configureVideoCapture()
//        self.addVideoPreviewLayer()
//        self.initializeQRView()
//    }
//    
//    func failed() {
//        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .Alert)
//        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//        presentViewController(ac, animated: true, completion: nil)
//        captureSession = nil
//    }
//    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        if (captureSession?.running == false) {
//            captureSession.startRunning();
//        }
//    }
//    
//    override func viewWillDisappear(animated: Bool) {
//        super.viewWillDisappear(animated)
//        
//        if (captureSession?.running == true) {
//            captureSession.stopRunning();
//        }
//    }
//    
//    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
//        captureSession.stopRunning()
//        
//        if let metadataObject = metadataObjects.first {
//            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject;
//            
//            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
//            foundCode(readableObject.stringValue);
//        }
//        
//        dismissViewControllerAnimated(true, completion: nil)
//    }
//    
//    func foundCode(code: String) {
//        print(code)
//        self.captureSession.stopRunning()
//        self.dismissViewControllerAnimated(true, completion: nil)
//        self.delegate?.barcodeReaded(code)
//    }
//    
//    func configureVideoCapture(){
//        captureSession = AVCaptureSession()
//        
//        let videoCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
//        let videoInput: AVCaptureDeviceInput
//        
//        do {
//            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
//        } catch {
//            return
//        }
//        
//        if (captureSession.canAddInput(videoInput)) {
//            captureSession.addInput(videoInput)
//        } else {
//            failed();
//            return;
//        }
//        
//        let metadataOutput = AVCaptureMetadataOutput()
//        
//        if (captureSession.canAddOutput(metadataOutput)) {
//            captureSession.addOutput(metadataOutput)
//            
//            metadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
//            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
//        } else {
//            failed()
//            return
//        }
//        
//    }
//    
//    func addVideoPreviewLayer(){
//        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
//        previewLayer.frame = view.layer.bounds;
//        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//        view.layer.addSublayer(previewLayer);
//        
//        captureSession.startRunning();
//    }
//    
//    func initializeQRView() {
//        vwQRCode = UIView()
//        vwQRCode?.layer.borderColor = UIColor.redColor().CGColor
//        vwQRCode?.layer.borderWidth = 5
//        self.view.addSubview(vwQRCode!)
//        self.view.bringSubviewToFront(vwQRCode!)
//    }
//    
//    override func prefersStatusBarHidden() -> Bool {
//        return true
//    }
//    
//    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
//        return .Portrait
//    }

    private var titleLabel = UILabel()
    private var captureSession: AVCaptureSession?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var animationLineView = UIImageView()
    private var timer: NSTimer?
    
    private let LFBNavigationBarWhiteBackgroundColor = UIColor.colorWithCustom(249, g: 250, b: 253)
    private let ScreenWidth: CGFloat = UIScreen.mainScreen().bounds.size.width
    private let ScreenHeight: CGFloat = UIScreen.mainScreen().bounds.size.height
    private let LFBNavigationYellowColor = UIColor.colorWithCustom(253, g: 212, b: 49)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildNavigationItem()
        
        buildInputAVCaptureDevice()
        
        buildFrameImageView()
        
        buildTitleLabel()
        
        buildAnimationLineView()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
    }
    
    // MARK: - Build UI
    private func buildNavigationItem() {
        navigationItem.title = "店铺二维码"
        
        navigationController?.navigationBar.barTintColor = LFBNavigationBarWhiteBackgroundColor
    }
    
    private func buildTitleLabel() {
        
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont.systemFontOfSize(16)
        titleLabel.frame = CGRectMake(0, 340, ScreenWidth, 30)
        titleLabel.textAlignment = NSTextAlignment.Center
        view.addSubview(titleLabel)
    }
    
    private func buildInputAVCaptureDevice() {
        
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        titleLabel.text = "将店铺二维码对准方块内既可收藏店铺"
        let input = try? AVCaptureDeviceInput(device: captureDevice)
        if input == nil {
            titleLabel.text = "没有摄像头你描个蛋啊~换真机试试"
            
            return
        }
        
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession = AVCaptureSession()
        captureSession?.addInput(input!)
        captureSession?.addOutput(captureMetadataOutput)
        let dispatchQueue = dispatch_queue_create("myQueue", nil)
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatchQueue)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode]
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.frame
        view.layer.addSublayer(videoPreviewLayer!)
        captureMetadataOutput.rectOfInterest = CGRectMake(0, 0, 1, 1)
        
        captureSession?.startRunning()
    }
    
    private func buildFrameImageView() {
        
        let lineT = [CGRectMake(0, 0, ScreenWidth, 100),
                     CGRectMake(0, 100, ScreenWidth * 0.2, ScreenWidth * 0.6),
                     CGRectMake(0, 100 + ScreenWidth * 0.6, ScreenWidth, ScreenHeight - 100 - ScreenWidth * 0.6),
                     CGRectMake(ScreenWidth * 0.8, 100, ScreenWidth * 0.2, ScreenWidth * 0.6)]
        for lineTFrame in lineT {
            buildTransparentView(lineTFrame)
        }
        
        let lineR = [CGRectMake(ScreenWidth * 0.2, 100, ScreenWidth * 0.6, 2),
                     CGRectMake(ScreenWidth * 0.2, 100, 2, ScreenWidth * 0.6),
                     CGRectMake(ScreenWidth * 0.8 - 2, 100, 2, ScreenWidth * 0.6),
                     CGRectMake(ScreenWidth * 0.2, 100 + ScreenWidth * 0.6, ScreenWidth * 0.6, 2)]
        
        for lineFrame in lineR {
            buildLineView(lineFrame)
        }
        
        let yellowHeight: CGFloat = 4
        let yellowWidth: CGFloat = 30
        let yellowX: CGFloat = ScreenWidth * 0.2
        let bottomY: CGFloat = 100 + ScreenWidth * 0.6
        let lineY = [CGRectMake(yellowX, 100, yellowWidth, yellowHeight),
                     CGRectMake(yellowX, 100, yellowHeight, yellowWidth),
                     CGRectMake(ScreenWidth * 0.8 - yellowHeight, 100, yellowHeight, yellowWidth),
                     CGRectMake(ScreenWidth * 0.8 - yellowWidth, 100, yellowWidth, yellowHeight),
                     CGRectMake(yellowX, bottomY - yellowHeight + 2, yellowWidth, yellowHeight),
                     CGRectMake(ScreenWidth * 0.8 - yellowWidth, bottomY - yellowHeight + 2, yellowWidth, yellowHeight),
                     CGRectMake(yellowX, bottomY - yellowWidth, yellowHeight, yellowWidth),
                     CGRectMake(ScreenWidth * 0.8 - yellowHeight, bottomY - yellowWidth, yellowHeight, yellowWidth)]
        
        for yellowRect in lineY {
            buildYellowLineView(yellowRect)
        }
    }
    
    private func buildLineView(frame: CGRect) {
        let view1 = UIView(frame: frame)
        view1.backgroundColor = UIColor.colorWithCustom(230, g: 230, b: 230)
        view.addSubview(view1)
    }
    
    private func buildYellowLineView(frame: CGRect) {
        let yellowView = UIView(frame: frame)
        yellowView.backgroundColor = LFBNavigationYellowColor
        view.addSubview(yellowView)
    }
    
    private func buildTransparentView(frame: CGRect) {
        let tView = UIView(frame: frame)
        tView.backgroundColor = UIColor.blackColor()
        tView.alpha = 0.5
        view.addSubview(tView)
    }
    
    private func buildAnimationLineView() {
        animationLineView.image = UIImage(named: "yellowlight")
        view.addSubview(animationLineView)
        
        timer = NSTimer(timeInterval: 2.5, target: self, selector: "startYellowViewAnimation", userInfo: nil, repeats: true)
        let runloop = NSRunLoop.currentRunLoop()
        runloop.addTimer(timer!, forMode: NSRunLoopCommonModes)
        timer!.fire()
    }
    
    func startYellowViewAnimation() {
        weak var weakSelf = self
        animationLineView.frame = CGRectMake(ScreenWidth * 0.2 + ScreenWidth * 0.1 * 0.5, 100, ScreenWidth * 0.5, 20)
        UIView.animateWithDuration(2.5) { () -> Void in
            weakSelf!.animationLineView.frame.origin.y += self.ScreenWidth * 0.55
        }
    }
}
