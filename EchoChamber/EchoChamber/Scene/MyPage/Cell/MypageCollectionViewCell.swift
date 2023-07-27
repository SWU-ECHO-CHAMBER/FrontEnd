//
//  MypageCollectionViewCell.swift
//  EchoChamber
//
//  Created by 목정아 on 2023/07/22.
//

import UIKit
import SnapKit
import Kingfisher

class MypageCollectionViewCell : UICollectionViewCell {
    
    static let identifier = "MypageCollectionViewCell"
    
    private let inset : CGFloat = Inset.inset
    
    private lazy var cellImageView : UIImageView = {
        let imageView = UIImageView()
        
        if let imageURL = URL(string: "https://media.cnn.com/api/v1/images/stellar/prod/230719105428-trump-nevada-0708.jpg?c=16x9&q=w_800,c_fill"){
            imageView.kf.setImage(with: imageURL)
        }
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 18.0
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.text = "???"
        label.font = .systemFont(ofSize: 15.0, weight: .semibold)
        label.textColor = .textColor
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        
        return label
    }()
    
    private lazy var subtitleLabel : UILabel = {
        let label = UILabel()
        label.text = "???, ??? |  ???"
        label.font = .systemFont(ofSize: 12.0, weight: .regular)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = #colorLiteral(red: 0.5180020332, green: 0.5180020332, blue: 0.5180020332, alpha: 1)
        
        return label
    }()
    
    func setup() {
        self.setupLayout()
    }
    
    func setupServer(with newsData: Bookmark.BookmarkDataClass) {
        
        if let imageURL = URL(string: newsData.imageURL ) {
            self.cellImageView.kf.setImage(with: imageURL)
        }
        self.titleLabel.text = newsData.title
        let inputDateString = newsData.publishedAt
        self.subtitleLabel.text = "By \(newsData.author), \(newsData.source) | \(self.formatDateTimeWithRelativeString(newsData.publishedAt, format: "yyyy년 MM월 d일"))"
    }
    
}

private extension MypageCollectionViewCell {
    func setupLayout() {
        [
            cellImageView,
            titleLabel,
            subtitleLabel
        ].forEach { addSubview($0) }
        
        cellImageView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.height.equalTo(99.0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(cellImageView.snp.top)
            $0.leading.equalTo(cellImageView.snp.trailing).offset(inset)
            $0.trailing.lessThanOrEqualToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(7.0)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailing.lessThanOrEqualToSuperview()
            $0.bottom.equalTo(cellImageView.snp.bottom)
        }
    }
    
    func isDateToday(_ date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDateInToday(date)
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
