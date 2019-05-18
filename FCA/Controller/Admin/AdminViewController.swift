//
//  AdminViewController.swift
//  FCA
//

import UIKit

class AdminViewController: BaseViewController {
    @IBOutlet weak var applicantTableView: UITableView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var textfieldSearch: UITextField!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var btnUpload: UIButton!
    
    var fullApp: [Applicant] = []
    var backupApp: [Applicant] = []
    var applicants: [Applicant] = []
    var listResultFilesId: [String] = []
    var listResultFilesName: [String] = []
    var downloadFile: Int = -1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
        textfieldSearch.addTarget(self, action: #selector(AdminViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        let account = UserDefaults.standard.object(forKey: Keys.ACCOUNT) as? String
        labelName.text = AccountData.getInforByAccount(account: account!)
        createDirectory(name: "Download")
        createDirectory(name: "Admin")
        loadApplicantResult()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Update point if needed
        let userdefault = UserDefaults.standard
        guard userdefault.object(forKey: Keys.CHECK_UPDATE_POINT) != nil else {
            return
        }
        let data = userdefault.object(forKey: Keys.CHECK_UPDATE_POINT) as? Bool

        if data! {
            let point = UserDefaults.standard.object(forKey: Keys.UPDATE_OBJECT) as! [Double]
            let index = UserDefaults.standard.object(forKey: Keys.UPDATE_INDEX) as! Int
            UserDefaults.standard.set(false, forKey: Keys.CHECK_UPDATE_POINT)
            if applicants.count > 0 {
                applicants[index].point = point
            }
            applicants.sort(by: { a1, a2 in
                return a1.calculateTotalPoint() > a2.calculateTotalPoint()
            })
            applicantTableView.reloadData()
        }
    }
    
