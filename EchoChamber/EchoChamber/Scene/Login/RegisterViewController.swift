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
    
    
}

private extension RegisterViewController {
    
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
