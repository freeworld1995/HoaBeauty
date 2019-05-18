//
//  EditPointCell.swift
//  FCA
//

import UIKit

class EditPointCell: UITableViewCell {

    @IBOutlet weak var labelExams: UILabel!
    @IBOutlet weak var labelPoint: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(examName: String, point: Double) {
        labelExams.font = UIFont(name: "Avenir", size: 22)
        labelPoint.font = UIFont(name: "Avenir", size: 22)
        labelExams.text = examName
        labelPoint.text = point.description
    }

}
