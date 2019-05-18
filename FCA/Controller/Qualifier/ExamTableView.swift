import UIKit

class ExamTableView: UITableView, showString {
    func btn1(index: Int, indexPathEx: CheckList) {
        let vc = self.window?.rootViewController as! UINavigationController
        UserDefaults.standard.set(index.description, forKey: Keys.EXAMINATION_TYPE)
        let examinationVC = StoryBoardManager.instanceExaminationViewController()
        examinationVC.indexPathEx = indexPathEx
        vc.pushViewController(examinationVC, animated: true)
    }
    
    var examinations: [CheckList] = []
    var activeExamination: [Int] = []
    var marks: [Any] = [Any]()
    var candidateCode: String = ""
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initComponents() {
        register(ExamCell.nib(), forCellReuseIdentifier: ExamCell.nibName())
        delegate = self
        dataSource = self
    }
    
    func setupData(_ examinations: [CheckList],_ activeList: [Int]) {
        self.examinations = examinations
        self.activeExamination = activeList
        reloadData()
    }
    
    func setupMark(_ mark: [Any]) {
        self.marks = mark
        reloadData()
    }
}

extension ExamTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return examinations.count
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 10))
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExamCell.nibName()) as! ExamCell
        let exam: CheckList = examinations[indexPath.section]
        cell.setupCell(with: exam)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.layer.borderWidth = 20
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 10
        if (!self.activeExamination.contains(indexPath.section)) {
            cell.isUserInteractionEnabled = false
            cell.content.alpha = 0.5
        } else {
            cell.isUserInteractionEnabled = true
            cell.content.alpha = 1
        }
        
        let vc = tableView.window?.rootViewController as! UINavigationController
        cell.onBtnClick = {
            let checkQRCode = UserDefaults.standard.object(forKey: Keys.CANDIDATE_CODE) as? String
            if checkQRCode == nil {
                let alert = UIAlertController(title: "Notification", message: "Please Check QRCode.", preferredStyle: .alert)
                let actionOK = UIAlertAction(title: "OK", style: .destructive, handler: { (_) in
                    vc.dismiss(animated: true, completion: nil)
                })
                alert.addAction(actionOK)
                vc.present(alert, animated: true, completion: nil)
            } else {
                if self.checkApplicantExist(examName: cell.examName.text!) {
                    let alert = UIAlertController(title: "Notification", message: "You checked this applicant, please try other!", preferredStyle: .alert)
                    let actionOK = UIAlertAction(title: "OK", style: .destructive, handler: { (_) in
                        vc.dismiss(animated: true, completion: nil)
                    })
                    alert.addAction(actionOK)
                    vc.present(alert, animated: true, completion: nil)
                } else {
                    UserDefaults.standard.set(cell.examName.text, forKey: Keys.EXAMINATION_NAME)
                    let indexPathMarks = exam
                    let popup = StoryBoardManager.instancePopupTypeExams()
                    popup.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    popup.modalTransitionStyle = .coverVertical
                    popup.navigationController?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    popup.delegateStr = self
                    popup.indexPathEx = indexPathMarks
                    popup.button1 = AccountData.getExamTypes(exam: indexPathMarks.exams).first!
                    popup.button2 = AccountData.getExamTypes(exam: indexPathMarks.exams).last!
                    vc.present(popup, animated: true)
                }
            }
        }
        return cell
    }
}

extension ExamTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (window?.screen.bounds.width)! / 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row)
//        let vc1 = tableView.window?.rootViewController as! UINavigationController
//        let vc = examinations[indexPath.row]
//        let examinationVC = StoryBoardManager.instanceExaminationViewController()
//        vc1.pushViewController(examinationVC, animated: true)
    }
}

extension ExamTableView {
    func checkApplicantExist(examName: String) -> Bool {
        var result = false
        let account = UserDefaults.standard.object(forKey: Keys.ACCOUNT) as! String
        let name = UserDefaults.standard.object(forKey: Keys.CANDIDATE_CODE) as! String
        let phone = UserDefaults.standard.object(forKey: Keys.CANDIDATE_PHONE) as! String
        let check = "\(name) - \(phone) - \(account) - \(examName)"
        guard UserDefaults.standard.object(forKey: Keys.CANDIDATE_CHECKED) != nil else {
            return false
        }
        let checkedList = UserDefaults.standard.object(forKey: Keys.CANDIDATE_CHECKED) as! [String]
        if checkedList.contains(check) {
            result = true
        }
        return result
    }
}
