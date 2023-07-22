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
