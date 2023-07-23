//
//  RegisterViewController.swift
//  EchoChamber
//
//  Created by 목정아 on 2023/07/23.
//

import UIKit
import SwiftUI
import SnapKit

class RegisterViewController : UIViewController {
    
    private lazy var userProfileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "MyProfile")
        imageView.widthAnchor.constraint(equalToConstant: 99.0).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 99.0).isActive = true
        
        return imageView
    }()
    
    private lazy var cameraButton: UIButton = {
        let button = UIButton()
        
        if let originalImage = UIImage(named: "Camera") {
            let targetWidth: CGFloat = 36
            let targetHeight: CGFloat = 36
            
            let resizedImage = originalImage.resize(to: CGSize(width: targetWidth, height: targetHeight))
            button.setImage(resizedImage, for: .normal)
        }
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()
    }
    
}

private extension RegisterViewController {
    func setupLayout() {
        [
            userProfileImageView,
            cameraButton,
        ].forEach { view.addSubview($0) }
        
        userProfileImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(44.0)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        cameraButton.snp.makeConstraints {
            $0.bottom.equalTo(userProfileImageView.snp.bottom).offset(5.0)
            $0.centerX.equalTo(userProfileImageView.snp.centerX).offset(40.0)
        }
    }
}

// MARK: - PreviewProvider

struct RegisterViewController_Previews: PreviewProvider {
  static var previews: some View {
    Container().edgesIgnoringSafeArea(.all)
  }
  
  struct Container: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
      let homeViewController = RegisterViewController()
      return UINavigationController(rootViewController: homeViewController)
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    typealias UIViewControllerType = UIViewController
  }
}
