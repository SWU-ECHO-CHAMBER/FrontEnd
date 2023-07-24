//
//  SpacingView.swift
//  EchoChamber
//
//  Created by 목정아 on 2023/07/24.
//

import UIKit

class SpacingView : UIView {
    
    init(width: CGFloat, height: CGFloat) {
        super.init(frame: .zero)
        commonInit(width: width, height: height)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit(width: 24.0, height: 0.0) // default
    }
    
    private func commonInit(width: CGFloat, height: CGFloat) {
        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
}
