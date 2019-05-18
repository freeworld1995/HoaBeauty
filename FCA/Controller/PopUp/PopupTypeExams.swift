//
//  PopupTypeExams.swift
//  FCA
//
//  Created by Minh Công on 9/18/18.
//  Copyright © 2018 minhcong. All rights reserved.
//

import UIKit

protocol showString {
    func btn1(index: Int, indexPathEx: CheckList)
//    func btn2(index: Int, indexPathEx: CheckList)
}

class PopupTypeExams: UIViewController {

    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var viewContent: UIView!
    
    var button1: String = ""
    var button2: String = ""
    var delegateStr: showString?
    var indexPathEx: CheckList!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btn1.setTitle(button1, for: .normal)
        btn2.setTitle(button2, for: .normal)
        btn1.alpha = 0.5
        btn2.alpha = 0.5
        btn1.layer.borderWidth = 1.0
        btn2.layer.borderWidth = 1.0
        btn1.layer.borderColor = UIColor.white.cgColor
        btn2.layer.borderColor = UIColor.white.cgColor
        btn1.isUserInteractionEnabled = false
        btn2.isUserInteractionEnabled = false
        viewContent.layer.cornerRadius = 20.0
        updateButtonStatus()
    }
    
    func updateButtonStatus() {
        let account = UserDefaults.standard.object(forKey: Keys.ACCOUNT) as? String
        let examName = UserDefaults.standard.object(forKey: Keys.EXAMINATION_NAME) as? String
        let checkList = AccountData.checkListExams(exam: examName!, account: account!)
        if checkList.contains(button1) {
            btn1.isUserInteractionEnabled = true
            btn1.alpha = 1.0
        }
        if checkList.contains(button2.replacingOccurrences(of: " ", with: "")) {
            btn2.isUserInteractionEnabled = true
            btn2.alpha = 1.0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Button Click
    
    @IBAction func invokeButton1(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            switch self.button1{
            case "Expert":
                self.delegateStr?.btn1(index: 1, indexPathEx: self.indexPathEx)
                break
            case "Human":
                self.delegateStr?.btn1(index: 3, indexPathEx: self.indexPathEx)
                break
            default:
                break
            }
        })
    }
    
    @IBAction func invokeButton2(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            switch self.button2{
            case "Master":
                self.delegateStr?.btn1(index: 2, indexPathEx: self.indexPathEx)
                break
            case "3D Skin":
                self.delegateStr?.btn1(index: 4, indexPathEx: self.indexPathEx)
                break
            default:
                break
            }
        })
    }
    
}
