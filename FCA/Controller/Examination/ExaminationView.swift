import UIKit
import Darwin

class ExaminationView: BaseViewController
{
    @IBOutlet private weak var examTableView: ExaminationTableView!
    @IBOutlet weak var btnSubmit: UIButton!
    
    var factors: [Int] = []
    var indexPathEx: CheckList!
    var aa: [String] = []
    var id: String = ""
    var fileName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSubmit.layer.borderWidth = 2.0
        btnSubmit.layer.borderColor = UIColor.white.cgColor
        prepareData()
//        loadFactorList()
        examTableView.initComponents()
        examTableView.setupData(indexPathEx!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        createBackButtonWithTitle(title: "")
        print("Anything")
    }
    
    @IBAction func invokeButtonSubmit(_ sender: UIButton) {
        if checkNetWork() {
            self.indexPathEx = examTableView.factors
            saveMarkToExcel();
            //nameSV: UserDefaults.standard.object(forKey: Keys.CANDIDATE_CODE) as! String,
            let account = UserDefaults.standard.object(forKey: Keys.ACCOUNT) as? String
            popupPoint(nameGV: AccountData.getInforByAccount(account: account!), nameSV: UserDefaults.standard.object(forKey: Keys.CANDIDATE_CODE) as! String, totalPoint: (self.indexPathEx?.calculateTotalPoint().description)!)
            UserDefaults.standard.removeObject(forKey: Keys.CANDIDATE_CODE)
            UserDefaults.standard.removeObject(forKey: Keys.CANDIDATE_PHONE)
            UserDefaults.standard.removeObject(forKey: Keys.EXAMINATION_NAME)
        }
    }
    
    @IBAction func invokeButtonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc
    func reload() {
//        loadFactorList()
        examTableView.setupData(indexPathEx!)
    }
}

extension ExaminationView
{
    func loadFactorList() {
        let examName = UserDefaults.standard.object(forKey: Keys.EXAMINATION_NAME) as! String
        let indexOfExam = ExamData.ExaminationList.index(of: examName)
        factors = ExamData.ExaminationFactors[indexOfExam!]
    }
    
    func prepareData() {
        UserDefaults.standard.removeObject(forKey: Keys.FACTOR_LIST)
        UserDefaults.standard.removeObject(forKey: Keys.POINT_LIST)
        UserDefaults.standard.removeObject(forKey: Keys.CURRENT_FACTOR)
        
        UserDefaults.standard.set([], forKey: Keys.FACTOR_LIST)
        UserDefaults.standard.set([], forKey: Keys.POINT_LIST)
        UserDefaults.standard.set([], forKey: Keys.CURRENT_FACTOR)
    }
    
    func saveMarkToExcel() {
        let path: String = Bundle.main.path(forResource: "Blank", ofType: "xlsx")!
        var paths: Array = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true) as Array
        let fileName = UserDefaults.standard.object(forKey: Keys.ACCOUNT) as! String
        let fullPath: String = paths[0] + "/" + fileName + ".xlsx"
        
        // Open the spreadsheet, get the first sheet, first worksheet, and first cell A1.
        // This is solely demo code to show basics; your actual code would do much more here.
        var spreadsheet: BRAOfficeDocumentPackage = BRAOfficeDocumentPackage.open(fullPath)
        var checkedList = UserDefaults.standard.object(forKey: Keys.CANDIDATE_CHECKED) as! [String]
        if (spreadsheet.workbook == nil || checkedList.isEmpty) {
            spreadsheet = BRAOfficeDocumentPackage.open(path)
        }

        let sheet: BRASheet = spreadsheet.workbook.sheets[spreadsheet.workbook.sheets.count - 1] as! BRASheet
        // Save sheet name, equals
        sheet.name = UserDefaults.standard.object(forKey: Keys.CANDIDATE_CODE) as! String
        let worksheet: BRAWorksheet = spreadsheet.workbook.worksheets[spreadsheet.workbook.sheets.count - 1] as! BRAWorksheet

