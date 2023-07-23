//
//  Extension+.swift
//  EchoChamber
//
//  Created by 목정아 on 2023/07/21.
//

import UIKit

extension UIImage {
    func resize(to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        self.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage ?? self
    }
}

func formatDateTime(_ inputDateString: String, fromFormat: String, toFormat: String) -> String? {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = fromFormat

    if let date = inputFormatter.date(from: inputDateString) {
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = toFormat
        return outputFormatter.string(from: date)
    } else {
        return nil
    }
}

