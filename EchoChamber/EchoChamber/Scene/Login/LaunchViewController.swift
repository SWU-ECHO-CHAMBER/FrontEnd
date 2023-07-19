//
//  LaunchViewController.swift
//  EchoChamber
//
//  Created by 목정아 on 2023/07/19.
//

import UIKit
import SnapKit

class LaunchViewController: UIViewController {
    
    var timer: Timer?
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        
        guard let image = UIImage(named: "Launch") else {
            return imageView
        }
    
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        self.setupLayout()
        
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(transitionToNextScreen), userInfo: nil, repeats: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
    }
    
    @objc func transitionToNextScreen() {
        let newViewController = LoginViewcontroller()
        let navigationController = UINavigationController(rootViewController: newViewController)
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
}

private extension LaunchViewController {
    func setupLayout() {
        view.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(148.0)
        }
    }
}
