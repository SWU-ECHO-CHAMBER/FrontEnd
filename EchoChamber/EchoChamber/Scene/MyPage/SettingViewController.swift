//
//  SettingViewController.swift
//  EchoChamber
//
//  Created by 목정아 on 2023/07/21.
//

import UIKit
import SnapKit
import SwiftUI

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
    
    // MARK: - TableView Style
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70.0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84.0
    }
}

// MARK: - Navigation



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
