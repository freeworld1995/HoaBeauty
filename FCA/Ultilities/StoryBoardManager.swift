//
//  StoryBoardManager.swift
//  FCA
//
//  Created by 1 on 8/6/18.
//  Copyright © 2018 FCA2018. All rights reserved.
//

import UIKit

class StoryBoardManager: NSObject {
    // MARK: - List Storyboard
    static let SplashStoryBoard: String = "Splash"
    static let LoginStoryBoard: String = "Login"
    static let AdminHomeStoryBoard: String = "AdminHome"
    static let QualifierHomeStoryBoard: String = "QualifierHome"
    static let GiveMarkStoryBoard: String = "GiveMarkPopup"
    static let CameraStoryBoard: String = "Camera"
    static let PopupTypeExamsBoard: String = "Popup"
    
    // MARK: - List View
    static let SplashView: String = "SplashViewController"
    static let LoginView: String = "LoginViewController"
    static let QualifierView: String = "QualifierHomeViewController"
    static let ExaminationView: String = "ExaminationViewController"
    static let DesktopQualifierIdenty: String = "DesktopQualifierViewController"
    static let PopupGiveMarkView: String = "GiveMarkViewController"
    static let AdminHomveView: String = "AdminViewController"
    static let CameraView: String = "CameraViewController"
    static let EditPointIdenty: String = "EditPointViewController"
    static let PopupTypeExamsIdenty: String = "PopupTypeExams"
    static let PopupDisconnectWifiIdenty: String = "DisconnectWifiViewController"

    // MARK: - Instance ViewController in Login Storyboard
    static func instanceLoginViewController() -> LoginView {
        let storyBoard = UIStoryboard(name: LoginStoryBoard, bundle: nil)
        let loginVC = storyBoard.instantiateViewController(withIdentifier: LoginView) as! LoginView
        return loginVC
    }
    
    // MARK: - Instance ViewController in Qualifier home Storyboard
    static func instanceQualifierHomeViewController() -> QualifierHomeView {
        let storyBoard = UIStoryboard(name: QualifierHomeStoryBoard, bundle: nil)
        let qualifierVC = storyBoard.instantiateViewController(withIdentifier: QualifierView) as! QualifierHomeView
        return qualifierVC
    }
    
    static func instanceDesktopQualifierViewController() -> DesktopQualifierViewController {
        let storyBoard = UIStoryboard(name: LoginStoryBoard, bundle: nil)
        let desktopVC = storyBoard.instantiateViewController(withIdentifier: DesktopQualifierIdenty) as! DesktopQualifierViewController
        return desktopVC
    }
    
    static func instanceExaminationViewController() -> ExaminationView {
        let storyBoard = UIStoryboard(name: QualifierHomeStoryBoard, bundle: nil)
        let examinationVC = storyBoard.instantiateViewController(withIdentifier: ExaminationView) as! ExaminationView
        return examinationVC
    }
    
    static func instancePopupGiveMark() -> GiveMarkViewController {
        let storyBoard = UIStoryboard(name: GiveMarkStoryBoard, bundle: nil)
        let popup = storyBoard.instantiateViewController(withIdentifier: PopupGiveMarkView) as! GiveMarkViewController
        return popup
    }
    
    static func instanceAdminHomeViewController() -> AdminViewController {
        let storyboard = UIStoryboard(name: AdminHomeStoryBoard, bundle: nil)
        let adminVC = storyboard.instantiateViewController(withIdentifier: AdminHomveView) as! AdminViewController
        return adminVC
    }
    
    static func instanceCameraViewController() -> CameraViewController {
        let storyboard = UIStoryboard(name: CameraStoryBoard, bundle: nil)
        let cameraVC = storyboard.instantiateViewController(withIdentifier: CameraView) as! CameraViewController
        return cameraVC
    }
    
    static func instanceEditPointViewController() -> EditPointViewController {
        let storyboard = UIStoryboard(name: AdminHomeStoryBoard, bundle: nil)
        let editVC = storyboard.instantiateViewController(withIdentifier: EditPointIdenty) as! EditPointViewController
        return editVC
    }
    
    static func instancePopupTypeExams() -> PopupTypeExams {
        let storyboard = UIStoryboard(name: PopupTypeExamsBoard, bundle: nil)
        let popupTypeVC = storyboard.instantiateViewController(withIdentifier: PopupTypeExamsIdenty) as! PopupTypeExams
        return popupTypeVC
    }
    
    static func instancePopupDisconnectWifi() -> DisconnectWifiViewController {
        let storyboard = UIStoryboard(name: PopupTypeExamsBoard, bundle: nil)
        let popupdisconnect = storyboard.instantiateViewController(withIdentifier: PopupDisconnectWifiIdenty) as! DisconnectWifiViewController
        return popupdisconnect
    }
}
