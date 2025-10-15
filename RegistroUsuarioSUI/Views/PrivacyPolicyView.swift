//
//  PrivacyPolicyView.swift
//  RegistroUsuarioSUI
//
//  Created by Omar Llano on 14/10/25.
//

import SwiftUI

struct PrivacyPolicyView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    
                    // Encabezado
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Política de Privacidad - oFraud")
                            .font(.title2.bold())
                        Text("Red por la Ciberseguridad")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("Última actualización: Octubre 2025")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom, 10)
                    
                    Group {
                        Text("**1. Introducción**")
                        Text("En oFraud (\"nosotros\", \"nuestro\" o \"la Organización\"), nos comprometemos con la protección de tu privacidad y datos personales. Esta Política de Privacidad explica cómo recopilamos, usamos, compartimos y protegemos tu información cuando utilizas nuestra plataforma de reportes de incidentes de ciberseguridad.")
                        
                        Text("**2. Información que Recopilamos**")
                        Text("2.1 **Información de Registro**\n- Nombre completo\n- Apellido\n- Correo electrónico\n- Contraseña (encriptada)\n- Información de verificación de identidad\n\n2.2 **Información de Reportes**\nCuando levantas un reporte de incidente, recopilamos:\n- Título y descripción del incidente\n- Categoría del incidente\n- Información de contacto (teléfono, correo, usuario de redes sociales)\n- Nombre del presunto atacante\n- Red social involucrada\n- Archivos adjuntos como evidencia (fotos, documentos)\n- Fecha y hora del reporte\n\n2.3 **Información Técnica**\n- Dirección IP\n- Tipo de dispositivo y sistema operativo\n- Historial de navegación dentro de la plataforma\n- Cookies y datos de sesión\n\n2.4 **Información Voluntaria**\n- Cualquier información adicional que proporciones en encuestas, comentarios o consultas de soporte.")
                        
                        Text("**3. Cómo Usamos tu Información**")
                        Text("Utilizamos los datos que recopilas para:\n- Procesar y investigar reportes de ciberseguridad\n- Mejorar la respuesta ante incidentes\n- Prevenir fraudes y abusos en la plataforma\n- Personalizar tu experiencia en oFraud\n- Enviar notificaciones sobre el estado de tu reporte\n- Cumplir con obligaciones legales y regulatorias\n- Analizar tendencias de ciberseguridad en México\n- Mejorar nuestros servicios y la plataforma\n- Contactarte con información relevante sobre seguridad digital")
                        
                        Text("**4. Base Legal para el Tratamiento de Datos**")
                        Text("El tratamiento de tus datos se realiza con base en:\n- Tu consentimiento explícito (al registrarte y aceptar esta política)\n- La ejecución de nuestro acuerdo de servicios\n- Intereses legítimos en proteger la ciberseguridad\n- Cumplimiento de obligaciones legales")
                        
                        Text("**5. Compartición de Información**")
                        Text("Tu información NO será compartida con terceros sin tu consentimiento, excepto:\n- **Autoridades competentes:** Si lo requiere la ley o una orden judicial\n- **Personal de investigación:** Miembros de oFraud que investigan tu reporte\n- **Proveedores de servicios:** Que procesan datos bajo contrato (hosting, correo)\n- **Organismos de ciberseguridad:** En caso de amenazas críticas a la seguridad nacional\n\nEn ningún caso vendemos o alquilamos información personal a terceros para marketing.")
                        
                        Text("**6. Retención de Datos**")
                        Text("• Reportes: Se mantienen durante 5 años o mientras sea necesario para investigación\n• Datos de cuenta: Se retienen mientras mantengas tu cuenta activa\n• Datos técnicos: Se eliminan después de 12 meses\n• Información de contacto: Puedes solicitar su eliminación en cualquier momento")
                        
                        Text("**7. Protección de Datos**")
                        Text("Implementamos medidas de seguridad técnicas y organizativas:\n- Encriptación SSL/TLS para transmisión de datos\n- Contraseñas encriptadas con algoritmos seguros\n- Acceso restringido a información sensible\n- Auditorías de seguridad regulares\n- Política de retención de datos mínimos necesarios\n\nSin embargo, ningún sistema es 100% seguro. No podemos garantizar seguridad absoluta.")
                        
                        Text("**8. Tus Derechos**")
                        Text("Bajo la legislación mexicana (Ley Federal de Protección de Datos Personales), tienes derecho a:\n- **Acceso:** Conocer qué datos personales tenemos de ti\n- **Rectificación:** Corregir información inexacta\n- **Cancelación:** Solicitar la eliminación de tus datos\n- **Oposición:** Rechazar ciertos usos de tu información\n- **Portabilidad:** Recibir tus datos en formato legible\n\nPara ejercer estos derechos, contacta a: **privacidad@oFraud.org**")
                        
                        Text("**9. Reporte de Incidentes de Privacidad**")
                        Text("Si detectas un uso indebido de tus datos personales, reporta inmediatamente a:\n**Centro de Derechos Digitales y Ciberseguridad**\nEmail: **incidentes@oFraud.org**\nTeléfono: **(52) 55 1234 6789**")
                        
                        Text("**10. Reportes Anónimos**")
                        Text("oFraud respeta tu privacidad. Puedes:\n- Marcar tu reporte como \"anónimo\" durante el registro\n- Tu nombre no aparecerá en el reporte público\n- Solo nuestro equipo de investigación verá tu identidad si es necesario para contactarte")
                        
                        Text("**11. Cambios en esta Política**")
                        Text("oFraud puede actualizar esta Política de Privacidad ocasionalmente. Te notificaremos sobre cambios significativos por email o un aviso destacado en la plataforma.")
                        
                        Text("**12. Contacto**")
                        Text("Si tienes preguntas sobre esta Política de Privacidad o nuestras prácticas de datos:\n**Red por la Ciberseguridad**\nEmail: **privacidad@oFraud.org**\nTeléfono: **(52) 55 1234 6789**\nWeb: **https://oFraud.org/privacidad**\nHorario: **Lunes a Viernes, 9:00 AM - 6:00 PM**")
                        
                        Text("**Aceptación de la Política**")
                        Text("Al usar oFraud, aceptas el tratamiento de tus datos personales conforme a esta Política de Privacidad. Si no estás de acuerdo, por favor no utilices la plataforma.")
                        
                        Text("**Aviso de Cumplimiento Normativo**")
                        Text("Esta política cumple con:\n- Ley Federal de Protección de Datos Personales en Posesión de Particulares (México)\n- NOM-086-SCFI-2016\n- Estándares internacionales de privacidad de datos")
                    }
                    .font(.callout)
                    .foregroundColor(.primary)
                }
                .padding()
            }
            .navigationTitle("Política de Privacidad")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") {
                        isPresented = false
                    }
                    .foregroundColor(.green)
                }
            }
        }
    }
}


