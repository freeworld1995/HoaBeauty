//
//  QualifierHome.swift
//  FCA
//
//  Created by 1 on 8/9/18.
//  Copyright © 2018 FCA2018. All rights reserved.
//

import UIKit
import AVFoundation

class QualifierHomeView: BaseViewController , QRCodeReaderViewControllerDelegate
{
    @IBOutlet private weak var examTableView: ExamTableView!
    @IBOutlet weak var lbAccount: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbInformation: UILabel!
    @IBOutlet weak var viewInfo: UIView!
    
    
    var account: Account!
    var listExamination: [Examination] = []
    var activeList: [Int] = []
    var examsArr: [CheckList] = []
    var candidateCode: String = ""
    var id: String = ""
    var fileName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewInfo.layer.cornerRadius = 5.0
        getData()
        loadQualifierInfor()
        loadExaminationData()
        examTableView.initComponents()
        examTableView.setupData(examsArr, activeList)
        examTableView.showsVerticalScrollIndicator = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCandidateCode()
        emptyLeftItem()
    }
    
    func loadQualifierInfor() {
        let account = UserDefaults.standard.object(forKey: Keys.ACCOUNT) as? String
        lbAccount.text = account
        lbName.text = AccountData.getInforByAccount(account: account!)
        lbInformation.text = UserDefaults.standard.object(forKey: Keys.TYPE) as? String
        activeList = AccountData.getListActiveExam1(account: account!)
    }
    
    func loadExaminationData() {
        for i in 0..<ExamData.ExaminationList.count {
            let exam: Examination = Examination.init(name: ExamData.ExaminationList[i], infor: ExamData.InformationList[i], image: ExamData.imageList[i], factor: ExamData.ExaminationFactors[i])
            self.listExamination.append(exam)
        }
    }
    
    func getData() {
        if let path: URL = Bundle.main.url(forResource: "mockdata", withExtension: "json") {
            do {
                let jsonData: Data = try Data(contentsOf: path, options: .mappedIfSafe)
                do {
                    if let jsonResult: NSDictionary = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? NSDictionary {
                        if let areasArray: NSArray =  jsonResult.value(forKey: "quizs") as? NSArray {
                            for (_, elements) in areasArray.enumerated() {
                                if let element: NSDictionary = elements as? NSDictionary {
                                    let image = element.value(forKey: "image") as! String
                                    let exams =  element.value(forKey: "exams") as! String
                                    let mark = element.value(forKey: "mark") as! [String]
                                    let examsObj: CheckList =  CheckList(image: image, exams: exams, mark: mark)
                                    self.examsArr.append(examsObj)
                                }
                            }
                        }
                    }
                }  catch let error as NSError {
                    print("Error: \(error)")
                }
            } catch let error as NSError {
                print("Error: \(error)")
            }
        }
    }
    
    func saveCandidateInfo(info: String) {
        let parts = info.components(separatedBy: " - ")
        let name = parts.first
        let phone = parts.last
        UserDefaults.standard.set(name, forKey: Keys.CANDIDATE_CODE)
        UserDefaults.standard.set(phone, forKey: Keys.CANDIDATE_PHONE)
    }
    
    // MARK: - Button Click
    
    @IBAction func invokeButtonBarcode(_ sender: Any) {
        guard checkScanPermissions() else { return }
        readerVC.modalPresentationStyle = .formSheet
        readerVC.delegate               = self
        
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            if let result = result {
                print("Completion with result: \(result.value) of type \(result.metadataType)")
                self.saveCandidateInfo(info: result.value)
            }
        }
        present(readerVC, animated: true, completion: nil)
    }
    
    @IBAction func invokeButtonDone(_ sender: Any) {
//        // Clear data and back to desktop
//        fileName = UserDefaults.standard.object(forKey: Keys.ACCOUNT) as! String
//        UserDefaults.standard.removeObject(forKey: Keys.CANDIDATE_CODE)
//        UserDefaults.standard.removeObject(forKey: Keys.EXAMINATION_NAME)
////        self.navigationController?.popViewController(animated: true)
//        self.uploadPoint()
    }
    
    // MARK: -Submit Point To Server
    func uploadPoint() {
        var paths: Array = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true) as Array
        let fullPath: String = paths[0] + "/" + self.fileName + ".xlsx"
        if ManagerGoogleDrive.shared.isAuthorized() {
            loadResultFilesId(completion: {
                ManagerGoogleDrive.shared.uploadExcelFile(filePath: fullPath, fileName: self.fileName, id: self.id) { (status) in
                    let alert = UIAlertController(title: "Notification", message: "Send File To Excel Success", preferredStyle: .alert)
                    let actionOK = UIAlertAction(title: "OK", style: .default, handler: { (_) in
                    })
                    alert.addAction(actionOK)
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }else {
            loadResultFilesId(completion: {
                ManagerGoogleDrive.shared.uploadExcelFile(filePath: fullPath, fileName: self.fileName, id: self.id) { (status) in
                    let alert = UIAlertController(title: "Notification", message: "Send File To Excel Failed", preferredStyle: .alert)
                    let actionOK = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(actionOK)
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
    func isAvailableToSubmit() -> Bool {
        var paths: Array = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true) as Array
        let fullPath: String = paths[0] + "/Result.xlsx"
        // Open the spreadsheet, get the first sheet, first worksheet, and first cell A1.
        // This is solely demo code to show basics; your actual code would do much more here.
        var spreadsheet: BRAOfficeDocumentPackage = BRAOfficeDocumentPackage.open(fullPath)
        if (spreadsheet.workbook == nil) {
            // Chua co file nao
            return false
        }
        return true
    }
    
    func loadResultFilesId(completion: @escaping () -> Void) {
        ManagerGoogleDrive.shared.loadDriveFiles() {
            (filesList) in
            if let filesShow : [GTLRDrive_File] = filesList.files {
                for Array in filesShow {
                    if (Array.trashed?.boolValue)! {
                        // File is deleted
                        //print("Deleted")
                    } else {
                        //print(Array.identifier)
                        // Append file ID to list
                        //                        self.listResultFilesId.append(Array.identifier!)
                        //                        self.listResultFilesName.append(Array.originalFilename!)
                        if Array.originalFilename == self.fileName {
                            self.id = Array.identifier!
                        }
                    }
                }
                completion()
            }
        }
    }
    
    lazy var reader: QRCodeReader = QRCodeReader()
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader                  = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            $0.showTorchButton         = true
            $0.preferredStatusBarStyle = .lightContent
            
            $0.reader.stopScanningWhenCodeIsFound = false
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    // MARK: - Actions
    
    private func checkScanPermissions() -> Bool {
        do {
            return try QRCodeReader.supportsMetadataObjectTypes()
        } catch let error as NSError {
            let alert: UIAlertController
            
            switch error.code {
            case -11852:
                alert = UIAlertController(title: "Error", message: "This app is not authorized to use Back Camera.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (_) in
                    DispatchQueue.main.async {
                        if let settingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                            UIApplication.shared.openURL(settingsURL)
                        }
                    }
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            default:
                alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            }
            
            present(alert, animated: true, completion: nil)
            
            return false
        }
    }
    
    // MARK: - QRCodeReader Delegate Methods
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        UserDefaults.standard.set(result.value, forKey: Keys.CHECK_QRCODE)
        print(Keys.CHECK_QRCODE)
        dismiss(animated: true) { [weak self] in
            let alert = UIAlertController(
                title: "Success",
                message: "Please choose examination.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        print("Switching capturing to: \(newCaptureDevice.device.localizedName)")
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
    }
}

extension QualifierHomeView
{
    func loadCandidateCode() {
        guard let code = UserDefaults.standard.object(forKey: Keys.CANDIDATE_CODE) else {
            return
        }
        self.candidateCode = code as! String
        examTableView.candidateCode = self.candidateCode
    }
}
