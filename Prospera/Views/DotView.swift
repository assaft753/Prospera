//
//  DotView.swift
//  Prospera
//
//  Created by Assaf Tayouri on 09/12/2020.
//

import UIKit

// Inspectable circle view
@IBDesignable
class DotView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
}
