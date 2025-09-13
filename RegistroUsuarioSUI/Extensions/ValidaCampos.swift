//
//  ValidaCampos.swift
//  RegistroUsuarioSUI
//
//  Created by Usuario on 22/08/25.
//

import Foundation

extension String {
    var esVacío: Bool {   //Variable computada
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var esPasswordValido: Bool {
        return self.count >= 8
    }
    
    var esCorreoValido: Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}
