//
//  GiveMarkViewController.swift
//  FCA
//

import UIKit

protocol clickButtons {
    func sendButton1(txtButton1: Int)
    func sendButton2(txtButton2: Int)
    func sendButton3(txtButton3: Int)
    func sendButton4(txtButton4: Int)
    func sendButton5(txtButton5: Int)
    func sendButton6(txtButton6: Int)
    func sendButton7(txtButton7: Int)
    func sendButton8(txtButton8: Int)
    func sendButton9(txtButton9: Int)
    func sendButton10(txtButton10: Int)
}

class GiveMarkViewController: BaseViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var btn6: UIButton!
    @IBOutlet weak var btn7: UIButton!
    @IBOutlet weak var btn8: UIButton!
    @IBOutlet weak var btn9: UIButton!
    @IBOutlet weak var btn10: UIButton!
    @IBOutlet weak var viewContent: UIView!
    
    var delegateButton: clickButtons?
    var strCurrentFactors: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDefaultUI()
        print(strCurrentFactors)
        checkMark()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Click Button
    
    @IBAction func invokeButton1(_ sender: Any) {
        delegateButton?.sendButton1(txtButton1: 1)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func invokeButton2(_ sender: Any) {
        delegateButton?.sendButton2(txtButton2: 2)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func invokeButton3(_ sender: Any) {
        delegateButton?.sendButton3(txtButton3: 3)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func invokeButton4(_ sender: Any) {
        delegateButton?.sendButton4(txtButton4: 4)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func invokeButton5(_ sender: Any) {
        delegateButton?.sendButton5(txtButton5: 5)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func invokeButton6(_ sender: Any) {
        delegateButton?.sendButton6(txtButton6: 6)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func invokeButton7(_ sender: Any) {
        delegateButton?.sendButton7(txtButton7: 7)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func invokeButton8(_ sender: Any) {
        delegateButton?.sendButton8(txtButton8: 8)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func invokeButton9(_ sender: Any) {
        delegateButton?.sendButton9(txtButton9: 9)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func invokeButton10(_ sender: Any) {
        delegateButton?.sendButton10(txtButton10: 10)
        self.dismiss(animated: true, completion: nil)
    }
    
    // Check Mark
    func checkMark() {
        let nameEx = UserDefaults.standard.object(forKey: Keys.EXAMINATION_NAME) as? String
        if strCurrentFactors == "Lenght" {
            btn6.isHidden = true
            btn7.isHidden = true
            btn8.isHidden = true
            btn9.isHidden = true
            btn10.isHidden = true
        } else if strCurrentFactors == "Color" && nameEx == "Xăm Môi - Lips Permanent Makeup" {
            btn6.isHidden = true
            btn7.isHidden = true
            btn8.isHidden = true
            btn9.isHidden = true
            btn10.isHidden = true
        }  else if strCurrentFactors == "Smoothness Of Color" && nameEx == "Xăm Môi - Lips Permanent Makeup" {
            btn6.isHidden = true
            btn7.isHidden = true
            btn8.isHidden = true
            btn9.isHidden = true
            btn10.isHidden = true
        } else if strCurrentFactors == "Technique Of Making" && nameEx == "Xăm Môi - Lips Permanent Makeup" {
            btn6.isHidden = true
            btn7.isHidden = true
            btn8.isHidden = true
            btn9.isHidden = true
            btn10.isHidden = true
        }
    }
    
}

extension GiveMarkViewController {
    func initDefaultUI() {
        viewContent.layer.cornerRadius = 10.0
        
        btn1.layer.borderColor = UIColor.black.cgColor
        btn1.layer.borderWidth = 1
        btn1.layer.cornerRadius = btn1.bounds.size.width / 2
        
        btn2.layer.borderColor = UIColor.black.cgColor
        btn2.layer.borderWidth = 1
        btn2.layer.cornerRadius = btn1.bounds.size.width / 2
        
        btn3.layer.borderColor = UIColor.black.cgColor
        btn3.layer.borderWidth = 1
        btn3.layer.cornerRadius = btn1.bounds.size.width / 2
        
        btn4.layer.borderColor = UIColor.black.cgColor
        btn4.layer.borderWidth = 1
        btn4.layer.cornerRadius = btn1.bounds.size.width / 2
        
        btn5.layer.borderColor = UIColor.black.cgColor
        btn5.layer.borderWidth = 1
        btn5.layer.cornerRadius = btn1.bounds.size.width / 2
        
        btn6.layer.borderColor = UIColor.black.cgColor
        btn6.layer.borderWidth = 1
        btn6.layer.cornerRadius = btn1.bounds.size.width / 2
        
        btn7.layer.borderColor = UIColor.black.cgColor
        btn7.layer.borderWidth = 1
        btn7.layer.cornerRadius = btn1.bounds.size.width / 2
        
        btn8.layer.borderColor = UIColor.black.cgColor
        btn8.layer.borderWidth = 1
        btn8.layer.cornerRadius = btn1.bounds.size.width / 2
        
        btn9.layer.borderColor = UIColor.black.cgColor
        btn9.layer.borderWidth = 1
        btn9.layer.cornerRadius = btn1.bounds.size.width / 2
        
        btn10.layer.borderColor = UIColor.black.cgColor
        btn10.layer.borderWidth = 1
        btn10.layer.cornerRadius = btn1.bounds.size.width / 2
    }
}