        // Set sumary values titles
        worksheet.cell(forCellReference: "A1", shouldCreate: true).setStringValue("Name")
        worksheet.cell(forCellReference: "B1", shouldCreate: true).setStringValue("Phone")
        worksheet.cell(forCellReference: "C1", shouldCreate: true).setStringValue("Subject")
        worksheet.cell(forCellReference: "D1", shouldCreate: true).setStringValue("Total Mark")
        worksheet.cell(forCellReference: "E1", shouldCreate: true).setStringValue("Qualifier ID")
        worksheet.cell(forCellReference: "F1", shouldCreate: true).setStringValue("Qualifier Name")
        worksheet.cell(forCellReference: "G1", shouldCreate: true).setStringValue("Type")// Master, expert, skin, fake skin
        
        worksheet.cell(forCellReference: "A2", shouldCreate: true).setStringValue(UserDefaults.standard.object(forKey: Keys.CANDIDATE_CODE) as! String)
        worksheet.cell(forCellReference: "B2", shouldCreate: true).setStringValue(UserDefaults.standard.object(forKey: Keys.CANDIDATE_PHONE) as! String)
        worksheet.cell(forCellReference: "C2", shouldCreate: true).setStringValue(UserDefaults.standard.object(forKey: Keys.EXAMINATION_NAME) as! String)
        worksheet.cell(forCellReference: "D2", shouldCreate: true).setStringValue((self.indexPathEx?.calculateTotalPoint().description)!)
        let account = UserDefaults.standard.object(forKey: Keys.ACCOUNT) as! String
        worksheet.cell(forCellReference: "E2", shouldCreate: true).setStringValue(account)
        let name = AccountData.getInforByAccount(account: account)
        worksheet.cell(forCellReference: "F2", shouldCreate: true).setStringValue(name)
//        let randomInt = arc4random_uniform(2) + 1
        worksheet.cell(forCellReference: "G2", shouldCreate: true).setStringValue(UserDefaults.standard.object(forKey: Keys.EXAMINATION_TYPE) as! String)
        
        // Set detail points
        worksheet.cell(forCellReference: "A3", shouldCreate: true).setStringValue("Factor")
        worksheet.cell(forCellReference: "B3", shouldCreate: true).setStringValue("Point")
        for i in 0..<self.indexPathEx.marks.count {
            worksheet.cell(forCellReference: "A\(i + 4)", shouldCreate: true).setStringValue(self.indexPathEx.marks[i])
        }
        for i in 0..<self.indexPathEx.point.count {
            worksheet.cell(forCellReference: "B\(i + 4)", shouldCreate: true).setStringValue(self.indexPathEx.point[i].description)
        }
        
        // Save to document to backup and preview
        // Add new sheet for next applicant
        spreadsheet.workbook.createWorksheetNamed("Next Applicant")
        spreadsheet.save(as: fullPath)
        
        // Print out
//        let cell: BRACell = worksheet.cell(forCellReference: "A1")
//        let string: String = cell.stringValue()
//        print(string)
        uploadData()
    }
    
    // MARK: -Submit Point To Server
    func uploadData()  {
        // Clear data and back to desktop
        fileName = UserDefaults.standard.object(forKey: Keys.ACCOUNT) as! String

        self.uploadPoint()
        let name = UserDefaults.standard.object(forKey: Keys.CANDIDATE_CODE) as! String
        let phone = UserDefaults.standard.object(forKey: Keys.CANDIDATE_PHONE) as! String
        let exam = UserDefaults.standard.object(forKey: Keys.EXAMINATION_NAME) as! String
        
        guard UserDefaults.standard.object(forKey: Keys.CANDIDATE_CHECKED) != nil else {
            var checkedList: [String] = []
            checkedList.append("\(name) - \(phone) - \(fileName) - \(exam)")
            UserDefaults.standard.set(checkedList, forKey: Keys.CANDIDATE_CHECKED)
            return
        }
        var checkedList = UserDefaults.standard.object(forKey: Keys.CANDIDATE_CHECKED) as! [String]
        checkedList.append("\(name) - \(phone) - \(fileName) - \(exam)")
        UserDefaults.standard.set(checkedList, forKey: Keys.CANDIDATE_CHECKED)
        //        self.navigationController?.popViewController(animated: true)
    }
    
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
