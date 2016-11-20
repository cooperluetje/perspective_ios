//
//  CameraViewController.swift
//  Perspective
//
//  Created by Cooper Luetje on 11/19/16.
//  Copyright © 2016 Cooper Luetje. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate, CLLocationManagerDelegate
{
    // MARK: Properties
    @IBOutlet weak var cameraView: UIImageView!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var discardButtonVar: UIButton!
    @IBOutlet weak var acceptButtonVar: UIButton!
    var captureSession:AVCaptureSession?
    var imageOutput:AVCaptureStillImageOutput?
    var previewLayer:AVCaptureVideoPreviewLayer?
    var user = User(id: -1, name: "", email: "", username: "", created_at: "", updated_at: "", auth_token: "")
    var postService = PostService(user: User(id: -1, name: "", email: "", username: "", created_at: "", updated_at: "", auth_token: ""))
    let locationManager = CLLocationManager()
    var apiRoutes = ApiRoutes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get user info
        let defaults = UserDefaults.standard
        let key = "user"
        if defaults.object(forKey: key) != nil
        {
            if let value = defaults.object(forKey: key) as? NSData
            {
                user = NSKeyedUnarchiver.unarchiveObject(with: value as Data) as! User
                postService = PostService(user: user)
            }
        }
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
                    self.cameraView.image = self.cropImage(image: image)
                }
            })
        }
        self.previewView.isHidden = true
        self.acceptButtonVar.isHidden = false
        self.discardButtonVar.isHidden = false
    }    
    
    @IBAction func discardButton(_ sender: UIButton)
    {
        self.previewView.isHidden = false
        self.acceptButtonVar.isHidden = true
        self.discardButtonVar.isHidden = true
    }
    
    @IBAction func acceptButton(_ sender: UIButton)
    {
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            let location:CLLocationCoordinate2D = (locationManager.location?.coordinate)!
            _ = postService.createPost(image: self.cameraView.image!, latitude: "\(location.latitude)", longitude: "\(location.longitude)", auth_token: user.auth_token)
            UIImageWriteToSavedPhotosAlbum(self.cameraView.image!, nil, nil, nil)
        }
    }
    
    func cropImage(image: UIImage) -> UIImage
    {
        let contextImage:UIImage = UIImage(cgImage: image.cgImage!)
        let contextSize:CGSize = contextImage.size
        
        var x:CGFloat = 0.0
        var y:CGFloat = 0.0
        var cgWidth:CGFloat = CGFloat(previewView.bounds.width)
        var cgHeight:CGFloat = CGFloat(previewView.bounds.height)
        
        if contextSize.width > contextSize.height
        {
            x = ((contextSize.width - contextSize.height) / 2)
            y = 0
            cgWidth = contextSize.height
            cgHeight = contextSize.height
        }
        else
        {
            x = 0
            y = ((contextSize.height - contextSize.width) / 2)
            cgWidth = contextSize.width
            cgHeight = contextSize.width
        }
        
        let rect:CGRect = CGRect(x: x, y: y, width: cgWidth, height: cgHeight)
        
        let imageRef:CGImage = image.cgImage!.cropping(to: rect)!
        
        let image:UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
