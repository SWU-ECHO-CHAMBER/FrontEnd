//
//  MyPageViewController.swift
//  EchoChamber
//
//  Created by 목정아 on 2023/07/20.
//

import UIKit
import SnapKit
import SwiftUI
import Alamofire

class MyPageViewController : UIViewController {
    
    let inset : CGFloat = Inset.inset
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 11
        //  layout.estimatedItemSize = CGSize(width: view.frame.width - (36.0 * 2), height: 99.0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(MypageCollectionViewCell.self, forCellWithReuseIdentifier: MypageCollectionViewCell.identifier)
        collectionView.register(MyPageCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MyPageCollectionViewHeader.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
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
            collectionView,
        ].forEach {  view.addSubview($0) }
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MyPageCollectionViewHeader.identifier, for: indexPath) as? MyPageCollectionViewHeader else { return UICollectionReusableView() }
        
        header.delegate = self
        header.setup()
        return header
    }
    
}

extension MyPageViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth: CGFloat = collectionView.frame.width - (36 * 2)
        let cellHeight: CGFloat = 99.0
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 280)
    }
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
        
        let logoutButton = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .plain, target: self, action: #selector(didTapLogoutButton))
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
        logout()
    }
    
    @objc func didTapStettingButton() {
        let nextController = SettingViewController()
        nextController.view.backgroundColor = .white
        nextController.hidesBottomBarWhenPushed = true
        
        let backButton = UIBarButtonItem(title: "Settings", style: .plain, target: nil, action: nil)
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

extension MyPageViewController : MyPageCollectionViewHeaderDelegate {
    func didTapEditButton() { 
        let nextController = EditProfileViewController()
        nextController.view.backgroundColor = .white
        nextController.hidesBottomBarWhenPushed = true
        
        let backButton = UIBarButtonItem(title: "Edit Profile", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        
        navigationController?.pushViewController(nextController, animated: true)
    }
}

extension MyPageViewController {
    private func logout() {
        let url = LoginUrlCategory().LOGOUT_URL
        let accessToken = UserDefaults.standard.string(forKey: "AccessToken")
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken ?? "")"]
        
        AF.request(url, method: .post, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: LoginResponse.self) { response in
            
            switch response.result {
            case .success(_):
                if let statusCode = response.response?.statusCode {
                    if statusCode == 200 {
                        let newViewController = LoginViewcontroller()
                      let navigationController = UINavigationController(rootViewController: newViewController)
                      navigationController.modalTransitionStyle = .crossDissolve
                      navigationController.modalPresentationStyle = .fullScreen
                        self.present(navigationController, animated: true, completion: nil)
                        print("Logout Success")
                    }
                }
            case .failure(_):
                print("Error Code : \(response.response?.statusCode)")
                
                if let statusCode = response.response?.statusCode {
                    if statusCode == 403 {
                        let newViewController = LoginViewcontroller()
                      let navigationController = UINavigationController(rootViewController: newViewController)
                      navigationController.modalTransitionStyle = .crossDissolve
                      navigationController.modalPresentationStyle = .fullScreen
                        self.present(navigationController, animated: true, completion: nil)
                        print("Logout Success")
                    }
                }
            }
        }
    }

}

