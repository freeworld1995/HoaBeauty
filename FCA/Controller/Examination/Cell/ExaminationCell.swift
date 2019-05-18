import UIKit

class ExaminationCell: UITableViewCell {
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var factorName: UILabel!
    @IBOutlet weak var point: UILabel!
    @IBOutlet weak var plusMark: UIButton!
    
    var onBtnClick : (() -> Void)? = nil
    var onBtnPlus : (() -> Void)? = nil
    
    @IBAction func btnGivePoint(_ sender: Any) {
        if let onClick = self.onBtnClick {
            onClick()
        }
    }
    
    func setupCell(with factor: String, point: Double) {
        self.point.text = String(point)
        self.factorName.text = factor
        self.content.layer.cornerRadius = 10
        self.content.layer.borderWidth = 1
        self.content.layer.borderColor = UIColor.white.cgColor
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //        logoImage.layer.cornerRadius = logoImage.frame.height / 2
        //        logoImage.clipsToBounds = true
        content.layer.cornerRadius = 10
        content.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func invokeButtonPlusMark(_ sender: Any) {
        if let onClick = self.onBtnPlus {
            onClick()
        }
    }
}
