//
//  UIView+SafeArea.swift
//  FCA
//

import UIKit

extension UIView {
    static func safeAreaTopPadding() -> CGFloat{
        var padding:CGFloat = 0
        let statusBarSize:CGSize = UIApplication.shared.statusBarFrame.size
        let paddingStatusBar: CGFloat = min(statusBarSize.width, statusBarSize.height)
        
        if #available(iOS 11, *) {
            let window: UIWindow? = UIApplication.shared.keyWindow
            padding = window?.safeAreaInsets.top ?? 0
        } else {
            padding = paddingStatusBar
        }
        
        if padding <= 0 {
            // If can not get safe area
            padding = paddingStatusBar
        }
        return padding;
    }
}
