//
//  Attachment.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//

import Foundation
import SwiftUI
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

enum AttachmentType: String, Codable {
    case image
    case pdf
    case document
}
