//
//  LoginViewcontroller.swift
//  EchoChamber
//
//  Created by 목정아 on 2023/07/19.
//

import UIKit

class LoginViewcontroller : UIViewController {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        
        guard let image = UIImage(named: "Logo") else {  return imageView }
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        return imageView
    }()
    
    private lazy var idTextView : UITextField = {
        let textView = UITextField()
        
        textView.font = .systemFont(ofSize: 15.0)
        textView.textColor = UIColor.mainColor
        textView.returnKeyType = .done
        textView.textAlignment = .left
        textView.placeholder = "ex) echo_chamber"
        
        textView.delegate = self
        // textView.text = "ex) echo_chamber"
        
        return textView
    }()
    
    private lazy var passwordTextView : UITextField = {
        let textView = UITextField()
        
        textView.font = UIFont(name: "AppleSDGothicNeoM00-Regular", size: 15.0)
        textView.textColor = UIColor.mainColor
        textView.returnKeyType = .done
        textView.isSecureTextEntry = true
        textView.placeholder = "ex) echochamber12!!"
        
        textView.delegate = self
        
        return textView
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20.0, weight: .bold)
        button.backgroundColor = UIColor.systemGrayColor
        button.layer.cornerRadius = 9.0
        button.isEnabled = false
        
        button.addTarget(self, action: #selector(tapLoginButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var signupLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15.0, weight: .regular)
        label.textColor = UIColor.mainColor
        label.text = "SIGN UP"
        
        return label
    }()
    
    // MARK: - StackView
    
    private lazy var idStackView : UIStackView = {
        
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.layer.cornerRadius = 9.0
        stackView.layer.borderColor = UIColor.systemGrayColor.cgColor
        stackView.layer.borderWidth  = 1.5
        stackView.spacing = 23.59
        
        [
            userIconImageView,
            idTextView
        ].forEach { stackView.addArrangedSubview($0) }
        
        return stackView
    }()
    
    private lazy var passwordStackView : UIStackView = {
        
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.layer.cornerRadius = 9.0
        stackView.layer.borderColor = UIColor.systemGrayColor.cgColor
        stackView.layer.borderWidth  = 1.5
        stackView.spacing = 23.59
        
        [
            passwordIconImageView,
            passwordTextView
        ].forEach { stackView.addArrangedSubview($0) }
        
        return stackView
    }()
    
    // MARK: - ICON Image
    
    private lazy var userIconImageView: UIImageView = {
        let imageView = UIImageView()
        guard let image = UIImage(named: "ID") else { return imageView }
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        return imageView
    }()
    
    private lazy var passwordIconImageView: UIImageView = {
        let imageView = UIImageView()
        guard let image = UIImage(named: "Password") else { return imageView }
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        return imageView
    }()
    
    private lazy var facebookIconImageView: UIImageView = {
        let imageView = UIImageView()
        guard let image = UIImage(named: "Facebook") else { return imageView }
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        return imageView
    }()
    
    private lazy var instagramIconImageView: UIImageView = {
        let imageView = UIImageView()
        guard let image = UIImage(named: "Instagram") else { return imageView }
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        return imageView
    }()
    
    private lazy var googleIconImageView: UIImageView = {
        let imageView = UIImageView()
        guard let image = UIImage(named: "Google") else { return imageView }
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        return imageView
    }()
    
    private lazy var socialIconStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        
        [
            facebookIconImageView,
            instagramIconImageView,
            googleIconImageView,
        ].forEach { stackView.addArrangedSubview($0) }
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        self.setupLayout()
    }
}

private extension LoginViewcontroller {
    func setupLayout() {
        [
            imageView,
            idStackView,
            passwordStackView,
            loginButton,
            socialIconStackView,
            signupLabel
        ].forEach {
            view.addSubview($0)
        }
        
        let inset: CGFloat = 40.0
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(189.0)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.size.width - (94 * 2))
            $0.height.equalTo(88.0)
        }
        
        idStackView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(20.0)
            $0.leading.trailing.equalToSuperview().inset(inset)
            $0.height.equalTo(54.0)
        }
        
        passwordStackView.snp.makeConstraints {
            $0.top.equalTo(idStackView.snp.bottom).offset(12.0)
            $0.leading.equalTo(idStackView.snp.leading)
            $0.trailing.equalTo(idStackView.snp.trailing)
            $0.height.equalTo(idStackView.snp.height)
        }
        
        userIconImageView.snp.makeConstraints {
            $0.height.width.equalTo(16.0)
            $0.leading.equalTo(idStackView.snp.leading).inset(26.41)
        }
        
        passwordIconImageView.snp.makeConstraints {
            $0.height.width.equalTo(16.0)
            $0.leading.equalTo(passwordStackView.snp.leading).inset(26.41)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(passwordStackView.snp.bottom).offset(24.0)
            $0.leading.equalTo(idStackView.snp.leading)
            $0.trailing.equalTo(idStackView.snp.trailing)
            $0.height.equalTo(54.0)
        }
        
        facebookIconImageView.snp.makeConstraints {
            $0.width.height.equalTo(41.0)
        }
        
        instagramIconImageView.snp.makeConstraints {
            $0.width.height.equalTo(41.0)
        }
        
        googleIconImageView.snp.makeConstraints {
            $0.width.height.equalTo(41.0)
        }
        
        socialIconStackView.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(52.75)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.size.width - (104 * 2))
        }
        
        signupLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(inset)
            $0.centerX.equalToSuperview()
        }
    }
    
}

// MARK: - @objc

private extension LoginViewcontroller {
    @objc func tapLoginButton() {
        let newViewController = TabBarController()
        let navigationController = UINavigationController(rootViewController: newViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
}

extension LoginViewcontroller : UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let isIdEmpty = self.idTextView.text?.isEmpty else { return }
        guard let isPasswordEmpty = self.passwordTextView.text?.isEmpty else { return }
        
        idStackView.layer.borderColor = !isIdEmpty ? UIColor.mainColor.cgColor : UIColor.systemGrayColor.cgColor
        passwordStackView.layer.borderColor = !isPasswordEmpty ? UIColor.mainColor.cgColor : UIColor.systemGrayColor.cgColor
        
        if !isIdEmpty && !isPasswordEmpty {
            loginButton.backgroundColor = UIColor.mainColor
        } else {
            loginButton.backgroundColor = UIColor.systemGrayColor
        }
        
        self.loginButton.isEnabled = !isIdEmpty && !isPasswordEmpty
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        idTextView.resignFirstResponder()
        passwordTextView.resignFirstResponder()
    }
    
}
