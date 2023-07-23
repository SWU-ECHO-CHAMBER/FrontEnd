//
//  TodayNewsCollectionViewCell.swift
//  EchoChamber
//
//  Created by 목정아 on 2023/07/20.
//

import UIKit
import SnapKit
import Kingfisher

class TodayNewsCollectionViewCell : UICollectionViewCell {
    
    static let identifier = "TodayNewsCollectionViewCell"
    let inset: CGFloat = Inset.inset
    
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 18.0
        imageView.layer.masksToBounds = true

        if let imageURL = URL(string: "https://media.cnn.com/api/v1/images/stellar/prod/230714140155-02-carlethia-nichole-russell.jpg?c=16x9&q=w_800,c_fill") {
            imageView.kf.setImage(with: imageURL)
        }

        return imageView
    }()

    
    private lazy var newsTitle: UILabel = {
        let label = UILabel()
        label.text = "Police share new details about the disappearance of Carlee Russell, the woman who went missing in Alabama after calling 911 about a child on an interstate"
        label.textColor = .titleTextColor
        label.font = .systemFont(ofSize: 15.0, weight: .semibold)
        
        label.numberOfLines = 3
        return label
    }()
    
    private lazy var newsDescription: UILabel = {
        let label = UILabel()
        label.text = "By Brad Lendon, CNN"
        label.textColor = .subTextColor
        label.font = .systemFont(ofSize: 12.0, weight: .regular)
        label.numberOfLines = 1
        
        return label
    }()
    
    private lazy var recommendationView : UIView = {
        let view = UIView()
        
        view.backgroundColor  = .mainColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 8.0).isActive = true
        view.widthAnchor.constraint(equalToConstant: 8.0).isActive = true
        
        return view
    }()
    
    private lazy var recommentLabel : UILabel = {
        let label = UILabel()
        label.text = "the reson of recommendation"
        label.font = .systemFont(ofSize: 12.0, weight: .regular)
        label.textColor = .systemGrayColor
        
        return label
    }()
    
    private lazy var recomendationStackView : UIStackView = {
      let stackView = UIStackView()
      stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
      stackView.spacing = 5.0
      
      [
        recommendationView,
        recommentLabel
      ].forEach { stackView.addArrangedSubview($0) }
      
      return stackView
    }()
        
    func setup() {
        self.setupLayout()
    }
    
    func setupServer(with newsData: News.NewsData) {
        self.newsTitle.text =  newsData.title
        self.newsDescription.text = "\(newsData.author ?? ""), \(newsData.source ?? "")"
        
        if let imageURL = URL(string: newsData.imageURL ?? "") {
            newsImageView.kf.setImage(with: imageURL)
        }
    }
}

private extension TodayNewsCollectionViewCell {
    func setupLayout() {
        [
            newsImageView,
            recomendationStackView,
            newsTitle,
            newsDescription
        ].forEach { addSubview($0) }
        
        newsImageView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.height.width.equalTo(104.0)
        }
        
        recomendationStackView.snp.makeConstraints {
            $0.top.equalTo(newsImageView.snp.top)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(202.0)
            $0.leading.equalTo(newsImageView.snp.trailing).offset(inset)
        }
        
        newsTitle.snp.makeConstraints {
            $0.top.equalTo(recomendationStackView.snp.bottom).offset(8.0)
            $0.leading.equalTo(recomendationStackView.snp.leading)
            $0.trailing.lessThanOrEqualToSuperview().inset(10.0)
        }
        
        newsDescription.snp.makeConstraints {
            $0.top.equalTo(newsTitle.snp.bottom).offset(5.0)
            $0.leading.equalTo(recomendationStackView.snp.leading)
            $0.bottom.equalTo(newsImageView.snp.bottom)
        }
    }
}

