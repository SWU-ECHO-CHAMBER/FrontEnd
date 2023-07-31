//
//  RegisterViewController.swift
//  EchoChamber
//
//  Created by 목정아 on 2023/07/23.
//

import UIKit
import SwiftUI
import SnapKit
import Photos
import Alamofire

class RegisterViewController : UIViewController {
    
    private let emailSpacingView = SpacingView(width: 24.0, height: 0.0)
    private let passwordSpacingView = SpacingView(width: 24.0, height: 0.0)
    private let nickNameSpacingView = SpacingView(width: 24.0, height: 0.0)
    
    private let emailIconSpacingView = SpacingView(width: 20.0, height: 0.0)
    private let passwordIconSpacingView = SpacingView(width: 20.0, height: 0.0)
    private let nicknameIconSpacingView = SpacingView(width: 20.0, height: 0.0)
    
    private var emailIsPassed : Bool = false
    private var emailRedundancyIsPassed : Bool = false
    private var passwordIsPassed : Bool = false
    private var nicknameIsPassed : Bool = false
    
    private var uploadImageToServer: UIImage?
    
    private var passwordIconIsActive : Bool = false
    private var nicknameIconIsActive : Bool = false
    
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
        
        button.addTarget(self, action: #selector(didTapCamerButton), for: .touchUpInside)

        
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

        textField.tag = 1
        textField.delegate = self
        
        textField.font = .systemFont(ofSize: 15.0, weight: .regular)
        textField.layer.borderWidth = 1.5
        textField.layer.cornerRadius = 9.0
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .emailAddress
        textField.textContentType = .emailAddress
        textField.heightAnchor.constraint(equalToConstant: 54.0).isActive = true
        textField.textColor = UIColor(hex: "#767676")
        textField.layer.borderColor = UIColor(hex: "#767676").cgColor
        
        textField.placeholder = "ex) echo_chamber@google.com"
        
        textField.rightViewMode = .always
        textField.leftViewMode = .always
    
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        [
            emailCheckButton,
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
    
    private lazy var emailCheckButton : UIButton = {
        let button = UIButton()
        
        let image = UIImage(named: "CheckGray")
        let newSize = CGSize(width: 17.0, height: 17.0)
        let resizedImage = image?.resize(to: newSize)
        
        button.setImage(resizedImage, for: .normal)
        button.addTarget(self, action: #selector(didTapEmailCheckButton), for: .touchUpInside)
        
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
        
        textField.delegate = self
        textField.tag = 2
        
        textField.font = .systemFont(ofSize: 15.0, weight: .regular)
        textField.layer.borderWidth = 1.5
        textField.layer.cornerRadius = 9.0
        textField.heightAnchor.constraint(equalToConstant: 54.0).isActive = true
        textField.textColor = UIColor(hex: "#767676")
        textField.layer.borderColor = UIColor(hex: "#767676").cgColor
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.placeholder = "ex) echochamber12!!"
        textField.textContentType = .oneTimeCode
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
        button.addTarget(self, action: #selector(didTapPasswordEyeButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var passwordForamtLabel : UILabel = {
        let label = UILabel()
        label.text = "8 or more letters, 18 or less letters"
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
        
        textField.tag = 3
        textField.delegate = self
        
        textField.font = .systemFont(ofSize: 15.0, weight: .regular)
        textField.layer.borderWidth = 1.5
        textField.layer.cornerRadius = 9.0
        textField.heightAnchor.constraint(equalToConstant: 54.0).isActive = true
        textField.textColor = UIColor(hex: "#767676")
        textField.layer.borderColor = UIColor(hex: "#767676").cgColor
        textField.placeholder = "ex) echochamber_12"
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        // textField.isSecureTextEntry = true
        
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
        button.addTarget(self, action: #selector(didTapNicknameEyeButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var nicknameForamtLabel : UILabel = {
        let label = UILabel()
        label.text = "2 or more letters, 20 or less letters"
        label.font = .systemFont(ofSize: 15.0, weight: .regular)
        label.textColor = .errorColor
        
        return label
    }()
    
    private lazy var signupButton : UIButton = {
        let button = UIButton()
        button.setTitle("SIGN UP", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20.0, weight: .bold)
        button.heightAnchor.constraint(equalToConstant: 54.0).isActive = true
        button.layer.cornerRadius = 9.0
        button.backgroundColor = UIColor(hex: "#B9B9B9")
        button.addTarget(self, action: #selector(didTapSignupButton), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()
        self.keyboardDownNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
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

// MARK: - UITextFieldDelegate

extension RegisterViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
      return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        if textField.tag == 1 {
            let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
            
            let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            let isValidEmail = emailTest.evaluate(with: updatedText)
            
            let newSize = CGSize(width: 17.0, height: 17.0)
            
            let image = UIImage(named: "CheckGray")
            let resizedImage = image?.resize(to: newSize)
            
            let checkImage = UIImage(named: "CheckColor")
            let resizedCheckedImage = checkImage?.resize(to: newSize)
            
            if isValidEmail == true {
                self.emailIsPassed = true
                DispatchQueue.main.async {
                    self.checkEmailFormatLabel.textColor = .mainColor
                    self.emailCheckButton.setImage(checkImage, for: .normal)
                }
            } else {
                self.emailIsPassed = false
                DispatchQueue.main.async {
                    self.checkEmailFormatLabel.textColor = .errorColor
                    self.emailCheckButton.setImage(image, for: .normal)
                }
            }
            checkSignUpButtonActive()
            return true
        } else if textField.tag == 2 {
            let currentString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)
            
            return checkFormatPassword(text: newString)
        } else if textField.tag == 3 {
            let currentString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)
        
            return checkFormatNickname(text: newString)
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
        NotificationCenter.default.removeObserver(self)
        
        if textField.tag == 3 {
            NotificationCenter.default.addObserver(self, selector: #selector(registerKeyboardWillshowHandle), name: UIResponder.keyboardWillShowNotification, object: nil)
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(registerKeyboardWillHideHandle), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }
    
}

// MARK: - UITextFieldDelegate 관련된 메서드

private extension RegisterViewController {
    
    func checkFormatPassword(text: String) -> Bool {
        if text.count >= 8 {
            self.passwordIsPassed = true
            DispatchQueue.main.async {
                self.passwordForamtLabel.textColor = .mainColor
            }
        } else {
            self.passwordIsPassed = false
            DispatchQueue.main.async {
                self.passwordForamtLabel.textColor = .errorColor
            }
        }
        checkSignUpButtonActive()
        return text.count <= 18
    }
    
    func checkFormatNickname(text : String) -> Bool{
        if text.count >= 2 {
            self.nicknameIsPassed = true
            DispatchQueue.main.async {
                self.nicknameForamtLabel.textColor = .mainColor
            }
        } else {
            self.nicknameIsPassed = false
            DispatchQueue.main.async {
                self.nicknameForamtLabel.textColor = .errorColor
            }
        }
        checkSignUpButtonActive()
        return text.count <= 20
    }
    
    func checkSignUpButtonActive() {
        if emailIsPassed && passwordIsPassed && nicknameIsPassed == true {
            DispatchQueue.main.async {
                self.signupButton.backgroundColor = .mainColor
            }
        } else {
            DispatchQueue.main.async {
                self.signupButton.backgroundColor = UIColor(hex: "#B9B9B9")
            }
        }
    }
    
    func keyboardDownNotification() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
          view.addGestureRecognizer(tap)
    }
}

// MARK: - @objc

private extension RegisterViewController {
    
    @objc func didTapEmailCheckButton() {
        if emailIsPassed == true{
            checkEmail(email: emailTextField.text ?? "")
        }
    }
    
    @objc func didTapPasswordEyeButton() {
        
        let newSize = CGSize(width: 17.0, height: 17.0)
        
        if passwordIconIsActive == true {
            self.passwordIconIsActive = false
            let image = UIImage(named: "Eyeslash")
            let resizedImage = image?.resize(to: newSize)
            
            self.passwordTextField.isSecureTextEntry = true
            self.passwordEyeButton.setImage(resizedImage, for: .normal)
        } else {
            self.passwordIconIsActive = true
            let image = UIImage(named: "Eye")
            let resizedImage = image?.resize(to: newSize)
            
            self.passwordTextField.isSecureTextEntry = false
            self.passwordEyeButton.setImage(resizedImage, for: .normal)
        }
    }

    @objc func didTapNicknameEyeButton() {
        let newSize = CGSize(width: 17.0, height: 17.0)
        
        if nicknameIconIsActive == true {
            self.nicknameIconIsActive = false
            let image = UIImage(named: "Eyeslash")
            let resizedImage = image?.resize(to: newSize)
            self.nicknameTextField.isSecureTextEntry = true
            
            self.nicknameEyeButton.setImage(resizedImage, for: .normal)
        } else {
            self.nicknameIconIsActive = true
            let image = UIImage(named: "Eye")
            let resizedImage = image?.resize(to: newSize)
            
            self.nicknameTextField.isSecureTextEntry = false
            self.nicknameEyeButton.setImage(resizedImage, for: .normal)
        }
    }
    
    @objc func didTapSignupButton() {
        if emailIsPassed && passwordIsPassed && nicknameIsPassed == true {
            fetchRegister(email: emailTextField.text ?? "", password: passwordTextField.text ?? "", nickname: nicknameTextField.text ?? "", profileImage: uploadImageToServer)
        }
    }
    
    @objc func didTapCamerButton() {
        showImagePicker()
    }
    
    func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
       view.endEditing(true)
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func registerKeyboardWillshowHandle(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {

            if keyboardSize.height < nicknameTextField.frame.origin.y {
                let distance = keyboardSize.height - nicknameTextField.frame.origin.y
                
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin.y = (distance / 1.1) + self.nicknameTextField.frame.height
                }
            }
        }
    }

    @objc func registerKeyboardWillHideHandle() {
        
    }
}

// MARK: - UIImagePickerControllerDelegate

extension RegisterViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true, completion: nil)

            if let pickedImage = info[.originalImage] as? UIImage {
                
                self.userProfileImageView.image = pickedImage
                self.userProfileImageView.contentMode = .scaleAspectFill
                self.userProfileImageView.clipsToBounds = true
                self.userProfileImageView.layer.cornerRadius = self.userProfileImageView.frame.size.width / 2
                
                if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                        uploadImageToServer = selectedImage
                    }
            }
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }

}

// MARK: - Server) 이메일 중복 확인

private extension RegisterViewController {
    func checkEmail(email: String) {
        let parameters: [String: Any] = [
          "email": email,
        ]
            
        let url = LoginUrlCategory().CEHCK_EMAIL_URL
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
          .responseJSON { response in
            switch response.result {
            case .success(_):
                guard let statusCode = response.response?.statusCode else { return }
                if statusCode == 200 {
                    self.emailRedundancyIsPassed = true
                    DispatchQueue.main.async {
                        self.emailRedundancyLabel.textColor = .mainColor
                        self.emailRedundancyLabel.text = "Email Redundancy"
                    }
                } else if statusCode == 400 {
                    self.emailRedundancyIsPassed = false
                    DispatchQueue.main.async {
                        self.emailRedundancyLabel.text = "☠️ Email already exists..."
                    }
                }
            case .failure(let error):
                self.emailRedundancyIsPassed = false
                print("Error: \(error.localizedDescription)")
            }
          }
    }
}

// MARK: - Server) 회원가입

private extension RegisterViewController {
    
