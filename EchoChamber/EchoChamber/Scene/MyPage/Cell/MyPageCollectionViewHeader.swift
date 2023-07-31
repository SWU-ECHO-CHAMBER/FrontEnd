//
//  MyPageCollectionViewHeader.swift
//  EchoChamber
//
//  Created by 목정아 on 2023/07/23.
//

import UIKit
import SnapKit

protocol MyPageCollectionViewHeaderDelegate: AnyObject {
    func didTapEditButton()
}

class MyPageCollectionViewHeader : UICollectionReusableView {
    
    static let identifier = "MyPageCollectionViewHeader"
    let inset : CGFloat = Inset.inset
    
    private let separatorView = SeparatorView(frame: .zero)
    
    weak var delegate: MyPageCollectionViewHeaderDelegate?
    
    private lazy var userProfileImageView : UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.widthAnchor.constraint(equalToConstant: 90.0).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 90.0).isActive = true

        return imageView
    }()
    
    private lazy var userNameLabel : UILabel = {
        let label = UILabel()
        label.text = UserDefaults.standard.string(forKey: "Nickname") ?? "Your Name"
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
    
    private lazy var bookmarkArticleButton : UIButton = {
        
        let button = UIButton()
        button.setTitle("Bookmark Articles", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13.0, weight: .semibold)
        button.setTitleColor(.mainColor, for: .normal)
        button.addTarget(self, action: #selector(didTapBookmarkButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var recentArticleButton : UIButton = {
        let button = UIButton()
        button.setTitle("Recent Articles", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13.0, weight: .semibold)
        button.setTitleColor(.systemGrayColor, for: .normal)
        button.addTarget(self, action: #selector(didTapRecentAtricleButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var articleLabelStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20.0
        stackView.distribution = .equalSpacing
        
        [
            bookmarkArticleButton,
            recentArticleButton
        ].forEach { stackView.addArrangedSubview($0) }
        
        return stackView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.userProfileImageView.layer.cornerRadius = userProfileImageView.frame.size.width / 2
    }
    
    func setup() {
        self.setupLayout()
        self.userNameLabel.text = UserDefaults.standard.string(forKey: "Nickname") ?? "Your Name"
        
        guard let email = UserDefaults.standard.string(forKey: "Email") else { return }
        let imagePath = "/Users/mokjeong-a/Desktop/Images/ECHO_Image/\(email).jpeg"
        
        if let image = UIImage(contentsOfFile: imagePath) {
            self.userProfileImageView.image = image
        } else {
            self.userProfileImageView.image = UIImage(named: "MyProfile")
        }
    }
}

private extension MyPageCollectionViewHeader {
    
    @objc func didTapRecentAtricleButtonTapped() {
        self.bookmarkArticleButton.setTitleColor(.systemGrayColor, for: .normal)
        self.recentArticleButton.setTitleColor(.mainColor, for: .normal)
    }
    
    @objc func didTapBookmarkButtonTapped() {
        self.bookmarkArticleButton.setTitleColor(.mainColor, for: .normal)
        self.recentArticleButton.setTitleColor(.systemGrayColor, for: .normal)
    }
    
    @objc func didTapEditButton() {
        delegate?.didTapEditButton()
    }
}

private extension MyPageCollectionViewHeader {
    
    func setupLayout() {
        [
            userProfileImageView,
            userNameLabel,
            editButton,
            separatorView,
            articleLabelStackView,
        ].forEach {  addSubview($0) }
        
        userProfileImageView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(inset*3)
            $0.centerX.equalTo(safeAreaLayoutGuide)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(userProfileImageView.snp.bottom).offset(inset)
            $0.centerX.equalTo(userProfileImageView.snp.centerX)
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
        
        articleLabelStackView.snp.makeConstraints {
            $0.top.equalTo(separatorView).inset(35.0)
            $0.leading.equalToSuperview().inset(36.0)
        }
    }
}
