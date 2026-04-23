//
//  HealthRecordType.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//

import Foundation
enum HealthRecordType: String, Codable {
    case treatment
    case surgery
    case illness
    case consultation
    case exam
}
