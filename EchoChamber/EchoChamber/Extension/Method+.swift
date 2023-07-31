//
//  Method+.swift
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

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var formattedHex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        if formattedHex.count == 3 {
            formattedHex = formattedHex.map { "\($0)\($0)" }.joined()
        }
        
        if formattedHex.count == 6 {
            var rgbValue: UInt64 = 0
            Scanner(string: formattedHex).scanHexInt64(&rgbValue)
            
            let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
            let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
            
            self.init(red: red, green: green, blue: blue, alpha: alpha)
        } else {
            self.init(white: 1.0, alpha: alpha)
        }
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

// 문자열 -> 데이터포맷
func formatStringToDateTime(_ dateString: String, format: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.date(from: dateString)
}


