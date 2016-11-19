//
//  CameraViewController.swift
//  Perspective
//
//  Created by Cooper Luetje on 11/19/16.
//  Copyright © 2016 Cooper Luetje. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate
{
    // MARK: Properties
    @IBOutlet weak var cameraView: UIImageView!
    @IBOutlet weak var previewView: UIView!
    //let picker = UIImagePickerController()
    var captureSession:AVCaptureSession?
    var imageOutput:AVCaptureStillImageOutput?
    var previewLayer:AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        self.picker.sourceType = UIImagePickerControllerSourceType.camera
        self.picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureMode.photo
        self.picker.cameraDevice = UIImagePickerControllerCameraDevice.rear
        self.picker.showsCameraControls = true
        self.picker.isNavigationBarHidden = true
        self.picker.isToolbarHidden = true
        self.picker.modalPresentationStyle = .custom
        self.cameraView.image = UIImagePickerControllerOriginalImage
        self.picker.cameraOverlayView = cameraView
        
        self.present(picker, animated: true, completion: nil)
        */
        
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        captureSession = AVCaptureSession()
        captureSession!.sessionPreset = AVCaptureSessionPresetPhoto
        
        let backCamera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        var error:Error?
        var input:AVCaptureDeviceInput!
        do
        {
            input = try AVCaptureDeviceInput(device: backCamera)
        }
        catch let err as NSError
        {
            error = err
            input = nil
        }
        if error == nil && captureSession!.canAddInput(input)
        {
            captureSession!.addInput(input)
            imageOutput = AVCaptureStillImageOutput()
            imageOutput!.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
            if captureSession!.canAddOutput(imageOutput)
            {
                captureSession!.addOutput(imageOutput)
                
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
                previewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                previewView.layer.addSublayer(previewLayer!)
                
                captureSession!.startRunning()
            }
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        previewLayer!.frame = previewView.bounds
    }
    
    @IBAction func photoButton(_ sender: UIButton)
    {
        if let videoConnection = imageOutput!.connection(withMediaType: AVMediaTypeVideo)
        {
            videoConnection.videoOrientation = AVCaptureVideoOrientation.portrait
            imageOutput?.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (buffer, error) in
                if buffer != nil
                {
                    let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)
                    let dataProvider = CGDataProvider(data: data as! CFData)
                    let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
                    
                    let image = UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.right)
                    self.cameraView.image = image
                }
            })
        }
        self.previewView.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
