//
//  Extension.swift
//  Algorithm
//
//  Created by tosru on 2020/04/26
//  ©︎ 2020 tosru
//

import UIKit

extension UIFont {
  static func hiramaru(size: CGFloat) -> UIFont? {
    return UIFont(name: "HiraMaruProN-W4", size: size)
  }
}

extension UIColor {
  static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
    return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
  }
}