    // Call this function inside button upload action
    func clickButtonUpload() {
//        loadExcelData()
        saveResultToFile {
            let alert = UIAlertController(title: "Thông Báo", message: "Nhập tên file.", preferredStyle: .alert)
            alert.addTextField { (textfield) in
                textfield.placeholder = "Nhập tên file."
            }
            let actionOK = UIAlertAction(title: "Hoàn Thành", style: .default) { (_) in
                let textField = alert.textFields![0]
                let strTextField =  textField.text
                self.createIndicator(color: .whiteLarge)
                var paths: Array = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true) as Array
                let fullPath: String = paths[0] + "/Admin/Result.xlsx"
                if ManagerGoogleDrive.shared.isAuthorized() {
                    ManagerGoogleDrive.shared.uploadExcelFileToAdmin(filePath: fullPath, fileName: strTextField!) { (status) in
                        self.removeIndicator()
                    }
                }else {
                    ManagerGoogleDrive.shared.uploadExcelFileToAdmin(filePath: fullPath, fileName: strTextField!) { (status) in
                        self.removeIndicator()
                    }
                }
            }
            alert.addAction(actionOK)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func setupUI() {
        btnClear.layer.borderWidth = 1.0
        btnClear.layer.borderColor =  UIColor.white.cgColor
        btnUpload.layer.borderWidth = 1.0
        btnUpload.layer.borderColor =  UIColor.white.cgColor
    }
    
    //MARK: Button Click
    
    @IBAction func invokeButtonUpload(_ sender: Any) {
        self.clickButtonUpload()
    }
    
    @IBAction func invokeButtonClear(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: Keys.CANDIDATE_CHECKED)
        var checkedList: [String] = []
        UserDefaults.standard.set(checkedList, forKey: Keys.CANDIDATE_CHECKED)
        let alert = UIAlertController(title: "Notification", message: "Clear Success!", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

extension AdminViewController {
    func loadApplicantResult() {
        loadResultFilesId(completion: {
            //loadExcelData
            let spinIndicatorTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: {_ in
                if self.downloadFile == 0 {
                    self.loadExcelData()
                }
            })
            spinIndicatorTimer.fire()
        })
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
                        self.listResultFilesId.append(Array.identifier!)
                        self.listResultFilesName.append(Array.originalFilename!)
                    }
                }
                print(self.listResultFilesId.count)
                self.downloadFile = self.listResultFilesId.count
                for index in 0..<self.listResultFilesId.count {
                    //10
                    let deadlineTime = DispatchTime.now() + .milliseconds(index * 250)
                    DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                        self.downloadFilesFromDrives(id: self.listResultFilesId[index], index: index)
                    }
                    
                }
                completion()
            }
        }
    }
    
    func downloadFilesFromDrives(id: String, index: Int) {
        ManagerGoogleDrive.shared.getFile(fileId: id) {
            data in
            do {
                var paths: Array = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true) as Array
                let fullPath: String = paths[0] + "/Download/" + self.listResultFilesName[index] + ".xlsx"
                let something = data.write(toFile: fullPath, atomically: true)
                if something {
                    print("Saved file \(fullPath)")
                    self.downloadFile = self.downloadFile - 1
                    // count++
                }
            }
        }
    }
    
    func createDirectory(name: String) {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true) as Array
        let documentsDirectory: String = paths[0]
        
        let dataPath = documentsDirectory + "/" + name
        if (!FileManager.default.fileExists(atPath: dataPath)) {
            do {
                try FileManager.default.createDirectory(atPath: dataPath, withIntermediateDirectories: false, attributes: nil)
            }catch let error as NSError {
                print(error.localizedDescription);
            }
        }
    }
    
    func loadExcelData() {
        self.downloadFile = 1
        var paths: Array = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true) as Array
        let parentPath: String = paths[0] + "/Download/"
        var listLoaded: [String] = []
        applicants.removeAll()
        for index1 in 0..<self.listResultFilesId.count {
            if (listLoaded.contains(listResultFilesName[index1])) {
                continue
            }
            
            listLoaded.append(listResultFilesName[index1])
            let filePath = parentPath + listResultFilesName[index1] + ".xlsx"
            let spreadsheet: BRAOfficeDocumentPackage = BRAOfficeDocumentPackage.open(filePath)
            if (spreadsheet.workbook == nil) {
                continue
            }
            for index in 0..<spreadsheet.workbook.worksheets.count - 1 {
                let worksheet = spreadsheet.workbook.worksheets[index] as! BRAWorksheet
                let phone = worksheet.cell(forCellReference: "B2").stringValue()
                let name = worksheet.cell(forCellReference: "A2").stringValue()
                let examName = worksheet.cell(forCellReference: "C2").stringValue()
                let type = worksheet.cell(forCellReference: "G2").stringValue()
//                let type = "1"
                var listFactor: [String] = []
                var listPoint: [Double] = []
                let indexOfExam = ExamData.ExaminationList.index(of: examName!)
                for i in 0..<ExamData.ExaminationFactors[indexOfExam!].count {
                    let fName = worksheet.cell(forCellReference: "A\(i + 4)").stringValue()
                    let fPoint = worksheet.cell(forCellReference: "B\(i + 4)").stringValue()
                    listFactor.append(fName!)
                    listPoint.append(Double(fPoint!)!)
                }
                let app = Applicant.init(exam: examName!, factor: listFactor, point: listPoint, id: phone!, name: name!, type: type!)
                if applicants.index(where: {
                    a1 in
                    return a1.name == app.name && a1.id == app.id && a1.exam == app.exam
                }) != nil {
                    // Exist applicant
                    let index = applicants.index(where: {
                        a1 in
                        return a1.name == app.name && a1.id == app.id && a1.exam == app.exam
                    })
                    applicants[index!].updatePoint(point: app.point)
                } else {
                    applicants.append(app)
                }
                applicants.sort(by: { a1, a2 in
                    return a1.calculateTotalPoint() > a2.calculateTotalPoint()
                })
                applicantTableView.reloadData()
            }
        }
    }

    func saveResultToFile(completion: @escaping () -> Void) {
        let path: String = Bundle.main.path(forResource: "Blank", ofType: "xlsx")!
        var spreadsheet: BRAOfficeDocumentPackage = BRAOfficeDocumentPackage.open(path)
        
        // Separate subjects to sheets
        for subject in ExamData.ExaminationListFull {
            let sheet: BRASheet = spreadsheet.workbook.sheets[spreadsheet.workbook.sheets.count - 1] as! BRASheet
            sheet.name = subject
            let worksheet: BRAWorksheet = spreadsheet.workbook.worksheets[spreadsheet.workbook.sheets.count - 1] as! BRAWorksheet
            let data = filtApplicantBySubject(subject: subject)
            if data.isEmpty {
                continue
            }
            // Print Titles
            worksheet.cell(forCellReference: "A1", shouldCreate: true).setStringValue("ID")
            worksheet.cell(forCellReference: "B1", shouldCreate: true).setStringValue("Name")
            worksheet.cell(forCellReference: "C1", shouldCreate: true).setStringValue("Rank")
            worksheet.cell(forCellReference: "D1", shouldCreate: true).setStringValue("Total Mark")
            var counter1 = 69
            for factor in data[0].factor {
                worksheet.cell(forCellReference: String(UnicodeScalar(UInt8(counter1))) + "1", shouldCreate: true).setStringValue(factor)
                counter1 += 1
            }
            // Print applicants informations
            for appNo in 0..<data.count {
                worksheet.cell(forCellReference: "A\(appNo + 2)", shouldCreate: true).setStringValue(data[appNo].id)
                worksheet.cell(forCellReference: "B\(appNo + 2)", shouldCreate: true).setStringValue(data[appNo].name)
                worksheet.cell(forCellReference: "C\(appNo + 2)", shouldCreate: true).setStringValue((appNo + 1).description)
                worksheet.cell(forCellReference: "D\(appNo + 2)", shouldCreate: true).setStringValue(data[appNo].calculateTotalPoint().description)
                // Print detail results
                var counter = 69
                for factNo in 0..<data[appNo].factor.count {
                    worksheet.cell(forCellReference: String(UnicodeScalar(UInt8(counter))) + "\(appNo + 2)", shouldCreate: true).setStringValue(data[appNo].point[factNo].description)
                    counter += 1
                }
            }
            if (ExamData.ExaminationList.last == subject) {
                break
            }
            spreadsheet.workbook.createWorksheetNamed("Next Applicant")
        }
        var paths: Array = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true) as Array
        let fullPath: String = paths[0] + "/Admin/Result.xlsx"
        spreadsheet.save(as: fullPath)
        completion()
    }
    
    func filtApplicantBySubject(subject: String) -> [Applicant] {
        var filerResult: [Applicant] = []
        // detect weather expert or master, human or 3d skin
        var type = "0"
        if subject.contains("Expert") {
            type = "1"
        }
        if subject.contains("Master") {
            type = "2"
        }
        if subject.contains("Human") {
            type = "3"
        }
        if subject.contains("3D Skin") {
            type = "4"
        }
        for applicant in self.applicants {
//            if applicant.exam == subject {
//                filerResult.append(applicant)
//            }
            if subject.contains(applicant.exam) && applicant.type == type {
                filerResult.append(applicant)
            }
        }
        filerResult.sort(by: { a1, a2 in
            return a1.calculateTotalPoint() > a2.calculateTotalPoint()
        })
        return filerResult
    }
}

