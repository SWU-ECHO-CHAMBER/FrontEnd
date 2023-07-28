//
//  EditProfileViewController.swift
//  EchoChamber
//
//  Created by 목정아 on 2023/07/21.
//

import UIKit
import SnapKit
import SwiftUI

import Alamofire
import Photos

class EditProfileViewController : UIViewController {
    
    let inset : CGFloat = Inset.inset
    
    private var uploadImageToServer: UIImage?
    
    private lazy var userProfileImageView : UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
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
        
        button.addTarget(self, action: #selector(didTapCamerButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var usernameTextField : UITextField = {
        let textView = UITextField()
        textView.delegate = self
        
        textView.placeholder = UserDefaults.standard.string(forKey: "Nickname") ?? "Your Name"
        textView.textColor = .label
        textView.font = .systemFont(ofSize: 16.0, weight: .regular)
        textView.returnKeyType = .done
        
        return textView
    }()
    
    private lazy var textNumberLabel : UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 13.0, weight: .regular)
        label.textColor = .secondaryLabel
        label.text = "\(UserDefaults.standard.string(forKey: "Nickname")?.count ?? 0) / 20"
        
        return label
    }()
    
    private lazy var textLineStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 18.0
        [
            usernameTextField,
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
        
        button.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLayout()
        self.setupProfileImage()
        self.keyboardNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillshowHandle(notification: )), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideHandle), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.size.width / 2
    }
}

// MARK: - Layout

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

// MARK: - TextFieldDelegate

extension EditProfileViewController : UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        updateCharacterCountLabel()
    }
    
    func updateCharacterCountLabel() {
        let characterCount = usernameTextField.text?.count ?? 0
        textNumberLabel.text = "\(characterCount) / 20"
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 20
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        
        return newString.count <= maxLength
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        view.endEditing(true)
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
        return true
    }
}

// MARK: - UIImagePickerControllerDelegate

extension EditProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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

// MARK: - @objc & method
private extension EditProfileViewController {
    
    func keyboardNotification() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func setupProfileImage() {
        let imagePath = "/Users/mokjeong-a/Desktop/Images/ECHO_Image/\(UserDefaults.standard.string(forKey: "Email") ?? "").jpeg"
        
        if let image = UIImage(contentsOfFile: imagePath) {
            self.userProfileImageView.image = image
        } else {
            self.userProfileImageView.image = UIImage(named: "MyProfile")
            self.errorAlert(message: "이미지를 불러오지 못 했습니다..")
        }
    }
    
    func errorAlert(message : String) {
        let actionSheet = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        [
            UIAlertAction(title: "Close", style: .cancel) { _ in
            }
        ].forEach {
            actionSheet.addAction($0)
        }
        present(actionSheet, animated: true)
    }
    
    @objc func didTapDoneButton() {
        guard let nickname = self.usernameTextField.text else { return }
        self.sendPatchRequest(nickname: nickname)
    }
    
    @objc func didTapCamerButton() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func keyboardWillshowHandle(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            if keyboardSize.height > usernameTextField.frame.origin.y {
                let distance = usernameTextField.frame.origin.y - keyboardSize.height
                
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin.y = (distance / 3) + self.usernameTextField.frame.height
                }
            }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func keyboardWillHideHandle() { }
}

// MARK: - Server (프로필 변경)
private extension EditProfileViewController {
    
    func fetchProfileImage() {
        
        if let profile = uploadImageToServer {
            
            if let imageData = profile.jpegData(compressionQuality: 0.7) {
            
                let profileParameters : Parameters = [
                    "profile" : imageData
                ]
                
                let profileURL = MyPageUrlCategory().CHANGE_PROFILE_URL
                
                let header : HTTPHeaders = [
                    "Authorization" :  "Bearer \(UserDefaults.standard.string(forKey: "AccessToken") ?? "")",
                    "Content-Type": "multipart/form-data"
                ]
                
                AF.upload(multipartFormData: { formData in
                    for (key, value) in profileParameters {
                        if let stringValue = value as? String {
                            formData.append(stringValue.data(using: .utf8)!, withName: key)
                        } else if let imageData = value as? Data {
                            formData.append(imageData, withName: key, fileName: "\(UserDefaults.standard.string(forKey: "Email")!).jpeg", mimeType: "image/jpeg")
                        }
                    }
                }, to: profileURL,
                          method: .patch,
                          headers: header
                ).response { response in
                    switch response.result {
                    case .success(_):
                        guard let statusCode = response.response?.statusCode else { return }
                        print("statusCode : \(statusCode) / data : \(response.result)")
                        if statusCode == 201 {
                            self.navigationController?.popViewController(animated: true)
                        } else if statusCode == 400 {
                            print(response.result)
                            print(response.description)
                            self.errorAlert(message: "Please upload the image again.")
                        } else if statusCode == 403 {
                            print(response.result)
                            let newViewController = LoginViewcontroller()
                            let navigationController = UINavigationController(rootViewController: newViewController)
                            navigationController.modalPresentationStyle = .fullScreen
                            self.present(navigationController, animated: true, completion: nil)
                        } else {
                            print("statusCode : \(statusCode) / Result : \(response.result)")
                            self.errorAlert(message: "Internal Server error ☠️")
                        }
                    case .failure(let error):
                        self.errorAlert(message: "Server error ☠️ Please contact the administrator.")
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
            
        }
        
        
    }
    
    func sendPatchRequest(nickname : String) {
        let nicknameURL = MyPageUrlCategory().CHANGE_NICKNAME_URL
        
        let header : HTTPHeaders = [
            "Authorization" :  "Bearer \(UserDefaults.standard.string(forKey: "AccessToken") ?? "")",
            "Content-Type": "application/json"
        ]
        
        let nicknameParameters: Parameters = [
            "nickname": nickname
        ]
        
        AF.request(nicknameURL, method: .patch, parameters: nicknameParameters, encoding: JSONEncoding.default ,headers: header)
            .responseJSON { response in
                switch response.result {
                case .success(_):
                    guard let statusCode = response.response?.statusCode else { return }
                    if statusCode == 201 {
                        UserDefaults.standard.set(nickname, forKey: "Nickname")
                        self.fetchProfileImage()
                    } else if statusCode == 400 {
                        print(response.result)
                        self.errorAlert(message: "닉네임 형식이 올바르지 않거나 현재 닉네임입니다.")
                    } else if statusCode == 403 {
                        print(response.result)
                        let newViewController = LoginViewcontroller()
                        let navigationController = UINavigationController(rootViewController: newViewController)
                        navigationController.modalPresentationStyle = .fullScreen
                        self.present(navigationController, animated: true, completion: nil)
                    } else {
                        print(response.result)
                        self.errorAlert(message: "서버 오류☠️\n관리자에게 문의 부탁드립니다.")
                    }
                case .failure(let error):
                    self.errorAlert(message: "요청 실패: \(error.localizedDescription)")
                }
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
