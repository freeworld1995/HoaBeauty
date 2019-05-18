//
//  PopupPointViewController.swift
//  FCA
//
import UIKit

protocol clickBack {
    func back()
}

class PopupPointViewController: BaseViewController {

    @IBOutlet weak var labelNameSV: UILabel!
    @IBOutlet weak var labelNameGV: UILabel!
    @IBOutlet weak var labelToltalPonit: UILabel!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var viewContent: UIView!
    
    var nameSV: String = ""
    var nameGV: String = ""
    var toltalPoint: String = ""
    var backDelegate: clickBack?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        customUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getData() {
//        labelNameSV.text = "Họ và tên Sinh Viên: " + nameSV
        labelNameGV.text = "Họ Tên Giám Khảo: " + nameGV
        labelToltalPonit.text = "Tổng Điểm: " + toltalPoint
    }
    
    func customUI() {
        viewContent.layer.cornerRadius = 20
        viewContent.clipsToBounds = true
        buttonCancel.layer.borderWidth = 1.0
        buttonCancel.layer.borderColor =  UIColor.white.cgColor
    }
    
    func clearData() {
        UserDefaults.standard.removeObject(forKey: Keys.CANDIDATE_CODE)
        UserDefaults.standard.removeObject(forKey: Keys.EXAMINATION_NAME)
    }
    
    // MARK: Button Click
    @IBAction func buttonCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            self.backDelegate?.back()
        })
        
    }
    
    
}
