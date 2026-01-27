//
//  Asset.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import Foundation
import SwiftData

/// Represents an asset in the project (image, color, SF Symbol, or font)
@Model
final class Asset {
    @Attribute(.unique) var id: UUID
    var name: String
    var assetType: AssetType
    var createdAt: Date
    var modifiedAt: Date

    // For image assets
    @Attribute(.externalStorage)
    var imageData: Data?

    // For color assets
    var colorHex: String?            // Hex color value (e.g., "#FF5733")
    var colorOpacity: Double?        // Opacity (0.0 to 1.0)

    // For SF Symbol assets
    var sfSymbolName: String?        // SF Symbol name (e.g., "star.fill")
    var sfSymbolWeight: String?      // Symbol weight
    var sfSymbolScale: String?       // Symbol scale

    // For custom font assets
    var fontFileName: String?        // Font file name
    @Attribute(.externalStorage)
    var fontData: Data?

    // Relationship to project
    var project: Project?

    init(
        id: UUID = UUID(),
        name: String,
        assetType: AssetType
    ) {
        self.id = id
        self.name = name
        self.assetType = assetType
        self.createdAt = Date()
        self.modifiedAt = Date()
    }

    // MARK: - Convenience Initializers

    static func image(name: String, data: Data) -> Asset {
        let asset = Asset(name: name, assetType: .image)
        asset.imageData = data
        return asset
    }

    static func color(name: String, hex: String, opacity: Double = 1.0) -> Asset {
        let asset = Asset(name: name, assetType: .color)
        asset.colorHex = hex
        asset.colorOpacity = opacity
        return asset
    }

    static func sfSymbol(name: String, symbolName: String, weight: String? = nil, scale: String? = nil) -> Asset {
        let asset = Asset(name: name, assetType: .sfSymbol)
        asset.sfSymbolName = symbolName
        asset.sfSymbolWeight = weight
        asset.sfSymbolScale = scale
        return asset
    }

    static func font(name: String, fileName: String, data: Data) -> Asset {
        let asset = Asset(name: name, assetType: .customFont)
        asset.fontFileName = fileName
        asset.fontData = data
        return asset
    }

    // MARK: - Code Generation

    func toSwiftCode() -> String {
        switch assetType {
        case .image:
            return "Image(\"\(name)\")"
        case .color:
            if let hex = colorHex {
                return "Color(hex: \"\(hex)\")"
            }
            return "Color(\"\(name)\")"
        case .sfSymbol:
            if let symbolName = sfSymbolName {
                return "Image(systemName: \"\(symbolName)\")"
            }
            return "Image(systemName: \"\(name)\")"
        case .customFont:
            if let fileName = fontFileName {
                return "Font.custom(\"\(fileName)\", size: 16)"
            }
            return "Font.custom(\"\(name)\", size: 16)"
        }
    }

    // MARK: - Update

    func markModified() {
        modifiedAt = Date()
    }
}
