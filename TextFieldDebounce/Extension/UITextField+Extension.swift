//
//  UITextField+Extension.swift
//  TextFieldDebounce
//
//  Created by Min-Su Kim on 2022/09/09.
//

import Foundation
import UIKit
import Combine

extension UITextField {
  var textDidChange: AnyPublisher<String, Never> {
    NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
      .compactMap { $0.object as? UITextField }
      .map { $0.text ?? "" }
      .eraseToAnyPublisher()
  }
}
