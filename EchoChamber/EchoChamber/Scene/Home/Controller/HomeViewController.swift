//
//  HomeViewController.swift
//  EchoChamber
//
//  Created by 목정아 on 2023/07/20.
//

import UIKit
import SnapKit

class HomeViewController : UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        self.setupNavigationController()
    }
}

// MARK: - Layout
private extension HomeViewController {
    func setupLayout() {
        
    }
}

// MARK: - Naivigation

private extension HomeViewController {
    func setupNavigationController() {
        
        let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width - 100), height: 39))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 89, height: 39))
        imageView.contentMode = .scaleAspectFit
        
        let image = #imageLiteral(resourceName: "Logo")
        imageView.image = image
        
        
        logoContainer.addSubview(imageView)
        navigationItem.titleView = logoContainer
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = searchButton
    }
}
