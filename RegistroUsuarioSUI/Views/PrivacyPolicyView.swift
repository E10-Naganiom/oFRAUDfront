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
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Encabezado
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Aviso de Privacidad")
                            .font(.title.bold())
                        Text("oFraud - Red por la Ciberseguridad")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("Última actualización: 30/11/2023")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom, 10)
                    
                    Group {
                        Text("Causas para la Transformación A.C., mejor conocido como Red por la Ciberseguridad, con domicilio en calle Retorno al Ruiseñor 12, colonia Mayorazgos del Bosque, ciudad Atizapán de Zaragoza, municipio o delegación Atizapán de Zaragoza, c.p. 52957, en la entidad de México, país México, y portal de internet www.redporlaciberseguridad.org, es el responsable del uso y protección de sus datos personales.")
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Divider().padding(.vertical, 8)
                        
                        Text("¿Para qué fines utilizaremos sus datos personales?")
                            .font(.headline)
                            .padding(.top, 4)
                        
                        Text("Los datos personales que recabamos de usted, los utilizaremos para las siguientes finalidades que son necesarias para el servicio que solicita:")
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Label("Procesamiento de reportes de incidentes de ciberseguridad", systemImage: "checkmark.circle.fill")
                            Label("Investigación y análisis de incidentes reportados", systemImage: "checkmark.circle.fill")
                            Label("Envío de notificaciones sobre el estado de su reporte", systemImage: "checkmark.circle.fill")
                            Label("Contacto para seguimiento de casos", systemImage: "checkmark.circle.fill")
                        }
                        .font(.callout)
                        .foregroundColor(.primary)
                        
                        Text("De manera adicional, utilizaremos su información personal para las siguientes finalidades secundarias que no son necesarias para el servicio solicitado, pero que nos permiten y facilitan brindarle una mejor atención:")
                            .padding(.top, 8)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Label("Análisis estadístico de tendencias de ciberseguridad", systemImage: "chart.bar.fill")
                            Label("Mejora de servicios y funcionalidades de la plataforma", systemImage: "chart.bar.fill")
                            Label("Envío de información sobre programas de la organización", systemImage: "chart.bar.fill")
                            Label("Registros estadísticos de uso de la plataforma", systemImage: "chart.bar.fill")
                        }
                        .font(.callout)
                        .foregroundColor(.secondary)
                        
                        Text("La negativa para el uso de sus datos personales para estas finalidades secundarias no podrá ser un motivo para que le neguemos los servicios que solicita o contrata con nosotros.")
                            .font(.caption)
                            .foregroundColor(.orange)
                            .padding(.vertical, 8)
                        
                        Divider().padding(.vertical, 8)
                        
                        Text("¿Qué datos personales utilizaremos para estos fines?")
                            .font(.headline)
                            .padding(.top, 4)
                        
                        Text("Para llevar a cabo las finalidades descritas en el presente aviso de privacidad, utilizaremos los siguientes datos personales:")
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("• Datos de identificación (nombre completo)")
                            Text("• Datos de contacto (correo electrónico, teléfono)")
                            Text("• Datos del incidente (título, descripción, categoría)")
                            Text("• Información del atacante (nombre, red social involucrada)")
                            Text("• Evidencias (fotografías, documentos adjuntos)")
                            Text("• Datos técnicos (dirección IP, tipo de dispositivo)")
                        }
                        .font(.callout)
                        .foregroundColor(.primary)
                        
                        Divider().padding(.vertical, 8)
                        
                        Text("¿Con quién compartimos su información personal y para qué fines?")
                            .font(.headline)
                            .padding(.top, 4)
                        
                        Text("Le informamos que sus datos personales son compartidos dentro y fuera del país con las siguientes personas, empresas, organizaciones o autoridades distintas a nosotros, para los siguientes fines:")
                        
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(alignment: .top) {
                                Image(systemName: "building.2")
                                    .foregroundColor(.blue)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Instituto Nacional de Transparencia, Acceso a la Información y Protección de Datos Personales")
                                        .font(.callout.bold())
                                    Text("Finalidad: Estadísticas")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text("Requiere consentimiento: No")
                                        .font(.caption)
                                        .foregroundColor(.green)
                                }
                            }
                            
                            HStack(alignment: .top) {
                                Image(systemName: "server.rack")
                                    .foregroundColor(.blue)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Microsoft")
                                        .font(.callout.bold())
                                    Text("Finalidad: Estadísticas y servicios de infraestructura")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text("Requiere consentimiento: No")
                                        .font(.caption)
                                        .foregroundColor(.green)
                                }
                            }
                            
                            HStack(alignment: .top) {
                                Image(systemName: "server.rack")
                                    .foregroundColor(.blue)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Amazon Web Services")
                                        .font(.callout.bold())
                                    Text("Finalidad: Almacenamiento y estadísticas")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text("Requiere consentimiento: No")
                                        .font(.caption)
                                        .foregroundColor(.green)
                                }
                            }
                        }
                        .padding(.vertical, 8)
                        
                        Divider().padding(.vertical, 8)
                        
                        Text("¿Cómo puede acceder, rectificar o cancelar sus datos personales, u oponerse a su uso?")
                            .font(.headline)
                            .padding(.top, 4)
                        
                        Text("Usted tiene derecho a conocer qué datos personales tenemos de usted, para qué los utilizamos y las condiciones del uso que les damos (Acceso). Asimismo, es su derecho solicitar la corrección de su información personal en caso de que esté desactualizada, sea inexacta o incompleta (Rectificación); que la eliminemos de nuestros registros o bases de datos cuando considere que la misma no está siendo utilizada adecuadamente (Cancelación); así como oponerse al uso de sus datos personales para fines específicos (Oposición). Estos derechos se conocen como derechos ARCO.")
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "person.crop.circle.badge.checkmark")
                                    .foregroundColor(.green)
                                Text("Responsable: Oscar Ortega")
                                    .font(.callout.bold())
                            }
                            
                            HStack {
                                Image(systemName: "mappin.circle")
                                    .foregroundColor(.green)
                                VStack(alignment: .leading) {
                                    Text("Domicilio:")
                                        .font(.caption.bold())
                                    Text("Retorno Ruiseñor 12, Mayorazgos del Bosque")
                                        .font(.caption)
                                    Text("Atizapán de Zaragoza, México, C.P. 52957")
                                        .font(.caption)
                                }
                            }
                            
                            HStack {
                                Image(systemName: "envelope.circle")
                                    .foregroundColor(.green)
                                Text("ayuda@redporlaciberseguridad.org")
                                    .font(.callout)
                            }
                        }
                        .padding(.vertical, 8)
                        
                        Divider().padding(.vertical, 8)
                        
                        Text("Usted puede revocar su consentimiento para el uso de sus datos personales")
                            .font(.headline)
                            .padding(.top, 4)
                        
                        Text("Usted puede revocar el consentimiento que, en su caso, nos haya otorgado para el tratamiento de sus datos personales. Sin embargo, es importante que tenga en cuenta que no en todos los casos podremos atender su solicitud o concluir el uso de forma inmediata, ya que es posible que por alguna obligación legal requiramos seguir tratando sus datos personales.")
                        
                        Text("Para revocar su consentimiento, deberá presentar su solicitud a través del correo electrónico: ayuda@redporlaciberseguridad.org")
                            .padding(.vertical, 8)
                            .font(.callout)
                        
                        Divider().padding(.vertical, 8)
                        
                        Text("Uso de tecnologías de rastreo")
                            .font(.headline)
                            .padding(.top, 4)
                        
                        Text("Le informamos que en nuestra plataforma utilizamos cookies, web beacons u otras tecnologías, a través de las cuales es posible monitorear su comportamiento como usuario, así como brindarle un mejor servicio y experiencia al navegar.")
                        
                        Text("Los datos personales que obtenemos de estas tecnologías incluyen:")
                            .padding(.top, 8)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("• Identificadores y credenciales de sesión")
                            Text("• Tipo de navegador y sistema operativo")
                            Text("• Región del usuario")
                            Text("• Páginas visitadas dentro de la plataforma")
                            Text("• Fecha y hora de inicio y final de sesión")
                        }
                        .font(.callout)
                        .foregroundColor(.primary)
                        
                        Divider().padding(.vertical, 8)
                        
                        Text("¿Cómo puede conocer los cambios en este aviso de privacidad?")
                            .font(.headline)
                            .padding(.top, 4)
                        
                        Text("El presente aviso de privacidad puede sufrir modificaciones, cambios o actualizaciones derivadas de nuevos requerimientos legales; de nuestras propias necesidades por los productos o servicios que ofrecemos; de nuestras prácticas de privacidad; de cambios en nuestro modelo de negocio, o por otras causas.")
                        
                        Text("Nos comprometemos a mantenerlo informado sobre los cambios que pueda sufrir el presente aviso de privacidad, a través de nuestra página web y notificaciones dentro de la plataforma.")
                            .padding(.vertical, 8)
                        
                        Divider().padding(.vertical, 8)
                        
                        Text("Reportes Anónimos")
                            .font(.headline)
                            .padding(.top, 4)
                        
                        Text("oFraud respeta su derecho a la privacidad. Si marca su reporte como \"anónimo\", su nombre no aparecerá en el reporte público. Solo nuestro equipo de investigación autorizado tendrá acceso a su identidad en caso de ser necesario contactarle para el seguimiento del caso.")
                        
                        Text("**Aceptación del Aviso**")
                            .font(.headline)
                            .padding(.top, 8)
                        
                        Text("Al usar oFraud, usted acepta el tratamiento de sus datos personales conforme a este Aviso de Privacidad. Si no está de acuerdo, por favor no utilice la plataforma.")
                            .foregroundColor(.red)
                    }
                    .font(.callout)
                }
                .padding()
            }
            .navigationTitle("Aviso de Privacidad")
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

#Preview {
    PrivacyPolicyView(isPresented: .constant(true))
}
