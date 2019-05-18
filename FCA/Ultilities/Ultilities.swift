import UIKit

extension UIView {
    static func nib() -> UINib {
        return UINib(nibName: nibName(), bundle: nil)
    }
    
    static func nibName() -> String {
        return String(describing: self)
    }
    
    static func fromNib() -> UIView {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)![0] as! UIView
    }
}
