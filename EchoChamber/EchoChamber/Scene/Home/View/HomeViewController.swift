//
//  HomeViewController.swift
//  EchoChamber
//
//  Created by 목정아 on 2023/07/20.
//

import UIKit
import SnapKit

class HomeViewController : UIViewController {
    
    let inset: CGFloat = Inset.inset
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = inset
        layout.sectionInset = UIEdgeInsets(top: inset, left: 0, bottom: 0, right: 0)
        layout.estimatedItemSize = CGSize(width: view.frame.width - 37 * 2, height: 104.0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = .systemBackground
        
        collectionView.register(TodayNewsCollectionViewCell.self, forCellWithReuseIdentifier: TodayNewsCollectionViewCell.identifier)
        
        collectionView.register(HomeCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeCollectionHeaderView")
        
        return collectionView
    }()
    
    // MARK: - StackView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        self.setupNavigationController()
        self.setupLayout()
    }
}

// MARK: - Layout

private extension HomeViewController {
    
    func setupLayout() {
        [
            collectionView,
        ].forEach { view.addSubview($0) }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

// MARK: - CollectionView

extension HomeViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayNewsCollectionViewCell.identifier, for: indexPath) as? TodayNewsCollectionViewCell else { return UICollectionViewCell() }
        
        cell.setup()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HomeCollectionHeaderView", for: indexPath) as? HomeCollectionHeaderView else { return UICollectionReusableView() }
        
        header.setupViews()
        return header
    }
    
}

extension HomeViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 400)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.width - 36 * 2, height: 104)
    }
}

extension HomeViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let newViewController = DetailNewsViewController()
        newViewController.view.backgroundColor = .white
        navigationController?.pushViewController(newViewController, animated: true)
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
