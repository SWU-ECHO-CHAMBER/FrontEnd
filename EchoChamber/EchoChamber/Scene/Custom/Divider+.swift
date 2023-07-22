//
//  Divider+.swift
//  EchoChamber
//
//  Created by 목정아 on 2023/07/21.
//

import UIKit

final class SeparatorView: UIView {
    
    private lazy var separator: UIView = {
        let separator = UIView()
        separator.backgroundColor = .dividerColor
        
        return separator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(separator)
        
        separator.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(11.0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
