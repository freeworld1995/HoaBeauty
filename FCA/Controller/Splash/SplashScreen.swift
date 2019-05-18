//
//  SplashScreen.swift
//  FCA
//
//  Created by 1 on 8/7/18.
//  Copyright © 2018 FCA2018. All rights reserved.
//

import UIKit

class SplashView: BaseViewController {
    
    @IBOutlet weak var largeIndicator: UIImageView!
    @IBOutlet weak var mediumIndicator: UIImageView!
    @IBOutlet weak var smallIndicator: UIImageView!
    @IBOutlet weak var labelContent: UILabel!
    
    var accountList: [Account] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load account data and convert to accounts data
        // Default loading 3s and then move to login
//        saveMarkToExcel()
//        self.labelContent.text = "WELCOME TO THE INTERNAITONAL \n LASH & P.M.U COMPETITION \n 2018"
        let deadlineTime = DispatchTime.now() + .seconds(3)
        let spinIndicatorTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: {_ in
            self.largeIndicator.transform = self.largeIndicator.transform.rotated(by: CGFloat(Double.pi / 10))
            self.mediumIndicator.transform = self.mediumIndicator.transform.rotated(by: CGFloat(Double.pi / 12))
            self.smallIndicator.transform = self.smallIndicator.transform.rotated(by: CGFloat(Double.pi / 15))
        })
        spinIndicatorTimer.fire()
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            spinIndicatorTimer.invalidate()
            self.setRootViewIsMainView()
        }
        setupData()
    }
    
    func setupData() {
        guard UserDefaults.standard.object(forKey: Keys.CANDIDATE_CHECKED) != nil else {
            var checkedList: [String] = []
            UserDefaults.standard.set(checkedList, forKey: Keys.CANDIDATE_CHECKED)
            return
        }
    }
    
    @objc
    func spinner() {
        self.largeIndicator.transform = self.largeIndicator.transform.rotated(by: CGFloat(Double.pi / 10))
        self.mediumIndicator.transform = self.mediumIndicator.transform.rotated(by: CGFloat(Double.pi / 12))
        self.smallIndicator.transform = self.smallIndicator.transform.rotated(by: CGFloat(Double.pi / 15))
    }
    
    func loadAccountData() {
        for account in AccountData.account {
            let newAccount = Account.init(account: account[0] as String, password: account[1] as String, type: account[2] as String)
            accountList.append(newAccount)
        }
        UserDefaults.standard.set(accountList, forKey: Keys.ACCOUNT_LIST)
    }
    
    func setRootViewIsMainView() {
        // Come to Login View
        let loginView = StoryBoardManager.instanceLoginViewController()
        loginView.accountList = self.accountList
        let window = UIApplication.shared.windows[0]
        let storyBoard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let navigation = storyBoard.instantiateInitialViewController() as! UINavigationController
        navigation.viewControllers = [loginView]
        window.rootViewController = navigation
    }
    
//    func saveMarkToExcel() {
//        let path: String = Bundle.main.path(forResource: "Blank", ofType: "xlsx")!
//        var paths: Array = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true) as Array
//        let fullPath: String = paths[0] + "/testSaveAs.xlsx"
//
//        // Open the spreadsheet, get the first sheet, first worksheet, and first cell A1.
//        // This is solely demo code to show basics; your actual code would do much more here.
//        var spreadsheet: BRAOfficeDocumentPackage = BRAOfficeDocumentPackage.open(fullPath)
//        if (spreadsheet.workbook == nil) {
//            spreadsheet = BRAOfficeDocumentPackage.open(path)
//        }
//        let sheet: BRASheet = spreadsheet.workbook.sheets[spreadsheet.workbook.sheets.count - 1] as! BRASheet
//        // Save sheet name, equals
//        sheet.name = "Current applicant"
//        // Add new sheet for next applicant
//        spreadsheet.workbook.createWorksheetNamed("something")
//
//        let worksheet: BRAWorksheet = spreadsheet.workbook.worksheets[spreadsheet.workbook.sheets.count - 1] as! BRAWorksheet
//
//        // Set sumary values titles
//        worksheet.cell(forCellReference: "A1", shouldCreate: true).setStringValue("ID")
//        worksheet.cell(forCellReference: "B1", shouldCreate: true).setStringValue("Name")
//        worksheet.cell(forCellReference: "C1", shouldCreate: true).setStringValue("Subject")
//        worksheet.cell(forCellReference: "D1", shouldCreate: true).setStringValue("Total Mark")
//        worksheet.cell(forCellReference: "E1", shouldCreate: true).setStringValue("Qualifier ID")
//        worksheet.cell(forCellReference: "F1", shouldCreate: true).setStringValue("Qualifier Name")
//
//        worksheet.cell(forCellReference: "A2", shouldCreate: true).setStringValue("ID")
//        worksheet.cell(forCellReference: "B2", shouldCreate: true).setStringValue("Name")
//        worksheet.cell(forCellReference: "C2", shouldCreate: true).setStringValue("Subject")
//        worksheet.cell(forCellReference: "D2", shouldCreate: true).setStringValue("Total Mark")
//        worksheet.cell(forCellReference: "E2", shouldCreate: true).setStringValue("Qualifier ID")
//        worksheet.cell(forCellReference: "F2", shouldCreate: true).setStringValue("Qualifier Name")
//
//        // Save to document to backup and preview
//        spreadsheet.save(as: fullPath)
//
//        // Print out
//        let cell: BRACell = worksheet.cell(forCellReference: "A1")
//        let string: String = cell.stringValue()
//        print(string)
//    }
}
