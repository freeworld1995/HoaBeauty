//
//  DesktopQualifierViewController.swift
//  FCA
//
//  Created by Minh Công on 9/15/18.
//  Copyright © 2018 minhcong. All rights reserved.
//

import UIKit

class DesktopQualifierViewController: BaseViewController {

    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var btnMark: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    var id: String = ""
    var fileName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewContent.layer.cornerRadius = 10.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fileName = UserDefaults.standard.object(forKey: Keys.ACCOUNT) as! String
        btnSubmit.isEnabled = isAvailableToSubmit() ? true : false
        btnSubmit.alpha = isAvailableToSubmit() ? 1 : 0.5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Button Click
    @IBAction func invokeButtonMark(_ sender: Any) {
        let cameraVC = StoryBoardManager.instanceCameraViewController()
        self.navigationController?.pushViewController(cameraVC, animated: true)
    }
    
    @IBAction func invokeButtonSubmit(_ sender: Any) {
        // Submit marks file to drive
        var paths: Array = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true) as Array
        let fullPath: String = paths[0] + "/Result.xlsx"
        if ManagerGoogleDrive.shared.isAuthorized() {
            loadResultFilesId(completion: {
                ManagerGoogleDrive.shared.uploadExcelFile(filePath: fullPath, fileName: self.fileName, id: self.id) { (status) in
                    let alert = UIAlertController(title: "Notification", message: "Send File To Excel Success", preferredStyle: .alert)
                    let actionOK = UIAlertAction(title: "OK", style: .default, handler: { (_) in
                        let cameraVC = StoryBoardManager.instanceCameraViewController()
                        self.navigationController?.pushViewController(cameraVC, animated: true)
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
}
