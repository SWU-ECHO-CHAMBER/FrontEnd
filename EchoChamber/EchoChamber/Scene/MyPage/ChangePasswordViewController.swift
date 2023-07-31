//
//  ChangePasswordViewController.swift
//  EchoChamber
//
//  Created by 목정아 on 2023/07/27.
//

import UIKit
import SwiftUI

class ChangePasswordViewController : UIViewController {
    
    private lazy var passwordTextField : UITextField = {
        let textView = UITextField()
        // textView.delegate = self
        
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
        label.text = " / 20"
        
        return label
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("DONE", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20.0, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .mainColor
        button.layer.cornerRadius = 9.0
        button.heightAnchor.constraint(equalToConstant: 54.0).isActive = true
        
        // button.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
}

extension ChangePasswordViewController : UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        updateCharacterCountLabel()
    }
    
    func updateCharacterCountLabel() {
        let characterCount = passwordTextField.text?.count ?? 0
        textNumberLabel.text = "\(characterCount) / 18"
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

// MARK: - PreviewProvider

struct ChangePsswordViewController_Previews: PreviewProvider {
    static var previews: some View {
        Container().edgesIgnoringSafeArea(.all)
    }
    
    struct Container: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            let homeViewController = ChangePasswordViewController()
            return UINavigationController(rootViewController: homeViewController)
        }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
        typealias UIViewControllerType = UIViewController
    }
}
 
