//
//  DisconnectWifiViewController.swift
//  FCA
//

import UIKit

class DisconnectWifiViewController: BaseViewController {

    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var btnDone: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }

    @IBAction func invokeButtonDone(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupUI() {
        viewContent.layer.cornerRadius = 20
        viewContent.clipsToBounds = true
        btnDone.layer.borderWidth = 1.0
        btnDone.layer.borderColor =  UIColor.white.cgColor
    }
}
