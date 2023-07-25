//
//  HomeCollectionView.swift
//  EchoChamber
//
//  Created by 목정아 on 2023/07/20.
//

import UIKit
import SnapKit
import Alamofire
import Kingfisher

class HomeCollectionHeaderView : UICollectionReusableView {
    
    private let headerImageView : UIImageView = {
        let imageView = UIImageView()
        
        let imageViewURL : String = "https://media.cnn.com/api/v1/images/stellar/prod/230719105428-trump-nevada-0708.jpg?c=16x9&q=w_800,c_fill"
        
        imageView.contentMode = .scaleAspectFill
        if let imageURL = URL(string: imageViewURL){
          imageView.kf.setImage(with: imageURL)
        }
        
        return imageView
    }()

    private lazy var breakingNews : UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 14.0, weight: .semibold)
        textView.textColor = .textColor
        textView.backgroundColor = .white
        textView.textAlignment = .center
        textView.text = "Breaking News!"
        
        textView.layer.cornerRadius = 12.0
        textView.layer.masksToBounds = true
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.heightAnchor.constraint(equalToConstant: 24.0).isActive = true
        textView.widthAnchor.constraint(equalToConstant: 140).isActive = true
        
        let padding: CGFloat = 8
        textView.textContainerInset = UIEdgeInsets(top: 4, left: padding, bottom: 5, right: padding)
        
        return textView
    }()
    
    private lazy var newsTitle : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18.0, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 3
        label.textColor = .white
        label.text = "Why a third indictment of Trump could be such a profound stain on his legacy"
        
        return label
    }()
    
    private lazy var newsAuthor : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13.0, weight: .medium)
        label.textColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
        label.text = "Stephen Collinson, CNN"
        
        return label
    }()
    
    private lazy var newsPublished : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13.0, weight: .medium)
         label.textColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
        label.text = "Published 12:17 AM"
        
        return label
    }()
    
    private lazy var header3StackView : UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 5.0
        
        [
            newsAuthor,
            newsPublished,
        ].forEach { stackView.addArrangedSubview($0) }
        
        return stackView
    }()
    
    private lazy var todayLabel : UILabel = {
        let label = UILabel()
        label.text = "TODAY"
        label.font = .systemFont(ofSize: 24.0, weight: .semibold)
        
        return label
    }()
    
    private lazy var customNewsLabel : UILabel = {
        let label = UILabel()
        label.text = "ALL"
        label.font = .systemFont(ofSize: 14.0, weight: .semibold)
        label.textColor = .textColor
        
        return label
    }()
    
    func setupViews() {
        
        [
            headerImageView,
            breakingNews,
            newsTitle,
            header3StackView,
            todayLabel,
            customNewsLabel
        ].forEach { addSubview($0) }
        
        headerImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(294.0)
        }
        
        breakingNews.snp.makeConstraints {
            $0.top.equalTo(headerImageView.snp.top).inset(Inset.inset * 7)
            $0.leading.equalToSuperview().inset(Inset.inset * 2)
        }

        newsTitle.snp.makeConstraints {
            $0.top.equalTo(breakingNews.snp.bottom).offset(10.0)
            $0.leading.trailing.equalToSuperview().inset(Inset.inset * 2)
        }
        
        header3StackView.snp.makeConstraints {
            $0.top.equalTo(newsTitle.snp.bottom).offset(13.0)
            $0.leading.equalTo(newsTitle.snp.leading)
        }
        
        todayLabel.snp.makeConstraints {
            $0.top.equalTo(headerImageView.snp.bottom).offset(27.0)
            $0.leading.trailing.equalTo(36.0)
        }

        customNewsLabel.snp.makeConstraints {
            $0.top.equalTo(todayLabel.snp.bottom).offset(Inset.inset * 2)
            $0.leading.equalTo(todayLabel.snp.leading)
        }
    }
    
    func setDataServer() {
        self.fetchNewsData(completionHandler: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(result):
                
                self.updateHeaderImage(imageURL: "\(result.data.imageURL ?? "https://i.pinimg.com/564x/25/cb/0b/25cb0b4b31c9b5c0a82fbe15b4e10ad8.jpg")")
                self.newsTitle.text = result.data.title
                self.newsAuthor.text = "\(result.data.author ?? "author"), \(result.data.source)"
                self.newsPublished.text = self.updatePublishedTime(inputDateString: result.data.publishedAt)
            case let .failure(error):
                print("ERROR : \(error.localizedDescription)")
            }
          })
    }
    
    func updateHeaderImage(imageURL: String) {
        if let newImageURL = URL(string: imageURL) {
            headerImageView.kf.setImage(with: newImageURL)
        }
    }
    
    func updatePublishedTime(inputDateString : String) -> String{
        
        let formattedDateString = formatDateTime(inputDateString, fromFormat: "yyyy-MM-dd'T'HH:mm:ss", toFormat: "h:mm a")

        if let formattedDateString = formattedDateString {
            return "Published \(formattedDateString)"
        } else {
            print("Invalid date format")
            return "??"
        }
    }
}

private extension HomeCollectionHeaderView {
    func fetchNewsData(
      completionHandler: @escaping (Result <NewsTop, Error> ) -> Void
    ) {
        let url = NewsUrlCategory().POPULAR_NEWS_TOP_URL
   
      AF.request(url, method: .get)
          .responseData(completionHandler: { response in
          switch response.result {
          case let .success(data):
              do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(NewsTop.self, from: data)
                completionHandler(.success(result))
              } catch {
                completionHandler(.failure(error))
              }
          case let .failure(error):
            completionHandler(.failure(error))
          }
          }
        )
    }
}

