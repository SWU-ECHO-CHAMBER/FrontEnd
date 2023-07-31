//
//  DetailNewsViewController.swift
//  EchoChamber
//
//  Created by 목정아 on 2023/07/21.
//

import UIKit
import SwiftUI
import SnapKit
import Alamofire
import Kingfisher

class DetailNewsViewController : UIViewController {
    
    private let inset: CGFloat = Inset.inset
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private var url : String = ""
    private var contentViewHeightConstraints: Constraint?

    var newsID: Int?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18.0, weight: .bold)
        label.textColor = .textColor
        label.text = "???"
        
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13.0, weight: .regular)
        label.textColor = .subTextColor
        label.text = "By ???, ???"
        
        return label
    }()
    
    private lazy var publishedLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13.0, weight: .regular)
        label.textColor = .subTextColor
        label.text = "Published ???"
        
        return label
    }()
    
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = true
        
        if let imageURL = URL(string: "https://i.pinimg.com/564x/25/cb/0b/25cb0b4b31c9b5c0a82fbe15b4e10ad8.jpg") {
            imageView.kf.setImage(with: imageURL)
        }
        
        return imageView
    }()
    
    private lazy var newsTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18.0, weight: .regular)
        label.textColor = .textColor
        label.numberOfLines = 0
        label.textAlignment  = .justified
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        
        label.text = "ERROR) Not Text.."
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigation()
        self.setupLayout()
        
        self.fetchNewDetail(completionHandler: { [weak self] result in
            guard let self = self else { return }
            switch result {
                
            case let .success(result):
                if result.data.marked == true {
                    self.navigationItem.rightBarButtonItems?[1].image = UIImage(named: "Bookmark_Color")?.resize(to: CGSize(width: 22.0, height: 22.0))
                }
                
                self.titleLabel.text = result.data.title
                self.authorLabel.text = "By \(result.data.author), \(result.data.source)"
                
                if let imageURL = URL(string: result.data.imageURL) {
                    self.newsImageView.kf.setImage(with: imageURL)
                }
                
                self.newsTextLabel.text = result.data.content
                
                self.publishedLabel.text = "Published \(self.formatDateTimeWithRelativeString(result.data.publishedAt, format: "yyyy년 MM월 d일"))"
                
                self.url = result.data.url
    
            case let .failure(error):
              print("FetchNewDetail ERROR : \(error)")
            }
          }
        )
    }
    
}

private extension DetailNewsViewController {
    
    // MARK: - Setup Layout

    func setupLayout() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        newsTextLabel.sizeToFit()

        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        newsTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        [
            titleLabel,
            authorLabel,
            publishedLabel,
            newsImageView,
            newsTextLabel,
        ].forEach { contentView.addSubview($0) }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(3200.0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).inset(24.0)
            $0.leading.equalToSuperview().inset(inset*2)
            $0.trailing.equalToSuperview().inset(inset*2)
            $0.width.equalTo(UIScreen.main.bounds.size.width - (33 * 2))
        }
        
        authorLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(13.0)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailing.equalTo(titleLabel.snp.trailing)
            $0.width.equalTo(titleLabel.snp.width)
        }
        
        publishedLabel.snp.makeConstraints {
            $0.top.equalTo(authorLabel.snp.bottom).offset(5.0)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailing.equalTo(titleLabel.snp.trailing)
            $0.width.equalTo(titleLabel.snp.width)
        }

        newsImageView.snp.makeConstraints {
            $0.top.equalTo(publishedLabel.snp.bottom).offset(20.0)
            $0.leading.equalToSuperview().inset(32.0)
            $0.trailing.equalToSuperview().inset(32.0)
            $0.height.equalTo(245.0)
        }
        
        newsTextLabel.snp.makeConstraints {
            $0.top.equalTo(newsImageView.snp.bottom).offset(20.0)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailing.equalTo(titleLabel.snp.trailing)
        }
    }
    
}

// MARK: - @objc & method

private extension DetailNewsViewController {

