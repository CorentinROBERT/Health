//
//  Attachment.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//

import Foundation
import SwiftData

@Model
final class Attachment {
    var id: UUID
    var fileName: String
    var fileURL: String
    var type: AttachmentType
    
    init(fileName: String, fileURL: String, type: AttachmentType) {
        self.id = UUID()
        self.fileName = fileName
        self.fileURL = fileURL
        self.type = type
    }
}
