//
//  String+extensions.swift
//  NativeWeatherApp
//
//  Created by Роман Власов on 26.10.23.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
