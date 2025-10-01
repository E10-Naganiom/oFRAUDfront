//
//  ProfileObs.swift
//  RegistroUsuarioSUI
//
//  Created by Usuario on 17/09/25.
//

import Foundation
import Observation

@Observable
class ProfileObs{
    var id: Int = 0
    var nombre: String = ""
    var apellido: String = ""
    var email: String = ""
    var contrasena: String = ""
}
