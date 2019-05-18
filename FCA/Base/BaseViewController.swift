//
//  BaseViewController.swift
//  FCA
//

import UIKit

class BaseViewController: UIViewController, clickBack {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func createBackButtonWithTitle(title: String) {
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        self.navigationItem.setHidesBackButton(true, animated: true)
        // Left button
        let leftButtonFrame: CGRect = CGRect(x: 0, y: -30, width: Constants.ItemNavigationHeight, height: Constants.ItemNavigationHeight)
        let backButton: UIButton = UIButton(frame: leftButtonFrame).then {
            $0.setImage(#imageLiteral(resourceName: "button_back"), for: .normal)
            $0.addTarget(self, action: #selector(buttonBackAction(_:)), for: .touchUpInside)
        }
        // Left title behide button
        let leftTitleFrame: CGRect = CGRect(x: Constants.ItemNavigationHeight,
                                            y: 0,
                                            width: screenWidth - Constants.ItemNavigationHeight - Constants.ItemNavigationHeight,
                                            height: Constants.ItemNavigationHeight)
        let leftTitleLabel: UILabel = createTitleLabel(title: title, frame: leftTitleFrame)
        
        // Left View
        let topPaddingSafeArea: CGFloat = UIView.safeAreaTopPadding()
        let leftBarFrame: CGRect = CGRect(x: 0,
                                          y: topPaddingSafeArea + Constants.ItemNavigationPaddingTop,
                                          width: screenWidth,
                                          height: Constants.ItemNavigationHeight)
        let leftBarView: UIView = UIView(frame: leftBarFrame).then {
            $0.backgroundColor = .clear
            $0.addSubview(backButton)
            $0.addSubview(leftTitleLabel)
            $0.tag = Constants.ItemNavigationTag
        }
        
        emptyLeftItem()
        navigationController?.view.addSubview(leftBarView)
    }
    
    @objc func buttonBackAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func emptyLeftItem() {
        navigationController?.view.subviews.filter{$0.tag == Constants.ItemNavigationTag}.forEach{$0.removeFromSuperview()}
    }
    
    func createTitleLabel(title: String, frame: CGRect) -> UILabel {
        let titleLabel: UILabel = UILabel(frame: frame).then {
            $0.backgroundColor = .clear
            $0.textAlignment = .center
            $0.textColor = .white
            $0.text = title
            $0.font = .systemFont(ofSize: 26)
            $0.adjustsFontSizeToFitWidth = true
        }
        
        return titleLabel
    }
    
    func popupTypeExams(btn1: String, btn2: String) {
        let popupTypeExVC = StoryBoardManager.instancePopupTypeExams()
        popupTypeExVC.button1 = btn1
        popupTypeExVC.button2 = btn2
        popupTypeExVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        popupTypeExVC.modalTransitionStyle = .flipHorizontal
        popupTypeExVC.navigationController?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(popupTypeExVC, animated: true, completion: nil)
    }
    
    func popupPoint(nameGV: String, nameSV: String, totalPoint: String) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Popup", bundle: nil)
        let popupPoint = storyBoard.instantiateViewController(withIdentifier: "PopupPointViewController") as! PopupPointViewController
//        popupPoint.nameSV = nameSV
        popupPoint.backDelegate = self as! clickBack
        popupPoint.nameGV = nameGV
        popupPoint.nameSV = nameSV
        popupPoint.toltalPoint = totalPoint
        popupPoint.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        popupPoint.modalTransitionStyle = .flipHorizontal
        popupPoint.navigationController?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(popupPoint, animated: true, completion: nil)
    }
    
    func back() {
        for vc in (self.navigationController?.viewControllers ?? []) {
            if vc is QualifierHomeView {
                _ = self.navigationController?.popToViewController(vc, animated: true)
                break
            }
        }
    }
    
    var activityViews: UIActivityIndicatorView!
    var subView: UIView!
    
    func createIndicator(color: UIActivityIndicatorViewStyle) {
        
        subView = UIView(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        subView.backgroundColor = UIColor.clear
        self.view.addSubview(subView)
        
        activityViews = UIActivityIndicatorView(activityIndicatorStyle: color)
        activityViews.center = self.view.center
        activityViews.startAnimating()
        self.view.addSubview(activityViews)
    }
    
    func removeIndicator() {
        DispatchQueue.main.async {
            if self.subView != nil {
                self.subView.removeFromSuperview()
                self.activityViews.removeFromSuperview()
            }
        }
    }
    
    // Check Network
    func checkNetWork() -> Bool {
        if !CommonUtils.internetConnected() {
            let disConnectVC = StoryBoardManager.instancePopupDisconnectWifi()
            disConnectVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            disConnectVC.modalTransitionStyle = .flipHorizontal
            disConnectVC.navigationController?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.present(disConnectVC, animated: true, completion: nil)
            return false
        }
        return true
    }
}
