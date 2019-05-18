//
//  CameraViewController.swift
//  FCA
//

import UIKit
import AVFoundation

enum CurrentFlashMode: Int {
    case off
    case on
    case auto
}

class CameraViewController: BaseViewController {

    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var buttonSwitchCamera: UIButton!
    @IBOutlet weak var buttonFlash: UIButton!
    @IBOutlet weak var btnButtonCamera: UIButton!
    @IBOutlet weak var imagePhoto: UIImageView!
    
    var captureSession: AVCaptureSession!
    var captureDeviceInput: AVCaptureDeviceInput!
    var captureVideoOutput: AVCaptureVideoDataOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var capturePhotoOutput: AVCapturePhotoOutput!
    var flashMode = AVCaptureDevice.FlashMode.off
    var cameraPosition = AVCaptureDevice.Position.back
    var cameraOutput = AVCapturePhotoOutput()
    var highResolutionEnabled = true
    var deviceFocus: AVCaptureDevice!
    var imagePicker = UIImagePickerController()
    var checkbutton = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonFlash.setImage(UIImage(named: "button_flash_off"), for: .normal)
        requestAccessCamera()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        ManagerGoogleDrive.shared.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: -Button Click
    @IBAction func invokeButtonCamera(_ sender: Any) {
        let settings = AVCapturePhotoSettings()
        settings.isHighResolutionPhotoEnabled = true
        settings.isAutoStillImageStabilizationEnabled = self.capturePhotoOutput.isStillImageStabilizationSupported
        settings.flashMode = self.flashMode
        self.capturePhotoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    @IBAction func invokeButtonFlash(_ sender: Any) {
        switch self.flashMode {
        case .off:
            self.flashMode = .on
            buttonFlash.setImage(UIImage(named: "button_flash_on"), for: .normal)
            break
        case .on:
            self.flashMode = .auto
            buttonFlash.setImage(UIImage(named: "button_flash_auto"), for: .normal)
            break
        case .auto:
            self.flashMode = .off
            buttonFlash.setImage(UIImage(named: "button_flash_off"), for: .normal)
            break
        }
    }
    
    @IBAction func invokeButtonSwicth(_ sender: Any) {
        if cameraPosition == .back {
            UIView.transition(with: self.previewView, duration: 0.4, options: .transitionFlipFromLeft, animations: {
                self.cameraPosition = .front
            }, completion: nil)
            
        } else
        {
            UIView.transition(with: self.previewView, duration: 0.4, options: .transitionFlipFromRight, animations: {
                self.cameraPosition = .back
            }, completion: nil)
        }
        loadCamera()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first! as UITouch
        let screenSize = self.previewView.bounds.size
        let focusPoint = CGPoint(x: touchPoint.location(in: self.previewView).y / screenSize.height , y: 1.0 - touchPoint.location(in: previewView).x / screenSize.width)
        let poss = touchPoint.location(in: previewView)
        let focusView = UIImageView(image: #imageLiteral(resourceName: "focus"))
        focusView.center = poss
        focusView.alpha = 0.0
        previewView.addSubview(focusView)
        if let device = deviceFocus {
            do {
                try device.lockForConfiguration()
                if device.isFocusPointOfInterestSupported {
                    device.focusPointOfInterest = focusPoint
                    device.focusMode = AVCaptureDevice.FocusMode.autoFocus
                    UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
                        focusView.alpha = 1.0
                        focusView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
                    }, completion: { (success) in
                        UIView.animate(withDuration: 0.15, delay: 0.5, options: .curveEaseInOut, animations: {
                            focusView.alpha = 0.0
                            focusView.transform = CGAffineTransform(translationX: 0.6, y: 0.6)
                        }, completion: { (success) in
                            focusView.removeFromSuperview()
                        })
                    })
                }
                if device.isFocusPointOfInterestSupported {
                    device.exposurePointOfInterest = focusPoint
                    device.exposureMode = AVCaptureDevice.ExposureMode.autoExpose
                    UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
                        focusView.alpha = 1.0
                        focusView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
                    }, completion: { (success) in
                        UIView.animate(withDuration: 0.15, delay: 0.5, options: .curveEaseInOut, animations: {
                            focusView.alpha = 0.0
                            focusView.transform = CGAffineTransform(translationX: 0.6, y: 0.6)
                        }, completion: { (success) in
                            focusView.removeFromSuperview()
                        })
                    })
                }
                device.unlockForConfiguration()
            } catch {
                
            }
        }
    }
    
    
}

