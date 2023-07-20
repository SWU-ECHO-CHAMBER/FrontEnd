//
//  MyPageViewController.swift
//  EchoChamber
//
//  Created by 목정아 on 2023/07/20.
//

import UIKit

class MyPageViewController : UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        self.setupNavigationController()
    }
}

// MARK: - Navigation

private extension MyPageViewController {
    func setupNavigationController() {
        
        let leftFixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        leftFixedSpace.width = 36.0
        
        let rightFixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        rightFixedSpace.width = 20.0
        
        if let originalImage = UIImage(named: "Logo") {
            
            let imageSize = CGSize(width: 89, height: 39)
            let resizedImage = originalImage.resize(to: imageSize)
            
            let imageView = UIImageView(image: resizedImage)
            imageView.frame = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
        
            let logoButton = UIBarButtonItem(customView: imageView)
            
            navigationItem.leftBarButtonItems = [leftFixedSpace, logoButton]
        }
        
        let logoutButton = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .plain, target: self, action: nil)
        
        let settingButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(didTapStettingButton))
        
        navigationItem.rightBarButtonItems = [rightFixedSpace, settingButton, logoutButton]
    }
    
}

// MARK: - @objc

private extension MyPageViewController {
    
    @objc func didTapLogoutButton() {
        print("Logout")
    }
    
    @objc func didTapStettingButton() {
        print("Setting")
    }

}
