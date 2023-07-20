//
//  DetailNewsViewController.swift
//  EchoChamber
//
//  Created by 목정아 on 2023/07/21.
//

import UIKit
import SnapKit
import Kingfisher

class DetailNewsViewController : UIViewController {
    
    let inset: CGFloat = Inset.inset
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18.0, weight: .semibold)
        label.textColor = .textColor
        label.text = "Police share new details about the disappearance of Carlee Russell, the woman who went missing in Alabama after calling 911 about a child on an interstate"
        
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13.0, weight: .regular)
        label.textColor = .subTextColor
        label.text = "By Brad Lendon, CNN"
        
        return label
    }()
    
    private lazy var publishedLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13.0, weight: .regular)
        label.textColor = .subTextColor
        label.text = "Published 12:17 AM"
        
        return label
    }()
    
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = true
        
        if let imageURL = URL(string: "https://media.cnn.com/api/v1/images/stellar/prod/230714140155-02-carlethia-nichole-russell.jpg?c=16x9&q=w_800,c_fill") {
            imageView.kf.setImage(with: imageURL)
        }
        
        return imageView
    }()
    
    private lazy var newsTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18.0, weight: .semibold)
        label.textColor = .textColor
        label.numberOfLines = 0
        label.text = "contentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontent contentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontentcontent"
    
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigation()
        self.setupLayout()
    }
    
}

private extension DetailNewsViewController {
    
    func setupNavigation() {
        
        let bookmarkButton = UIBarButtonItem(image: UIImage(systemName: "bookmark"), style: .plain, target: self, action: #selector(didTapBookmarkButton))
        
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(didTapShareButton))
        
        navigationItem.rightBarButtonItems = [shareButton, bookmarkButton]
    }
    
    func setupLayout() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
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
            $0.height.equalToSuperview()
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
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailing.equalTo(titleLabel.snp.trailing)
            $0.height.equalTo(245.0)
            $0.width.equalTo(titleLabel.snp.width)
        }

        newsTextLabel.snp.makeConstraints {
            $0.top.equalTo(newsImageView.snp.bottom).offset(20.0)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailing.equalTo(titleLabel.snp.trailing)
            $0.width.equalTo(titleLabel.snp.width)
        }
    }
    
}

private extension DetailNewsViewController {
    
    @objc func didTapBookmarkButton() {
        print("Bookmark")
    }
    
    @objc func didTapShareButton() {
        let activityItems: [Any] = ["Echo Chamber"]
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        present(activityVC, animated: true)
    }
}
