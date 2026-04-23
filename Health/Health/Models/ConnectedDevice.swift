import SwiftData
import Foundation

@Model
final class ConnectedDevice {
    var id: UUID
    
    var name: String
    var type: DeviceType
    
    var brand: String?
    var isConnected: Bool
    
    init(name: String, type: DeviceType) {
        self.id = UUID()
        self.name = name
        self.type = type
        self.isConnected = false
    }
}
