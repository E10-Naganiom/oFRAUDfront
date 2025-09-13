//
//  EnvironmentExtension.swift
//  RegistroUsuarioSUI
//
//  Created by Usuario on 29/08/25.
//

import Foundation
import SwiftUICore

extension EnvironmentValues {
    @Entry var authController = AuthenticationController(httpClient: HTTPClient())
    @Entry var profileController = ProfileController(httpClient: HTTPClient())
}
