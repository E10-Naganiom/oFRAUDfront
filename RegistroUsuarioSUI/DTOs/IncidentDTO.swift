//
//  IncidentDTO.swift
//  RegistroUsuarioSUI
//
//  Created by Usuario on 17/09/25.
//
 import Foundation

struct Incident: Identifiable, Decodable{
    let id: Int
    let title: String
    let status: String
    let createdAt: Date
    let lastUpdated: Date
    let attachments: Int
}
