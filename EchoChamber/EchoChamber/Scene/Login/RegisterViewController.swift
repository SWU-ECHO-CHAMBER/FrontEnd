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
    
    private let emailSpacingView = SpacingView(width: 24.0, height: 0.0)
    private let passwordSpacingView = SpacingView(width: 24.0, height: 0.0)
    private let nickNameSpacingView = SpacingView(width: 24.0, height: 0.0)
    
    private let emailIconSpacingView = SpacingView(width: 20.0, height: 0.0)
    private let passwordIconSpacingView = SpacingView(width: 20.0, height: 0.0)
    private let nicknameIconSpacingView = SpacingView(width: 20.0, height: 0.0)
    
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
    
    private lazy var emailLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15.0, weight: .regular)
        label.text = "Email"
        label.textColor = UIColor(hex: "#767676")
        
        return label
    }()
    
    private lazy var emailTextField : UITextField = {
       let textField = UITextField()
        textField.font = .systemFont(ofSize: 15.0, weight: .regular)
        textField.layer.borderWidth = 1.5
        textField.layer.cornerRadius = 9.0
        textField.heightAnchor.constraint(equalToConstant: 54.0).isActive = true
        textField.textColor = UIColor(hex: "#767676")
        textField.layer.borderColor = UIColor(hex: "#767676").cgColor
        textField.placeholder = "ex) echo_chamber@google.com"
        
        textField.rightViewMode = .always
        textField.leftViewMode = .always
        
        let imageView = UIImageView()
        let image = UIImage(named: "CheckGray")
        imageView.image = image
        imageView.heightAnchor.constraint(equalToConstant: 17.0).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 17.0).isActive = true
    
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        [
            imageView,
            emailIconSpacingView,
        ].forEach { stackView.addArrangedSubview($0) }
        
        textField.rightView = stackView
        textField.leftView = emailSpacingView
        
        return textField
    }()
    
    private lazy var checkEmailFormatLabel : UILabel = {
        let label = UILabel()
        label.text = "Check email formatting"
        label.font = .systemFont(ofSize: 15.0, weight: .regular)
        label.textColor = .errorColor
        
        return label
    }()
    
    private lazy var emailRedundancyLabel : UILabel = {
        let label = UILabel()
        label.text = "Email Redundancy"
        label.font = .systemFont(ofSize: 15.0, weight: .regular)
        label.textColor = .errorColor
        
        return label
    }()
    
    private lazy var emailEyeButton : UIButton = {
        let button = UIButton()
        
        let image = UIImage(named: "Eyeslash")
        let newSize = CGSize(width: 17.0, height: 17.0)
        let resizedImage = image?.resize(to: newSize)
        
        button.setImage(resizedImage, for: .normal)
        
        return button
    }()
    
    private lazy var passwordLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15.0, weight: .regular)
        label.text = "Password"
        label.textColor = UIColor(hex: "#767676")
        
        return label
    }()
    
    private lazy var passwordTextField : UITextField = {
       let textField = UITextField()
        textField.font = .systemFont(ofSize: 15.0, weight: .regular)
        textField.layer.borderWidth = 1.5
        textField.layer.cornerRadius = 9.0
        textField.heightAnchor.constraint(equalToConstant: 54.0).isActive = true
        textField.textColor = UIColor(hex: "#767676")
        textField.layer.borderColor = UIColor(hex: "#767676").cgColor
        textField.placeholder = "ex) echochamber12!!"
        textField.isSecureTextEntry = true
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        [
            passwordEyeButton,
            passwordIconSpacingView,
        ].forEach { stackView.addArrangedSubview($0) }
     
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        textField.leftView = passwordSpacingView
        textField.rightView = stackView
        
        return textField
    }()
    
    private lazy var passwordEyeButton : UIButton = {
        let button = UIButton()
        
        let image = UIImage(named: "Eyeslash")
        let newSize = CGSize(width: 17.0, height: 17.0)
        let resizedImage = image?.resize(to: newSize)
        
        button.setImage(resizedImage, for: .normal)
        
        return button
    }()
    
    private lazy var passwordForamtLabel : UILabel = {
        let label = UILabel()
        label.text = "2 or more letters, 20 or less letters"
        label.font = .systemFont(ofSize: 15.0, weight: .regular)
        label.textColor = .errorColor
        
        return label
    }()
    
    private lazy var nicknameLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15.0, weight: .regular)
        label.text = "Nickname"
        label.textColor = UIColor(hex: "#767676")
        
        return label
    }()
    
    private lazy var nicknameTextField : UITextField = {
       let textField = UITextField()
        textField.font = .systemFont(ofSize: 15.0, weight: .regular)
        textField.layer.borderWidth = 1.5
        textField.layer.cornerRadius = 9.0
        textField.heightAnchor.constraint(equalToConstant: 54.0).isActive = true
        textField.textColor = UIColor(hex: "#767676")
        textField.layer.borderColor = UIColor(hex: "#767676").cgColor
        textField.placeholder = "ex) echochamber_12"
        textField.isSecureTextEntry = true
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        [
            nicknameEyeButton,
            nicknameIconSpacingView,
        ].forEach { stackView.addArrangedSubview($0) }
        
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        textField.leftView = nickNameSpacingView
        textField.rightView = stackView
        
        return textField
    }()
    
    private lazy var nicknameEyeButton : UIButton = {
        let button = UIButton()
        
        let image = UIImage(named: "Eyeslash")
        let newSize = CGSize(width: 17.0, height: 17.0)
        let resizedImage = image?.resize(to: newSize)
        
        button.setImage(resizedImage, for: .normal)
        
        return button
    }()
    
    private lazy var nicknameForamtLabel : UILabel = {
        let label = UILabel()
        label.text = "8 or more letters, 18 or less letters"
        label.font = .systemFont(ofSize: 15.0, weight: .regular)
        label.textColor = .errorColor
        
        return label
    }()
    
    private lazy var signupButton : UIButton = {
        let button = UIButton()
        button.setTitle("SIGN UP", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 54.0).isActive = true
        button.layer.cornerRadius = 9.0
        button.backgroundColor = UIColor(hex: "#B9B9B9")
        
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
            
            emailLabel,
            emailTextField,
            checkEmailFormatLabel,
            emailRedundancyLabel,
            
            passwordLabel,
            passwordTextField,
            passwordForamtLabel,
            
            nicknameLabel,
            nicknameTextField,
            nicknameForamtLabel,
            
            signupButton
        ].forEach { view.addSubview($0) }
        
        userProfileImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(44.0)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        cameraButton.snp.makeConstraints {
            $0.bottom.equalTo(userProfileImageView.snp.bottom).offset(5.0)
            $0.centerX.equalTo(userProfileImageView.snp.centerX).offset(40.0)
        }
        
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(userProfileImageView.snp.bottom).offset(42.0)
            $0.leading.equalToSuperview().inset(51.0)
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(5.0)
            $0.leading.equalToSuperview().inset(40.0)
            $0.trailing.equalToSuperview().inset(40.0)
        }
        
        checkEmailFormatLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(4.7)
            $0.leading.equalTo(emailTextField.snp.leading).inset(10.0)
        }
        
        emailRedundancyLabel.snp.makeConstraints {
            $0.top.equalTo(checkEmailFormatLabel.snp.bottom).offset(4.7)
            $0.leading.equalTo(checkEmailFormatLabel.snp.leading)
        }
        
        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(emailRedundancyLabel.snp.bottom).offset(28.0)
            $0.leading.equalTo(emailLabel.snp.leading)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(4.7)
            $0.leading.equalTo(emailTextField)
            $0.trailing.equalTo(emailTextField)
        }
        
        passwordForamtLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(4.7)
            $0.leading.equalTo(checkEmailFormatLabel)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(passwordForamtLabel.snp.bottom).offset(28.0)
            $0.leading.equalTo(emailLabel)
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(4.7)
            $0.leading.equalTo(emailTextField)
            $0.trailing.equalTo(emailTextField)
        }
        
        nicknameForamtLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(4.7)
            $0.leading.equalTo(checkEmailFormatLabel)
        }
        
        signupButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(77.4)
            $0.leading.equalTo(emailTextField)
            $0.trailing.equalTo(emailTextField)
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
