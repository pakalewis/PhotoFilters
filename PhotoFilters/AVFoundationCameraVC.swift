//
//  AVFoundationCameraVC.swift
//  PhotoFilters
//
//  Created by Parker Lewis on 10/16/14.
//  Copyright (c) 2014 Parker Lewis. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMedia
import CoreVideo
import ImageIO
import QuartzCore

class AVFoundationCameraVC: UIViewController {

    @IBOutlet weak var capturedPreviewImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var capturePreviewImageView: UIImageView!

    var delegate : ImageSelectedProtocol?
    var stillImageOutput = AVCaptureStillImageOutput()

    var captureSession : AVCaptureSession!
    var previewLayer : AVCaptureVideoPreviewLayer!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.capturePreviewImageView.image = UIImage(named: "default_image")
        
        self.captureSession = AVCaptureSession()
        self.captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        // set initial size for the previewlayer view
        self.setInitalPreviewLayerSize()
        self.view.layer.addSublayer(previewLayer)
        
        var device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        var error : NSError?
        var input = AVCaptureDeviceInput.deviceInputWithDevice(device, error: &error) as AVCaptureDeviceInput!
        if input == nil {
            println("bad!")
        }
        captureSession.addInput(input)
        var outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
        self.stillImageOutput.outputSettings = outputSettings
        captureSession.addOutput(self.stillImageOutput)
        captureSession.startRunning()
    }
    
    
    @IBAction func captureButtonPressed(sender: AnyObject) {
        var videoConnection : AVCaptureConnection?
        for connection in self.stillImageOutput.connections {
            if let cameraConnection = connection as? AVCaptureConnection {
                for port in cameraConnection.inputPorts {
                    if let videoPort = port as? AVCaptureInputPort {
                        if videoPort.mediaType == AVMediaTypeVideo {
                            videoConnection = cameraConnection
                            break;
                        }
                    }
                }
            }
            if videoConnection != nil {
                break;
            }
        }

        self.stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {(buffer : CMSampleBuffer!, error : NSError!) -> Void in
            var data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)
            var image = UIImage(data: data)
            self.capturePreviewImageView.image = image
        })
        self.shrinkPreviewLayerSize()
    }

    @IBAction func retakeButton(sender: AnyObject) {
        self.setInitalPreviewLayerSize()
    }
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        self.delegate!.didSelectPicture(self.capturePreviewImageView.image!)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    func setInitalPreviewLayerSize() {
        var screenSize = UIScreen.mainScreen().bounds
        var videoCamFrame = CGRectMake(screenSize.width * 0.05, screenSize.height * 0.05, screenSize.width * 0.9, screenSize.height * 0.8)
        self.previewLayer.frame = videoCamFrame
        
        self.capturedPreviewImageViewHeightConstraint.constant = 0.0
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    
    func shrinkPreviewLayerSize() {
        var screenSize = UIScreen.mainScreen().bounds
        var shrunkenVideoCamFrame = CGRectMake(screenSize.width * 0.05, screenSize.height * 0.05, screenSize.width * 0.9, screenSize.height * 0.5)
        self.previewLayer.frame = shrunkenVideoCamFrame
        
        self.capturedPreviewImageViewHeightConstraint.constant = (screenSize.height * 0.35)
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
}
