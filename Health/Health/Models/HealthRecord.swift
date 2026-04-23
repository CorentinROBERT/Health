//
//  HealthRecord.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//

import Foundation
import SwiftData

@Model
final class HealthRecord {
    var id: UUID
    var date: Date
    var type: HealthRecordType
    
    var title: String
    var details: String
    
    var doctorName: String?
    var location: String?
    
    var attachments: [Attachment] = []
    
    init(date: Date, type: HealthRecordType, title: String, details: String) {
        self.id = UUID()
        self.date = date
        self.type = type
        self.title = title
        self.details = details
    }
}