extension AdminViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ExamData.ExaminationListFull.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let data = filtApplicantBySubject(subject: ExamData.ExaminationListFull[section])
        return data.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let data = filtApplicantBySubject(subject: ExamData.ExaminationListFull[section])
        return ExamData.ExaminationListFull[section].replacingOccurrences(of: "Human", with: "") + ": \(data.count.description) applicants"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        for subView in cell.subviews {
            subView.removeFromSuperview()
        }
//        cell.textLabel?.font = UIFont(name: "Avenir", size: 22)
        let data = filtApplicantBySubject(subject: ExamData.ExaminationListFull[indexPath.section])
        cell.textLabel?.text = data[indexPath.row].name
        let lblName = UILabel(frame: CGRect(x: 0, y: 0, width: cell.bounds.width - 50, height: 50))
        let lblPoint = UILabel(frame: CGRect(x: cell.bounds.width - 50, y: 0, width: 50, height: 50))
        lblName.text = data[indexPath.row].name + " - " + data[indexPath.row].id
        lblPoint.text = data[indexPath.row].calculateTotalPoint().description
        lblName.baselineAdjustment = .alignCenters
        lblName.adjustsFontSizeToFitWidth = true
        lblName.font = UIFont(name: "Avenir", size: 22)
        lblName.clipsToBounds = true
        lblPoint.textAlignment = .right
        lblPoint.baselineAdjustment = .alignCenters
        lblPoint.adjustsFontSizeToFitWidth = true
        lblPoint.font = UIFont(name: "Avenir", size: 22)
        lblPoint.clipsToBounds = true
        cell.addSubview(lblPoint)
        cell.addSubview(lblName)
        print("loaded \(indexPath.row)")
        return cell
    }
}

extension AdminViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = filtApplicantBySubject(subject: ExamData.ExaminationListFull[indexPath.section])
        let name = data[indexPath.row].name
        let phone = data[indexPath.row].id
        let index = findIndexOfApplicant(id: phone!, name: name!, exam: ExamData.ExaminationListFull[indexPath.section])
        UserDefaults.standard.set(index, forKey: Keys.UPDATE_INDEX)
        let applicant = applicants[index]
        let editVC = StoryBoardManager.instanceEditPointViewController()
        editVC.applicant = applicant
        self.navigationController?.pushViewController(editVC, animated: true)
    }
}

extension AdminViewController {
    func findIndexOfApplicant(id: String, name: String, exam: String) -> Int {
        var type = "0"
        if exam.contains("Expert") {
            type = "1"
        }
        if exam.contains("Master") {
            type = "2"
        }
        if exam.contains("Human") {
            type = "3"
        }
        if exam.contains("3D Skin") {
            type = "4"
        }
        for i in 0..<applicants.count {
            if applicants[i].name == name && exam.contains(applicants[i].exam) && applicants[i].type == type && applicants[i].id == id {
                return i
            }
        }
        return -1
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let newText = textField.text as! String
        if fullApp.isEmpty {
            fullApp.append(contentsOf: applicants)
        }
        applicants.removeAll()
        applicants.append(contentsOf: fullApp)
        if (newText.count > 0) {
            var i = 0
            while i < applicants.count {
                if applicants[i].name.lowercased().range(of: newText.lowercased()) == nil {
                    applicants.remove(at: i)
                } else {
                    i += 1
                }
            }
        }
        self.applicantTableView.reloadData()
    }
}

//extension AdminViewController : UITextFieldDelegate {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        // Only proces when textfield is search txtField
//        if textField == self.textfieldSearch {
//            let currentText = textField.text
//            let location = range.location
//            let newText = currentText![0..<location] + string + currentText![location..<(currentText?.count)! - 1]
//            self.filtListApplicant(key: newText)
////            return false
//        }
//        return true
//    }
//}