    @objc func didTapBookmarkButton() {
        self.patchBookmark()
    }
    
    @objc func didTapShareButton() {
        if let url = URL(string: self.url) {
            let activityItems: [Any] = [url]
            
            let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            present(activityVC, animated: true)
        }
    }
    
    
    func isDateToday(_ date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDateInToday(date)
    }

    func formatStringToDateTime(_ dateString: String, format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: dateString)
    }

    func formatDateTimeWithRelativeString(_ dateString: String, format: String) -> String {
        guard let date = formatStringToDateTime(dateString, format: "yyyy-MM-dd'T'HH:mm:ss") else {
            return "Invalid date format"
        }
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()

        if isDateToday(date) {
            dateFormatter.dateFormat = "h:mm a"
            return dateFormatter.string(from: date)
        } else {
            dateFormatter.dateFormat = format
            return dateFormatter.string(from: date)
        }
    }
}

// MARK: - Server(북마크 추가/삭제)

struct BookmarkDataModel: Codable {
    let code: Int
    let message: String
    let data: DataModel
}

struct DataModel: Codable {
    let marked: Bool
}

private extension DetailNewsViewController {
    
    func patchBookmark() {
        
        let url = NewsUrlCategory().editBookmarkURL(newsId: newsID ?? 1)
        
        let header : HTTPHeaders = [
            "Authorization" :  "Bearer \(UserDefaults.standard.string(forKey: "AccessToken") ?? "")",
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: Int] = [
            "news-id": newsID ?? 1,
        ]
        
        AF.request(url, method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: header)
            .responseDecodable(of: BookmarkDataModel.self) { response in
                switch response.result {
                case .success(let successData):
                    guard let statusCode = response.response?.statusCode else { return }
                    
                    if statusCode == 200 {
                        if successData.data.marked == true {
                            DispatchQueue.main.async {
                                self.navigationItem.rightBarButtonItems?[1].image = UIImage(named: "Bookmark_Color")?.resize(to: CGSize(width: 22.0, height: 22.0))
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.navigationItem.rightBarButtonItems?[1].image = UIImage(named: "Bookmark_Gray")?.resize(to: CGSize(width: 20.0, height: 20.0))
                            }
                        }
                    } else if statusCode == 400 {
                        let newViewController = LoginViewcontroller()
                        let navigationController = UINavigationController(rootViewController: newViewController)
                        navigationController.modalTransitionStyle = .crossDissolve
                        navigationController.modalPresentationStyle = .fullScreen
                        self.present(navigationController, animated: true, completion: nil)
                    } else if statusCode == 403 {
                        Token().reissuingToken (completionHandler: { [weak self] result in
                            guard let self = self else { return }
                            switch result {
                            case .success(_):
                                if statusCode == 200 {
                                    self.patchBookmark()
                                } else if statusCode == 401 {
                                    let newViewController = LoginViewcontroller()
                                      let navigationController = UINavigationController(rootViewController: newViewController)
                                      navigationController.modalPresentationStyle = .fullScreen
                                      self.present(navigationController, animated: true, completion: nil)
                                } else if statusCode == 403 {
                                    return
                                } else {
                                    self.alerController(title: "", message: "Internal Server Error. Try Again.")
                                }
                            case let .failure(error):
                                print("Token Parsing ERROR : \(error.localizedDescription)")
                            }
                          }
                        )
                    } else {
                        self.alerController(title: "ERROR", message: "☠️ Server Error")
                    }
                case .failure(let error):
                    self.alerController(title: "Server Error", message: "네트워크 상태를 확인해주세요!")
                    print("PATCH 요청 실패: \(error)")
                }
        }
    }
    
    // Alert
    func alerController(title: String, message: String) {
        let actionSheet = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        actionSheet.addAction(UIAlertAction(title: title, style: .cancel))
        present(actionSheet, animated: true)
    }
    
}

// MARK: - Server(기사 세부 조회)
private extension DetailNewsViewController {
    
