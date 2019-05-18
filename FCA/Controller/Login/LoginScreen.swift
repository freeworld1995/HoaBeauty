//
//  LoginScreen.swift
//  FCA
//
//  Created by 1 on 8/8/18.
//  Copyright © 2018 FCA2018. All rights reserved.
//

import UIKit

class LoginView: BaseViewController
{
    
    @IBOutlet weak var tfId: UITextField!
    @IBOutlet weak var tfPass: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    var accountList: [Account] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DatabaseService.instance.GetAllUser(completion: { result in
            switch result {
            case .success(let accounts):
                self.accountList = accounts
            case .failure(_): break
                // Show get user error alert
            }
        })
        addDismissTapGesture()
        setupTextAttributes()
//        loadAccountData()
//        initDemoData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        resetData()
    }
    
    // MARK: Private functions
    
    private func addDismissTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
    }
    
    private func setupTextAttributes() {
        tfId.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray])
        tfPass.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray])
        btnLogin.layer.borderWidth = 1
        btnLogin.layer.borderColor = UIColor.black.cgColor
    }
    
    func testUpdateImage () {
        let img = UIImage.init(named: "")
        if ManagerGoogleDrive.shared.isAuthorized() {
            ManagerGoogleDrive.shared.uploadFileToFolder(image: img!, fileName: "anh1") { (status) in
                NSLog("Success");
            }
        }else {
            ManagerGoogleDrive.shared.authorize(in: self) { (status) in
                if (status) {
                    ManagerGoogleDrive.shared.uploadImage(image: img!, fileName: "anh2") { (status) in
                        NSLog("Fail");
                    }
                }
            }
        }
    }
    
    @IBAction func invokeButtonLogin(_ sender: Any) {
        let id = tfId.text
        let pass = tfPass.text
        let account = checkAccountValid(id: id!, pass: pass!)
        switch account.type {
        case "":
            // Login fail
            break;
        case Keys.ADMIN:
            // Login as admin
            UserDefaults.standard.set(account.account, forKey: Keys.ACCOUNT)
            let adminVC = StoryBoardManager.instanceAdminHomeViewController()
            self.navigationController?.pushViewController(adminVC, animated: true)
            break;
        case Keys.QUALIFIER:
            // Login as qualifier
            UserDefaults.standard.set(account.account, forKey: Keys.ACCOUNT)
            UserDefaults.standard.set(account.password, forKey: Keys.PASSWORD)
            UserDefaults.standard.set(account.type, forKey: Keys.TYPE)
            let qualifierVC = StoryBoardManager.instanceQualifierHomeViewController()
            self.navigationController?.pushViewController(qualifierVC, animated: true)
            break;
        default:
            break;
        }
    }
    
}

extension LoginView
{
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func resetData() {
        UserDefaults.standard.removeObject(forKey: Keys.CANDIDATE_CODE)
        UserDefaults.standard.removeObject(forKey: Keys.CHECK_QRCODE)
        
    }
    
    func initDemoData() {
//        self.tfId.text = "qualifier101"
//        self.tfPass.text = "hoabeautylashes"
        self.tfId.text = "admin1"
        self.tfPass.text = "admin"
//        self.tfId.text = "qualifier015"
//        self.tfPass.text = "123456"
    }
    
    func loadListAccount() {
        // Load user account here
        accountList = UserDefaults.standard.object(forKey: Keys.ACCOUNT_LIST) as! [Account]
    }
    
    func checkAccountValid(id: String, pass: String) -> Account {
        var loginAccount = Account(account: id, password: pass, type: "");
        
        for account in accountList {
            if account.account == id && account.password == pass {
                loginAccount.type = account.type
            }
        }
        return loginAccount
    }
    
    func loadAccountData() {
        for account in AccountData.account {
            let newAccount = Account.init(account: account[0] as String, password: account[1] as String, type: account[2] as String)
            accountList.append(newAccount)
        }
    }
}
