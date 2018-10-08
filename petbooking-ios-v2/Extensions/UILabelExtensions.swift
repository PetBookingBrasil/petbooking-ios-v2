//
//  UILabelExtensions.swift
//  petbooking-ios-v2
//
//  Created by Enrique Melgarejo on 01/09/18.
//  Copyright © 2018 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit

extension UILabel {
  @IBInspectable var kern: Float {
    get {
      // get not supported
      return 0
    }
    set {
      if let attributedText = self.attributedText {
        let attrStr = NSMutableAttributedString(attributedString: attributedText)
        let range = NSRange(location: 0, length: attributedText.length)
        attrStr.addAttribute(NSAttributedStringKey.kern, value: newValue, range: range)
        self.attributedText = attrStr
      }
    }
  }

  func set(text: String, lineHeight: CGFloat, alignment: NSTextAlignment = .natural, lineBreakMode: NSLineBreakMode? = nil, lineSpacing: CGFloat? = nil) {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.minimumLineHeight = lineHeight
    paragraphStyle.maximumLineHeight = lineHeight
    paragraphStyle.alignment = alignment

    if let lineBreakMode = lineBreakMode {
      paragraphStyle.lineBreakMode = lineBreakMode
    }

    if let lineSpacing = lineSpacing {
      paragraphStyle.lineSpacing = lineSpacing
    }

    let attributedString = NSMutableAttributedString(string: text)
    attributedString.addAttribute(NSAttributedStringKey.paragraphStyle,
                                  value: paragraphStyle,
                                  range: NSRange(location: 0, length: attributedString.length))

    self.attributedText = attributedString
  }
}

