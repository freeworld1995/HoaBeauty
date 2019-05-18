import UIKit

class ExamCell: UITableViewCell {
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var examName: UILabel!
    @IBOutlet weak var information: UILabel!
    
    var onBtnClick : (() -> Void)? = nil

    @IBAction func btnChooseExam(_ sender: Any) {
        if let onClick = self.onBtnClick {
            onClick()
        }
    }
    
    func setupCell(with exam: CheckList) {
        self.examName.text = exam.exams
        self.logoImage.image = UIImage(named: exam.image)
        self.content.layer.cornerRadius = 5
        self.content.layer.borderWidth = 1
        self.content.layer.borderColor = UIColor.white.cgColor
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        logoImage.layer.cornerRadius = logoImage.frame.height / 2
//        logoImage.clipsToBounds = true
        
        content.layer.cornerRadius = 5
        content.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