    func fetchRegister(email: String, password: String, nickname: String, profileImage: UIImage?) {
        if emailIsPassed && emailRedundancyIsPassed && passwordIsPassed && nicknameIsPassed {
            let url = LoginUrlCategory().REGISTER_LOGIN_URL
            
            var parameters: [String: Any] = [
                "email": email,
                "password": password,
                "nickname": nickname
            ]

            if let profile = profileImage {
                if let imageData = profile.jpegData(compressionQuality: 0.7) {
                    parameters["profile"] = imageData
                }
            }

            AF.upload(multipartFormData: { formData in
                for (key, value) in parameters {
                    if let stringValue = value as? String {
                        formData.append(stringValue.data(using: .utf8)!, withName: key)
                    } else if let imageData = value as? Data {
                        formData.append(imageData, withName: key, fileName: "profile(\(nickname)).jpg", mimeType: "image/jpeg")
                    }
                }
            }, to: url).response { response in
                switch response.result {
                case .success(_):
                    guard let statusCode = response.response?.statusCode else { return }
                    if statusCode == 200 {
                        UserDefaults.standard.set(nickname, forKey: "Nickname")
                        self.registerSuccessAlert(message: "Membership registration completed! 🎉")
                    } else if statusCode == 400 {
                        print(response.description)
                        self.registerErrorAlert(message: "Please check again to see if all the formats are written correctly.")
                    } else {
                        self.registerErrorAlert(message: "Server error ☠️ Please contact the administrator.")
                    }
                case .failure(let error):
                    self.registerErrorAlert(message: "Server error ☠️ Please contact the administrator.")
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func registerErrorAlert(message : String) {
        let actionSheet = UIAlertController(title: nil, message: message, preferredStyle: .alert)
          [
            UIAlertAction(title: "Close", style: .cancel) { _ in
               
            }
          ].forEach {
            actionSheet.addAction($0)
          }
          present(actionSheet, animated: true)
    }
    
    func registerSuccessAlert(message : String) {
        let actionSheet = UIAlertController(title: nil, message: message, preferredStyle: .alert)
          [
            UIAlertAction(title: "OK", style: .cancel) { _ in
                self.navigationController?.popViewController(animated: true)
            }
          ].forEach {
            actionSheet.addAction($0)
          }
          present(actionSheet, animated: true)
    }
}

