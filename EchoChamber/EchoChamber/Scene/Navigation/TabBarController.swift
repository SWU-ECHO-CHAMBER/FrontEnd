//
//  TabBarController.swift
//  EchoChamber
//
//  Created by 목정아 on 2023/07/20.
//

import UIKit

class TabBarController : UITabBarController {
    
    private lazy var homeViewController: UIViewController = {
        let viewcontroller = UINavigationController(rootViewController: HomeViewController())
        
        let tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(named: "HomeGray"),
            selectedImage: UIImage(named: "HomeColor")
        )
    
        tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        viewcontroller.tabBarItem = tabBarItem
        
        return viewcontroller
    }()
    
    private lazy var myPageViewController: UIViewController = {
        let viewcontroller = UINavigationController(rootViewController: MyPageViewController())
    
        let tabBarItem = UITabBarItem(
            title: "My",
            image: UIImage(named: "MyPageGray"),
            selectedImage: UIImage(named: "MyPageColor")
        )
        
        
        tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        viewcontroller.tabBarItem = tabBarItem
        return viewcontroller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .white
        tabBar.tintColor = .mainColor
        
        viewControllers = [homeViewController, myPageViewController]
        
        self.setupStyle()
    }
}

private extension TabBarController {
  func setupStyle() {
      UITabBar.clearShadow()
      tabBar.layer.applyShadow(color: .gray, alpha: 0.3, x: 0, y: 0, blur: 12)
  }
}

private extension CALayer {
  // Sketch 스타일의 그림자를 생성하는 유틸리티 함수
  func applyShadow(
      color: UIColor = .black,
      alpha: Float = 0.5,
      x: CGFloat = 0,
      y: CGFloat = 2,
      blur: CGFloat = 4
  ) {
      shadowColor = color.cgColor
      shadowOpacity = alpha
      shadowOffset = CGSize(width: x, height: y)
      shadowRadius = blur / 2.0
  }
}

private extension UITabBar {
  // 기본 그림자 스타일을 초기화해야 커스텀 스타일을 적용할 수 있다.
  static func clearShadow() {
      UITabBar.appearance().shadowImage = UIImage()
      UITabBar.appearance().backgroundImage = UIImage()
      UITabBar.appearance().backgroundColor = UIColor.white
  }
}
