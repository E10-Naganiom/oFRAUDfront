//
//  EnvironmentExtension.swift
//  RegistroUsuarioSUI
//
//  Created by Usuario on 29/08/25.
//

import Foundation
import SwiftUI

extension EnvironmentValues {
    @Entry var authController = AuthenticationController(httpClient: HTTPClient())
}
