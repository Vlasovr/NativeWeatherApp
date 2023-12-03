//
//  LocationAssembly.swift
//  NativeWeatherApp
//
//  Created by Роман Власов on 28.11.23.
//

import UIKit

final class GettingStartedAssembly {
    func assemble() -> UIViewController {
        let viewModel = GettingStartedViewModel()
        return GettingStartedController(viewModel: viewModel)
    }
}