    func fetchNewDetail(
        completionHandler: @escaping (Result <NewsDetail, Error> ) -> Void
    ) {
        let url = NewsUrlCategory().detailNewsUrl(id: newsID ?? 1)
        
        let header : HTTPHeaders = [
            "Authorization" :  "Bearer \(UserDefaults.standard.string(forKey: "AccessToken") ?? "")",
            "Content-Type": "application/json"
        ]
        
        AF.request(url, method: .get, headers: header)
            .responseData(completionHandler: { response in
                switch response.result {
                case let .success(successData):
                    
                    guard let statusCode = response.response?.statusCode else { return }
                    print("Success StatusCode : \(statusCode)")
                    
                    if statusCode == 200 {
                        do {
                            let decoder = JSONDecoder()
                            let result = try decoder.decode(NewsDetail.self, from: successData)
                            completionHandler(.success(result))
                        } catch {
                            completionHandler(.failure(error))
                        }
                    } else if statusCode == 400 {
                        let newController = LoginViewcontroller()
                        let navigationController = UINavigationController(rootViewController: newController)
                        navigationController.modalPresentationStyle = .fullScreen
                        self.present(newController, animated: true)
                    } else if statusCode == 403 {
                        self.refreshTokenIfNeeded()
                    } else {
                        self.alerController(title: "Server Error", message: "네트워크 상태를 확인해주세요!")
                    }
                case let .failure(error):
                    guard let statusCode = response.response?.statusCode else { return }
                    print("FetchNewsDetail StatusCode : \(statusCode)")
                    completionHandler(.failure(error))
                }
            }
        )
    }
    
    func refreshTokenIfNeeded() {
        guard let accessToken = UserDefaults.standard.string(forKey: "AccessToken"),
              let refreshToken = UserDefaults.standard.string(forKey: "RefreshToken") else {
            return
        }
        
        let url = LoginUrlCategory().REFRESH_TOKEN_URL
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Refresh": "Bearer \(refreshToken)"
        ]
        
        AF.request(url, method: .get, headers: headers)
            .responseDecodable { [weak self] (response: DataResponse<TokenResponseData, AFError>) in
                guard let self = self else { return }
                
                switch response.result {
                case .success(let data):
                    guard let statusCode = response.response?.statusCode else { return }
                    if statusCode == 200 {

                        let accessToken = data.data.access_token
                        let refreshToken = data.data.refresh_token
                        
                        UserDefaults.standard.set(accessToken, forKey: "AccessToken")
                        UserDefaults.standard.set(refreshToken, forKey: "RefreshToken")
                    } else if statusCode == 401 {
                        let newController = LoginViewcontroller()
                        let navigationController = UINavigationController(rootViewController: newController)
                        navigationController.modalPresentationStyle = .fullScreen
                        self.present(navigationController, animated: true)
                    } else {
                        self.alerController(title: "Server Error", message: "네트워크 상태를 확인해주세요!")
                    }
                case .failure(let error):
                    self.alerController(title: "Server Error", message: "네트워크 상태를 확인해주세요!")
                    print("PATCH 요청 실패: \(error)")
                }
            }
    }

}

// MARK: - Navigation

extension DetailNewsViewController {
    func setupNavigation() {
        
        let bookmarkButton = UIBarButtonItem(image: UIImage(named: "Bookmark_Gray")?.resize(to: CGSize(width: 20, height: 20)), style: .plain, target: self, action: #selector(didTapBookmarkButton))
        
        let shareButton = UIBarButtonItem(image: UIImage(named: "Share")?.resize(to: CGSize(width: 20, height: 20)), style: .plain, target: self, action: #selector(didTapShareButton))
        
        navigationItem.rightBarButtonItems = [shareButton, bookmarkButton]
    }
}

struct DetailNewsViewController_Previews: PreviewProvider {
    static var previews: some View {
        Container().edgesIgnoringSafeArea(.all)
    }
    
    struct Container: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            let homeViewController = DetailNewsViewController()
            return UINavigationController(rootViewController: homeViewController)
        }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
        typealias UIViewControllerType = UIViewController
    }
}
