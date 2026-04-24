//
//  HealthRecordType.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//

import Foundation

enum HealthRecordType: String, Codable, CaseIterable {
    case treatment
    case surgery
    case illness
    case consultation
    case exam
}

extension HealthRecordType {
    var displayName: String {
        switch self {
        case .treatment:
            return "Traitement"
        case .surgery:
            return "Chirurgie"
        case .illness:
            return "Maladie"
        case .consultation:
            return "Consultation"
        case .exam:
            return "Examen"
        }
    }
}
