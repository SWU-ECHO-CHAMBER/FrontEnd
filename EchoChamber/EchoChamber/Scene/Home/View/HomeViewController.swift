//
//  HomeViewController.swift
//  EchoChamber
//
//  Created by 목정아 on 2023/07/20.
//

import UIKit
import SwiftUI
import Alamofire

class HomeViewController : UIViewController {
    
    let inset: CGFloat = Inset.inset
    
    private var currentPage = 1
    private var isLoading = false
    private var newsList = [News.NewsData]()
    
    private lazy var refreshControl: UIRefreshControl = {
      let refreshControl = UIRefreshControl()
      refreshControl.tintColor = .mainColor
      refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
      return refreshControl
    }()
    
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
        
        collectionView.refreshControl = refreshControl
        
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
        
        self.setDataServer()
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
    
    func setDataServer() {
        self.fetchNewsData(of: currentPage, completionHandler: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case  .success(let newsData):
                self.newsList = newsData.data
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print("ERROR : \(error.localizedDescription)")
            }
          })
    }
}

// MARK: - CollectionView - UICollectionViewDataSource

extension HomeViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayNewsCollectionViewCell.identifier, for: indexPath) as? TodayNewsCollectionViewCell else { return UICollectionViewCell() }
        
        let newsData = newsList[indexPath.item]
        
        cell.setup()
        cell.setupServer(with: newsData)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HomeCollectionHeaderView", for: indexPath) as? HomeCollectionHeaderView else { return UICollectionReusableView() }

        header.setupViews()
        header.setDataServer()
        return header
    }
    
}

// MARK: - CollectionView - UICollectionViewDelegateFlowLayout

extension HomeViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 400)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.width - 36 * 2, height: 104)
    }
}

// MARK: - CollectionView - UICollectionViewDelegate

extension HomeViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let newsID : Int = newsList[indexPath.item].newsID
        let newViewController = DetailNewsViewController()
        
        newViewController.newsID = newsID
        newViewController.view.backgroundColor = .white
        navigationController?.pushViewController(newViewController, animated: true)
    }
}

// MARK: - Naivigation

private extension HomeViewController {
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
        
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [rightFixedSpace, searchButton]
    }
}

struct HomeViewController_Previews: PreviewProvider {
    static var previews: some View {
        Container().edgesIgnoringSafeArea(.all)
    }
    
    struct Container: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            let homeViewController = HomeViewController()
            return UINavigationController(rootViewController: homeViewController)
        }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
        typealias UIViewControllerType = UIViewController
    }
}

// MARK: - Server

private extension HomeViewController {
    private func fetchNewsData(of page: Int, completionHandler: @escaping (Result<News, Error>) -> Void) {
        guard !isLoading else { return }
        isLoading = true
        
        let url = NewsUrlCategory().ENTIRE_NEWS_URL + "?page=\(currentPage)&per_page=10"
        
        AF.request(url, method: .get).responseData { [weak self] response in
            guard let self = self else { return }
            
            self.isLoading = false
            
            switch response.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(News.self, from: data)
                    
                    self.newsList.append(contentsOf: result.data)
                
                    self.currentPage += 1
            
                    DispatchQueue.main.async {
                        self.refreshControl.endRefreshing()
                        self.collectionView.reloadData()
                    }
                    completionHandler(.success(result))
                } catch {
                    completionHandler(.failure(error))
                }
                
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    @objc func refresh() {
        setDataServer()
    }
}

extension HomeViewController: UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    guard currentPage != 1 else { return }
    indexPaths.forEach {
      if ($0.row + 1) / 25 + 1 == currentPage {
          self.fetchNewsData(of: currentPage) { _ in }
      }
    }
  }
}
