
//
//  EditPointViewController.swift
//  FCA
//

import UIKit

class EditPointViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var applicant: Applicant!
    var currentApplicant: Applicant!
    var selectedIndex: Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currentApplicant = Applicant.init(exam: applicant.exam, factor: applicant.factor, point: applicant.point, id: applicant.id, name: applicant.name, type: applicant.type)
    }
    
    //MARK: - Button Click
    
    @IBAction func invokeButtonBack(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: Keys.UPDATE_OBJECT)
        UserDefaults.standard.removeObject(forKey: Keys.CHECK_UPDATE_POINT)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func invokeButtonSave(_ sender: Any) {
        let alert = UIAlertController(title: "Notification", message: "Save Point Success", preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "OK", style: .default) { (_) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(actionOK)
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension EditPointViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentApplicant.factor.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellPoint", for: indexPath) as! EditPointCell
        cell.setData(examName: currentApplicant.factor[indexPath.row], point: currentApplicant.point[indexPath.row])
        return cell
    }
    
    func updatePoint(point: Double) {
        currentApplicant.updatePoint(index: selectedIndex!, point: point)
        tableView.reloadData()
        // Save data in user default
        UserDefaults.standard.set(currentApplicant.point, forKey: Keys.UPDATE_OBJECT)
        UserDefaults.standard.set(true, forKey: Keys.CHECK_UPDATE_POINT)
    }
}

extension EditPointViewController: UITableViewDelegate, clickButtons {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        let popup = StoryBoardManager.instancePopupGiveMark()
        popup.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        popup.modalTransitionStyle = .coverVertical
        popup.navigationController?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        popup.delegateButton = self
        self.present(popup, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
