//
//  SettingTableViewCell.swift
//  EchoChamber
//
//  Created by 목정아 on 2023/07/21.
//

import UIKit
import SnapKit

class SettingTableViewCell : UITableViewCell {
    
    static let identifier = "SettingTableViewCell"
    
    lazy var customImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(systemName: "person")
        imageView.tintColor = .textColor
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.heightAnchor.constraint(equalToConstant: 24.0).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 24.0).isActive = true
        
        return imageView
    }()
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Changed ID"
        label.font = .systemFont(ofSize: 16.0, weight: .regular)
        
        return label
    }()
    
    lazy var toggleSwitch: UISwitch = {
        let toggleSwitch = UISwitch()
        toggleSwitch.onTintColor = .mainColor
        
        return toggleSwitch
    }()
    
    func setup() {
        backgroundColor = .white
        self.setupLayout()
    }
    
}

private extension SettingTableViewCell {
    func setupLayout() {
        [
            customImageView,
            titleLabel,
        ].forEach { addSubview($0) }
        
        customImageView.snp.makeConstraints {
            $0.centerY.equalTo(safeAreaLayoutGuide)
            $0.leading.equalToSuperview().inset(24.0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(customImageView.snp.trailing).offset(33.0)
            $0.centerY.equalTo(customImageView)
        }
        
    }
    
}
