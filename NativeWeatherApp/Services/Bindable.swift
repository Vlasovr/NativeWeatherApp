//
//  Bindable.swift
//  NativeWeatherApp
//
//  Created by Роман Власов on 3.12.23.
//

import Foundation

class Bindable<T> {
  typealias Listener = (T) -> Void

  var value: T {
    didSet {
      listener?(value)
    }
  }
    
  private var listener: Listener?

  init(_ value: T) {
    self.value = value
  }

  func bind(_ listener: Listener?) {
    self.listener = listener
    listener?(value)
  }
}
