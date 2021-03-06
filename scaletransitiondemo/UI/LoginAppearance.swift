//
//
//  LoginAppearance.swift
//
// Copyright (c) 21/02/16. Alex K  (dev.aleksey@yandex.ru)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


import Foundation
import UIKit


// MARK: textField

protocol PlaceholderColor {
  func placeholderColor(color: UIColor)
}

extension PlaceholderColor where Self: UITextField {
  func placeholderColor(color: UIColor) {
    if let placeholder = placeholder {
      attributedPlaceholder = NSAttributedString(string: placeholder,
        attributes:[NSForegroundColorAttributeName : UIColor.white])
    }
  }
}

class WhiteTextField: UITextField, PlaceholderColor {
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    placeholderColor(color: .white)
  }
}

protocol Bordered {
  func borderWidth(width: Float, color: UIColor)
}

extension Bordered where Self: UIView {
  func borderWidth(width: Float, color: UIColor) {
    layer.borderColor = color.cgColor
    layer.borderWidth = CGFloat(width)
  }
}

class CountinueButton: UIButton, Bordered {
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    borderWidth(width: 2, color: UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0.3))
    backgroundColor = .clear
  }
}
