import UIKit

protocol clickButton {
    func sendButton(txtButton1: String)
}

class PopupViewController: BaseViewController {
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
    @IBOutlet weak var contentView: UIView!
    
    var delegateButton: clickButton?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDefaultUI()
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.cornerRadius = 5
    }
    
//    @IBAction func btnGivePoint(_ sender: UIButton) {
//        if let buttonTitle = sender.title(for: .normal) {
//            print(buttonvitle)
////            var listPoint = UserDefaults.standard.object(forKey: Keys.POINT_LIST) as! [Int]
////            let current = UserDefaults.standard.object(forKey: Keys.CURRENT_FACTOR) as! Int
////            listPoint[current] = Int(buttonTitle)!
////            UserDefaults.standard.set(listPoint, forKey: Keys.POINT_LIST)
//            self.dismiss(animated: true, completion: {})
////            self.navigationController?.popViewController(animated: true)
//        }
//    }
    
    // MARK: - Click Button
    
}

extension PopupViewController
{
    func initDefaultUI() {
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
