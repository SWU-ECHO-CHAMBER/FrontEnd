//
//  MyPageViewController.swift
//  EchoChamber
//
//  Created by 목정아 on 2023/07/20.
//

import UIKit
import SnapKit
import SwiftUI

class MyPageViewController : UIViewController {
    
    let inset : CGFloat = Inset.inset
    
    private let separatorView = SeparatorView(frame: .zero)
    
    private lazy var UserProfileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "MyProfile")
        imageView.widthAnchor.constraint(equalToConstant: 75.94).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 75.94).isActive = true
        
        return imageView
    }()
    
    private lazy var userNameLabel : UILabel = {
        let label = UILabel()
        label.text = "USER NAME"
        label.font = UIFont(name: "LondrinaSolid-Regular", size: 20)
        label.textColor = .textColor
        label.numberOfLines = 1
        
        return label
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        
        if let originalImage = UIImage(named: "Pencil") {
            let targetWidth: CGFloat = 13.2
            let targetHeight: CGFloat = 13.2
            
            let resizedImage = originalImage.resize(to: CGSize(width: targetWidth, height: targetHeight))
            button.setImage(resizedImage, for: .normal)
        }
        
        button.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 11
       //  layout.estimatedItemSize = CGSize(width: view.frame.width - (36.0 * 2), height: 99.0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(MypageCollectionViewCell.self, forCellWithReuseIdentifier: MypageCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self

        return collectionView
    }()
    
    private lazy var savedArticleLabel : UILabel = {
        let label = UILabel()
        label.text = "Saved Articles"
        label.font = .systemFont(ofSize: 13.0, weight: .semibold)
        label.textColor = .textColor
        
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
           let scrollView = UIScrollView()
           scrollView.translatesAutoresizingMaskIntoConstraints = false
           scrollView.backgroundColor = .white
           return scrollView
       }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        self.setupNavigationController()
        self.setupLayout()
    }
}

// MARK: - Navigation

private extension MyPageViewController {
    func setupLayout() {
        [
            UserProfileImageView,
            userNameLabel,
            editButton,
            separatorView,
            savedArticleLabel,
            collectionView,
        ].forEach { view.addSubview($0) }
        
        UserProfileImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(inset*3)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(UserProfileImageView.snp.bottom).offset(inset)
            $0.centerX.equalTo(UserProfileImageView.snp.centerX)
        }
        
        editButton.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.top)
            $0.leading.equalTo(userNameLabel.snp.trailing).offset(5.0)
        }
        
        separatorView.snp.makeConstraints {
            $0.top.equalTo(editButton).inset(60)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        savedArticleLabel.snp.makeConstraints {
            $0.top.equalTo(separatorView).inset(35.0)
            $0.leading.equalToSuperview().inset(36.0)
            $0.trailing.equalToSuperview().inset(36.0)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(savedArticleLabel.snp.bottom).offset(30.0)
            $0.leading.equalTo(savedArticleLabel.snp.leading)
            $0.trailing.equalTo(savedArticleLabel.snp.trailing)
            $0.bottom.equalToSuperview()
        }
    }
}

extension MyPageViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MypageCollectionViewCell.identifier, for: indexPath) as? MypageCollectionViewCell else { return UICollectionViewCell() }
    
        cell.setup()
        
        return cell
    }
    
}

extension MyPageViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth: CGFloat = collectionView.frame.width
        let cellHeight: CGFloat = 99.0
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}


extension MyPageViewController : UICollectionViewDelegate {
    
}

// MARK: - Navigation

private extension MyPageViewController {
    func setupNavigationController() {
        
        let leftFixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        leftFixedSpace.width = 36.0
        
        let rightFixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        rightFixedSpace.width = 20.0
        
        if let originalImage = UIImage(named: "Logo") {
            
            let imageSize = CGSize(width: 89, height: 39)
            let resizedImage = originalImage.resize(to: imageSize)
            
            let imageView = UIImageView(image: resizedImage)
            imageView.frame = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
            
            let logoButton = UIBarButtonItem(customView: imageView)
            
            navigationItem.leftBarButtonItems = [leftFixedSpace, logoButton]
        }
        
        let logoutButton = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .plain, target: self, action: nil)
        logoutButton.tintColor = .mainColor
        
        let settingButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(didTapStettingButton))
        settingButton.tintColor = .mainColor
        
        navigationItem.rightBarButtonItems = [rightFixedSpace, settingButton, logoutButton]
    }
}

// MARK: - @objc

private extension MyPageViewController {
    
    @objc func didTapLogoutButton() {
        print("Logout")
    }
    
    @objc func didTapStettingButton() {
        let nextController = SettingViewController()
        nextController.view.backgroundColor = .white
        nextController.hidesBottomBarWhenPushed = true
        
        let backButton = UIBarButtonItem(title: "Settings", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        
        navigationController?.pushViewController(nextController, animated: true)
    }
    
    @objc func didTapEditButton() {
        let nextController = EditProfileViewController()
        nextController.view.backgroundColor = .white
        nextController.hidesBottomBarWhenPushed = true
        
        let backButton = UIBarButtonItem(title: "Edit Profile", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        
        navigationController?.pushViewController(nextController, animated: true)
    }
    
}

// MARK: - PreviewProvider

struct MyPageViewController_Previews: PreviewProvider {
    static var previews: some View {
        Container().edgesIgnoringSafeArea(.all)
    }
    
    struct Container: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            let homeViewController = MyPageViewController()
            return UINavigationController(rootViewController: homeViewController)
        }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
        typealias UIViewControllerType = UIViewController
    }
}

