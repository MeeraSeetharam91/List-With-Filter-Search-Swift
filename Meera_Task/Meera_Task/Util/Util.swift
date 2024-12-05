//
//  Util.swift
//  Meera_Task
//
//  Created by Meera Seetharam on 04/12/24.
//

import Foundation
import UIKit

extension String {
    func size(with font: UIFont) -> CGSize {
        let fontAttribute = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttribute)
        return size
    }
}

extension UIView {
    public class var identifier: String {
        var name = NSStringFromClass(self)
        name = name.components(separatedBy: ".").last ?? ""
        return name
    }
}
