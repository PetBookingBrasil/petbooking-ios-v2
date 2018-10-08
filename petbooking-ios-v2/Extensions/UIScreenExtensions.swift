//
//  UIScreenExtensions.swift
//  petbooking-ios-v2
//
//  Created by Enrique Melgarejo on 01/09/18.
//  Copyright © 2018 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit

enum SizeType: CGFloat {
  case Unknown = 0.0
  case iPhone4 = 960.0
  case iPhone5 = 1136.0
  case iPhone6 = 1334.0
  case iPhone6Plus = 1920.0
}

extension UIScreen {
  var sizeType: SizeType {
    let height = nativeBounds.height
    guard let sizeType = SizeType(rawValue: height) else { return .Unknown }
    return sizeType
  }
}
