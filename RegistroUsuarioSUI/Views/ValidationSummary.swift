//
//  ValidationSummary.swift
//  RegistroUsuarioSUI
//
//  Created by Usuario on 22/08/25.
//

import SwiftUI

struct ValidationSummary: View {
    var errors: [String] = []
    var body: some View {
        VStack{
            if errors.isEmpty {
                Text("No hay errores")
                    .foregroundStyle(.green)
            }
            else{
                ForEach(errors, id: \.self){error in
                    Text("- \(error)")
                        .foregroundStyle(.red).frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .padding()
    }
}

#Preview {
    ValidationSummary()
}
