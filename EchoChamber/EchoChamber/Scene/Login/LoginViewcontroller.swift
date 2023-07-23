//
//  LoginViewcontroller.swift
//  EchoChamber
//
//  Created by 목정아 on 2023/07/19.
//

import UIKit
import SwiftUI
import SnapKit
import Alamofire

class LoginViewcontroller : UIViewController {
    
    private var loginButtonActive : Bool = false
    
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
    
    private lazy var errorLabel : UILabel = {
        let label = UILabel()
        label.textColor = .errorColor
        label.font = .systemFont(ofSize: 15.0, weight: .regular)
        label.isHidden = true
        label.text = "ERROR TEXT"
        
        return label
    }()
    
    private lazy var signupButton : UIButton = {
        let button = UIButton()
        button.setTitle("SIGN UP", for: .normal)
        button.setTitleColor(.mainColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15.0, weight: .regular)
        button.addTarget(self, action: #selector(tapSignupButton), for: .touchUpInside)
        
        return button
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
            errorLabel,
            socialIconStackView,
            signupButton
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
        
        errorLabel.snp.makeConstraints {
            $0.top.equalTo(passwordStackView.snp.bottom).offset(12.0)
            $0.leading.equalTo(passwordStackView.snp.leading).inset(27.0)
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
        
        signupButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(inset)
            $0.centerX.equalToSuperview()
        }
    }
    
}

// MARK: - @objc

private extension LoginViewcontroller {
    @objc func tapLoginButton() {
        login(email: idTextView.text ?? "", password: passwordTextView.text ?? "")
    }
    
    @objc func tapSignupButton() {
        print("SIGN UP")
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

// MARK: - PreviewProvider

struct LoginViewcontroller_Previews: PreviewProvider {
    static var previews: some View {
        Container().edgesIgnoringSafeArea(.all)
    }
    
    struct Container: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            let homeViewController = LoginViewcontroller()
            return UINavigationController(rootViewController: homeViewController)
        }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
        typealias UIViewControllerType = UIViewController
    }
}

// MARK: - Server

struct LoginResponse: Decodable {
    let data: UserData
}

struct UserData: Decodable {
    let access_token: String
}

private extension LoginViewcontroller {
    
    func login(email: String, password: String){
        
        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        let url = LoginUrlCategory().EMAIL_LOGIN_URL
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseDecodable(of: LoginResponse.self) { response in
            switch response.result {
                
            case .success(let loginResponse):
                guard let statusCode = response.response?.statusCode else { return }
                if statusCode == LoginStatusCode.ok.rawValue {
                    let accessToken = loginResponse.data.access_token
                    UserDefaults.standard.set(accessToken, forKey: "AccessToken")
                    
                    let newViewController = TabBarController()
                    let navigationController = UINavigationController(rootViewController: newViewController)
                    navigationController.modalPresentationStyle = .fullScreen
                    self.present(navigationController, animated: true, completion: nil)
                }
                
            case .failure(_):
                guard let statusCode = response.response?.statusCode else { return }
                
                self.loginButtonActive = false
                print("StatusCode : \(statusCode)")
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    self.errorLabel.text = LoginStatusCode(rawValue: statusCode)?.description
                    self.errorLabel.isHidden = false
                    
                    self.loginButton.snp.removeConstraints()
                    
                    self.loginButton.snp.makeConstraints {
                        $0.top.equalTo(self.passwordStackView.snp.bottom).offset(self.errorLabel.isHidden ? 24.0 : 53.0)
                        $0.leading.equalTo(self.idStackView.snp.leading)
                        $0.trailing.equalTo(self.idStackView.snp.trailing)
                        $0.height.equalTo(54.0)
                    }
                }
            }
        }
    }
}
