//
//  ModelProperty.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import Foundation
import SwiftData

/// Represents a property in a SwiftData model
@Model
final class ModelProperty {
    @Attribute(.unique) var id: UUID
    var name: String
    var typeDefinitionData: Data?
    var isOptional: Bool
    var isUnique: Bool
    var defaultValue: String?
    var sortOrder: Int

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

    // For computed properties
    var isComputed: Bool

    // Computed expression (for computed properties)
    @Relationship(deleteRule: .cascade)
    var computedExpression: Expression?

    // SwiftData attribute options
    var isTransient: Bool              // @Transient
    var externalStorage: Bool          // .externalStorage
    var transformableByName: String?   // .transformable(by:)
    var spotlight: Bool                // .spotlight
    var encryptionKey: String?         // .encrypt(keyName:)

    // Relationship to model version
    var modelVersion: ModelVersion?

    init(
        id: UUID = UUID(),
        name: String,
        typeDefinition: TypeDefinition,
        isOptional: Bool = false,
        isUnique: Bool = false,
        defaultValue: String? = nil,
        isComputed: Bool = false,
        sortOrder: Int = 0
    ) {
        self.id = id
        self.name = name
        self.typeDefinitionData = try? JSONEncoder().encode(typeDefinition)
        self.isOptional = isOptional
        self.isUnique = isUnique
        self.defaultValue = defaultValue
        self.isComputed = isComputed
        self.sortOrder = sortOrder
        self.isTransient = false
        self.externalStorage = false
        self.spotlight = false
    }

    // MARK: - Display

    var displayName: String {
        name
    }

    var typeDisplayName: String {
        var result = typeDefinition.toSwiftCode()
        if isOptional && !typeDefinition.isOptional {
            result += "?"
        }
        return result
    }

    var signature: String {
        if isComputed {
            return "var \(name): \(typeDisplayName) { ... }"
        } else {
            var result = "var \(name): \(typeDisplayName)"
            if let defaultValue = defaultValue {
                result += " = \(defaultValue)"
            }
            return result
        }
    }

    // MARK: - Attribute Options

    var hasAttributeOptions: Bool {
        isUnique || externalStorage || spotlight || transformableByName != nil || encryptionKey != nil
    }

    var attributeOptionsCode: String? {
        guard hasAttributeOptions else { return nil }

        var options: [String] = []

        if isUnique {
            options.append(".unique")
        }
        if externalStorage {
            options.append(".externalStorage")
        }
        if spotlight {
            options.append(".spotlight")
        }
        if let transformer = transformableByName {
            options.append(".transformable(by: \"\(transformer)\")")
        }
        if let key = encryptionKey {
            options.append(".encrypt(keyName: \"\(key)\")")
        }

        return options.joined(separator: ", ")
    }

    // MARK: - Code Generation

    func toSwiftCode(indent: String = "    ") -> String {
        var lines: [String] = []

        if isTransient {
            lines.append("\(indent)@Transient")
        }

        if let attrOptions = attributeOptionsCode {
            lines.append("\(indent)@Attribute(\(attrOptions))")
        }

        if isComputed {
            lines.append("\(indent)var \(name): \(typeDisplayName) {")
            if let expr = computedExpression {
                lines.append("\(indent)    \(expr.toSwiftCode())")
            }
            lines.append("\(indent)}")
        } else {
            var declaration = "\(indent)var \(name): \(typeDisplayName)"
            if let defaultValue = defaultValue {
                declaration += " = \(defaultValue)"
            }
            lines.append(declaration)
        }

        return lines.joined(separator: "\n")
    }
}