// MARK: - Camera
extension CameraViewController {
    func requestAccessCamera() {
        let authStatus: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch authStatus {
        case .authorized, .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                self.startLiveCamera()
            }
            break
        default:
            // Show error dialog
            break
        }
    }
    
    func updateFrameVideoPreviewLayer() {
        DispatchQueue.main.sync {
            let originFrame: CGRect = previewView.frame
            let frame: CGRect = CGRect(x: 0, y: 0, width: originFrame.width, height: originFrame.height)
            videoPreviewLayer.frame = frame
            videoPreviewLayer.videoGravity = .resizeAspectFill
        }
    }
    
    func startLiveCamera() {
        guard let device: AVCaptureDevice = AVCaptureDevice.default(for: .video) else {
            return
        }
        self.deviceFocus = device
        do {
            // input
            try captureDeviceInput = AVCaptureDeviceInput(device: device)
            captureSession = AVCaptureSession()
            captureSession.sessionPreset = .high
            
            // output
            capturePhotoOutput = AVCapturePhotoOutput()
            capturePhotoOutput.isHighResolutionCaptureEnabled = true
            capturePhotoOutput.isLivePhotoCaptureEnabled = false
            
            captureSession.beginConfiguration()
            if captureSession.canAddInput(captureDeviceInput) {
                captureSession.addInput(captureDeviceInput)
                if captureSession.canAddOutput(capturePhotoOutput) {
                    captureSession.addOutput(capturePhotoOutput)
                    // init video preview
                    videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                    videoPreviewLayer.removeFromSuperlayer()
                    DispatchQueue.main.sync {
                        previewView.layer.addSublayer(videoPreviewLayer)
                    }
                    updateFrameVideoPreviewLayer()
                    captureSession.commitConfiguration()
                    captureSession.startRunning()
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func loadCamera() {
        let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: cameraPosition)
        captureSession.removeInput((captureSession.inputs.first as AVCaptureInput?)!)
        captureSession.sessionPreset = AVCaptureSession.Preset
            .photo
        if let input = try? AVCaptureDeviceInput(device: device!) {
            if (captureSession.canAddInput(input)){
                captureSession.addInput(input)
                if (captureSession.canAddOutput(cameraOutput)) {
                    cameraOutput.isHighResolutionCaptureEnabled = self.highResolutionEnabled
                    captureSession.addOutput(cameraOutput)
                    videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                    videoPreviewLayer.frame = previewView.bounds
                    videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                    previewView.clipsToBounds = true
                    previewView.layer.addSublayer(videoPreviewLayer)
                    captureSession.startRunning()
                }
            }
            else {
                print("ERROR")
            }
        }
    }
    
    func getSettings(camera: AVCaptureDevice, flashMode: CurrentFlashMode) -> AVCapturePhotoSettings {
        let settings = AVCapturePhotoSettings()
        if camera.hasFlash {
            switch flashMode {
            case .auto:
                settings.flashMode = .auto
            case .on:
                settings.flashMode = .on
            default:
                settings.flashMode = .off
            }
        }
        return settings
    }
    
    func cameraWithPosition(_ position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let deviceDescoverySession = AVCaptureDevice.DiscoverySession.init(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        
        for device in deviceDescoverySession.devices {
            if device.position == position {
                return device
            }
        }
        return nil
    }
}

// MARK: - Delegate Camera
extension CameraViewController: AVCapturePhotoCaptureDelegate,  AVCaptureVideoDataOutputSampleBufferDelegate {
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?)
    {
        guard error == nil,
            let photoSampleBuffer = photoSampleBuffer else {
                print("Error capturing photo: \(String(describing: error))")
                return
        }
        // Convert photo same buffer to a jpeg image data by using
        guard let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else {
            return
        }
        let dataProvider = CGDataProvider(data: imageData as CFData)
        let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.absoluteColorimetric)
        let image = UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.right)
        imagePhoto.isHidden = false
        imagePhoto.image = image
        createAlert(img: image)
    }
}

// MARK: - Alert
extension CameraViewController {
    func createAlert(img: UIImage) {
        let alert = UIAlertController(title: "Thông Báo", message: "Nhập tên ảnh.", preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.placeholder = "Mời bạn nhập tên ảnh."
        }
        let actionOK = UIAlertAction(title: "Hoàn Thành", style: .default) { (_) in
            let textField = alert.textFields![0]
            let strTextField =  textField.text
            self.createIndicator(color: .whiteLarge)
            if ManagerGoogleDrive.shared.isAuthorized() {
                ManagerGoogleDrive.shared.uploadFileToFolder(image: img, fileName: strTextField!) { (status) in
                    self.removeIndicator()
                    let qualifierVC =  StoryBoardManager.instanceQualifierHomeViewController()
                    self.navigationController?.pushViewController(qualifierVC, animated: true)
                    NSLog("Success");
                }
            }else {
                ManagerGoogleDrive.shared.authorize(in: self, authorizationCompletion: { (status) in
                    ManagerGoogleDrive.shared.uploadFileToFolder(image: img, fileName: strTextField!) { (status) in
                        NSLog("Failed");
                    }
                })
            }
        }
        alert.addAction(actionOK)
        self.present(alert, animated: true, completion: nil)
    }
}
