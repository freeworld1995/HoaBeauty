import UIKit

class ExaminationTableView: UITableView, clickButtons {
    
    // Update given mark to correspondibng subject
    func sendButton1(txtButton1: Int) {
        updatePoint(point: Double(txtButton1))
    }
    
    func sendButton2(txtButton2: Int) {
        updatePoint(point: Double(txtButton2))
    }
    
    func sendButton3(txtButton3: Int) {
        updatePoint(point: Double(txtButton3))
    }
    
    func sendButton4(txtButton4: Int) {
        updatePoint(point: Double(txtButton4))
    }
    
    func sendButton5(txtButton5: Int) {
        updatePoint(point: Double(txtButton5))
    }
    
    func sendButton6(txtButton6: Int) {
        updatePoint(point: Double(txtButton6))
    }
    
    func sendButton7(txtButton7: Int) {
        updatePoint(point: Double(txtButton7))
    }
    
    func sendButton8(txtButton8: Int) {
        updatePoint(point: Double(txtButton8))
    }
    
    func sendButton9(txtButton9: Int) {
        updatePoint(point: Double(txtButton9))
    }
    
    func sendButton10(txtButton10: Int) {
        updatePoint(point: Double(txtButton10))
    }
    
    var factors: CheckList!
    var activeList: [Int] = []
    var currentFactorIndex: Int?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initComponents() {
        register(ExaminationCell.nib(), forCellReuseIdentifier: ExaminationCell.nibName())
        delegate = self
        dataSource = self
    }
    
    func setupData(_ factors: CheckList) {
        self.factors = factors
        for i in 0..<(self.factors?.point.count)! {
            self.factors?.updatePoint(index: i, point: 0)
        }
        loadActiveList()
        reloadData()
    }
    
    func updatePoint(point: Double) {
        self.factors?.updatePoint(index: currentFactorIndex!, point: point)
        reloadData()
    }
    
    func plusPoint(max: Double) {
        self.factors?.plusPoint(index: currentFactorIndex!, max: max)
        reloadData()
    }
    
    func loadActiveList() {
        let account = UserDefaults.standard.object(forKey: Keys.ACCOUNT) as? String
        let examName = UserDefaults.standard.object(forKey: Keys.EXAMINATION_NAME) as? String
        let examType = UserDefaults.standard.object(forKey: Keys.EXAMINATION_TYPE) as? String
        let index = AccountData.getExamIndex(exam: examName!, type: examType!)
        activeList = AccountData.getListActiveFactor(account: account!, exam: index)
    }
}

extension ExaminationTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (factors?.marks.count)!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 10))
        view.backgroundColor = UIColor.clear
        return view
    }
    
//    tabel
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExaminationCell.nibName()) as! ExaminationCell
        cell.setupCell(with: (factors?.marks[indexPath.section])!, point: (Double)((factors?.point[indexPath.section])!))
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.layer.borderWidth = 20
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.clipsToBounds = true
        if !activeList.contains(indexPath.section) {
            cell.isUserInteractionEnabled = false
            cell.content.alpha = 0.3
        } else {
            cell.isUserInteractionEnabled = true
            cell.content.alpha = 1.0
        }
        
        let vc = tableView.window?.rootViewController as! UINavigationController
        cell.onBtnClick = {
            let factorName = cell.factorName.text!
            self.currentFactorIndex = self.factors?.marks.index(of: factorName)
            let popup = StoryBoardManager.instancePopupGiveMark()
            popup.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            popup.modalTransitionStyle = .coverVertical
            popup.navigationController?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            popup.delegateButton = self
            let strFactors = self.factors?.marks[indexPath.section]
            popup.strCurrentFactors = strFactors!
            vc.present(popup, animated: true)
        }
        
        cell.onBtnPlus = {
            let nameEx = UserDefaults.standard.object(forKey: Keys.EXAMINATION_NAME) as? String
            let factorName = cell.factorName.text!
            self.currentFactorIndex = self.factors?.marks.index(of: factorName)
            var max = 10.0
            if factorName == "Lenght" || ((factorName == "Color" || factorName == "Smoothness Of Color" || factorName == "Technique Of Making") && nameEx == "Xăm Môi - Lips Permanent Makeup") {
                max = 5.0
            }
            self.plusPoint(max: max)
        }
        
        return cell
    }
}

extension ExaminationTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (window?.screen.bounds.width)! / 7
    }
}
