//
//  FunctionParameter.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import Foundation
import SwiftData

/// Represents a function parameter (shared between ViewFunction and QueryFunction)
@Model
final class FunctionParameter {
    @Attribute(.unique) var id: UUID
    var externalName: String?      // External parameter name (can be "_" to omit)
    var internalName: String       // Internal parameter name
    var typeDefinitionData: Data?
    var defaultValue: String?      // Default value as string (code representation)
    var isVariadic: Bool           // Whether this is a variadic parameter
    var isInout: Bool              // Whether this parameter is inout
    var sortOrder: Int

    // Relationships (optional - parameter can belong to either)
    var viewFunction: ViewFunction?
    var queryFunction: QueryFunction?

    // Computed accessor for TypeDefinition
    var typeDefinition: TypeDefinition {
        get {
            guard let data = typeDefinitionData,
                  let decoded = try? JSONDecoder().decode(TypeDefinition.self, from: data) else {
                return .any
            }
            return decoded
        }
        set {
            typeDefinitionData = try? JSONEncoder().encode(newValue)
        }
    }

    init(
        id: UUID = UUID(),
        externalName: String? = nil,
        internalName: String,
        typeDefinition: TypeDefinition,
        defaultValue: String? = nil,
        isVariadic: Bool = false,
        isInout: Bool = false,
        sortOrder: Int = 0
    ) {
        self.id = id
        self.externalName = externalName
        self.internalName = internalName
        self.typeDefinitionData = try? JSONEncoder().encode(typeDefinition)
        self.defaultValue = defaultValue
        self.isVariadic = isVariadic
        self.isInout = isInout
        self.sortOrder = sortOrder
    }

    // MARK: - Display

    var displayName: String {
        if let external = externalName {
            if external == "_" {
                return internalName
            } else if external == internalName {
                return internalName
            } else {
                return "\(external) \(internalName)"
            }
        }
        return internalName
    }

    var signature: String {
        var result = ""

        // External name
        if let external = externalName {
            if external != internalName {
                result += "\(external) "
            }
        }

        // Internal name
        result += internalName

        // Type
        result += ": "

        if isInout {
            result += "inout "
        }

        result += typeDefinition.toSwiftCode()

        if isVariadic {
            result += "..."
        }

        // Default value
        if let defaultValue = defaultValue {
            result += " = \(defaultValue)"
        }

        return result
    }

    // MARK: - Code Generation

    func toSwiftCode() -> String {
        var result = ""

        // External name handling
        if let external = externalName {
            if external == "_" {
                result += "_ "
            } else if external != internalName {
                result += "\(external) "
            }
        }

        // Internal name and type
        result += "\(internalName): "

        if isInout {
            result += "inout "
        }

        result += typeDefinition.toSwiftCode()

        if isVariadic {
            result += "..."
        }

        // Default value
        if let defaultValue = defaultValue {
            result += " = \(defaultValue)"
        }

        return result
    }
}
