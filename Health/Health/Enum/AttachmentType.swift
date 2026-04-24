//
//  AttachmentType.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//

import Foundation

enum AttachmentType: String, Codable {
    case image
    case pdf
    case document
}

extension AttachmentType {
    var systemImage: String {
        switch self {
        case .image:
            return "photo"
        case .pdf:
            return "doc.richtext"
        case .document:
            return "doc"
        }
    }
}
