//
//  SettingViewController.swift
//  EchoChamber
//
//  Created by 목정아 on 2023/07/21.
//

import UIKit
import SnapKit
import SwiftUI
import Alamofire

class SettingViewController : UITableViewController {
    
    let accountSettings = ["Change ID", "Change Password", "Withdrawal"]
    let notificationSettings = ["Notification"]
    
    let cellTitle = ["Change ID", "Change Password", "Withdrawal", "Notification"]
    let iconImage = ["person", "lock", "rectangle.portrait.and.arrow.forward", "bell"]
    
    var sections: [[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sections = [accountSettings, notificationSettings]
        
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Account"
        } else if section == 1 {
            return "Notification"
        }
        return nil
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as? SettingTableViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        
        if indexPath.section == 0 {
            cell.titleLabel.text = cellTitle[indexPath.item]
            cell.customImageView.image = UIImage(systemName: iconImage[indexPath.item])
        } else if indexPath.section == 1 {
            cell.titleLabel.text = cellTitle[indexPath.item + sections[0].count]
            cell.customImageView.image = UIImage(systemName: iconImage[indexPath.item + sections[0].count])
        }
        
        if indexPath.row == 0 && indexPath.section == 1{
            cell.accessoryView = cell.toggleSwitch
        } else {
            cell.accessoryType = .disclosureIndicator
        }
        
        cell.setup()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 1 {
            let newViewController = ChangePasswordViewController()
            navigationController?.pushViewController(newViewController, animated: true)
        }
        
        if indexPath.section == 0 && indexPath.row == 2 {
            self.withdrawalServer()
        }
        
    }

    
    // MARK: - TableView Style
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70.0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84.0
    }
}

// MARK: - Navigation


// MARK: - method

private extension SettingViewController {
    
    func withdrawalServer() {
        let url = LoginUrlCategory().LEAVE_URL
        let accessToken = UserDefaults.standard.string(forKey: "AccessToken")
        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken ?? "")"]

        AF.request(url, method: .post, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    self.withdrawalAction()
                case .failure(let error):
                    self.errorAlert(message: error.localizedDescription)
                }
            }
    }
    
    func errorAlert(message : String) {
        let actionSheet = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        [
            UIAlertAction(title: "Close", style: .cancel) { _ in
            }
        ].forEach {
            actionSheet.addAction($0)
        }
        present(actionSheet, animated: true)
    }
    
    func withdrawalAction() {
        let alertController = UIAlertController(title: "❗️Alert❗️", message: "Are you sure you want to drop out?", preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            let newViewController = LoginViewcontroller()
            let navigationController = UINavigationController(rootViewController: newViewController)
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
        }

        let cancelAction = UIAlertAction(title: "No", style: .cancel) { _ in
            
        }

        alertController.addAction(okAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }


}


// MARK: - PreviewProvider

struct SettingViewController_Previews: PreviewProvider {
    static var previews: some View {
        Container().edgesIgnoringSafeArea(.all)
    }
    
    struct Container: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            let homeViewController = SettingViewController()
            return UINavigationController(rootViewController: homeViewController)
        }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
        typealias UIViewControllerType = UIViewController
    }
}
