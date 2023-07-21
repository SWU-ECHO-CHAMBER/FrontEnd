//
//  EditProfileViewController.swift
//  EchoChamber
//
//  Created by 목정아 on 2023/07/21.
//

import UIKit
import SnapKit
import SwiftUI

class EditProfileViewController : UIViewController {
    
    let inset : CGFloat = Inset.inset
    
    private lazy var userProfileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "MyProfile")
        imageView.widthAnchor.constraint(equalToConstant: 142).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 142).isActive = true
        
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
    
    private lazy var usernameTextView : UITextView = {
        let textView = UITextView()
        textView.text = "user name"
        textView.textColor = #colorLiteral(red: 0.2352941176, green: 0.2352941176, blue: 0.2352941176, alpha: 1)
        textView.font = .systemFont(ofSize: 16.0, weight: .regular)
        
        return textView
    }()
    
    private lazy var textNumberLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13.0, weight: .regular)
        label.textColor = #colorLiteral(red: 0.2352941176, green: 0.2352941176, blue: 0.2352941176, alpha: 1)
        label.text = "9 / 20"
        
        return label
    }()
    
    private lazy var textLineStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 18.0
        [
            usernameTextView,
            textNumberLabel
        ].forEach { stackView.addArrangedSubview($0) }
        
        return stackView
    }()
    
    private lazy var dividerView : UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.7910822034, green: 0.7910822034, blue: 0.7910822034, alpha: 1)
        view.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        
        return view
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("DONE", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20.0, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .mainColor
        button.layer.cornerRadius = 9.0
        button.heightAnchor.constraint(equalToConstant: 54.0).isActive = true
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLayout()
    }
    
}

private extension EditProfileViewController {
    func setupLayout() {
        [
            userProfileImageView,
            cameraButton,
            textLineStackView,
            dividerView,
            doneButton,
        ].forEach { view.addSubview($0) }
        
        userProfileImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(158.0)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        cameraButton.snp.makeConstraints {
            $0.bottom.equalTo(userProfileImageView.snp.bottom).offset(5.0)
            $0.centerX.equalTo(userProfileImageView.snp.centerX).offset(40.0)
        }
        
        textLineStackView.snp.makeConstraints {
            $0.top.equalTo(userProfileImageView.snp.bottom).offset(81.0)
            $0.leading.equalToSuperview().inset(49.0)
            $0.trailing.equalToSuperview().inset(49.0)
            $0.height.equalTo(30.0)
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(textLineStackView.snp.bottom).offset(10.0)
            $0.leading.equalToSuperview().inset(40.0)
            $0.trailing.equalToSuperview().inset(40.0)
            // $0.width.equalTo(UIScreen.main.bounds.width - (40.0 * 2))
        }
        
        doneButton.snp.makeConstraints {
            $0.centerX.equalTo(userProfileImageView.snp.centerX)
            $0.leading.equalToSuperview().inset(40.0)
            $0.trailing.equalToSuperview().inset(40.0)
            $0.bottom.equalToSuperview().inset(90.0)
        }
    
    }
}

// MARK: - PreviewProvider

struct EditProfileViewController_Previews: PreviewProvider {
  static var previews: some View {
    Container().edgesIgnoringSafeArea(.all)
  }
  
  struct Container: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
      let homeViewController = EditProfileViewController()
      return UINavigationController(rootViewController: homeViewController)
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    typealias UIViewControllerType = UIViewController
  }
}
