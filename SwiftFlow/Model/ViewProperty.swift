//
//  ViewProperty.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import Foundation
import SwiftData

/// Represents a property in a SwiftUI view (@State, @Binding, etc.)
@Model
final class ViewProperty {
    @Attribute(.unique) var id: UUID
    var name: String
    var propertyWrapper: PropertyWrapperType
    var typeDefinitionData: Data?
    var defaultValue: String?        // Default value as code string
    var sortOrder: Int

    // For @Environment - the key path
    var environmentKeyPath: String?

    // For @Query - query configuration
    var queryPredicate: String?
    var querySortDescriptors: String?
    var queryAnimation: String?

    // For @AppStorage / @SceneStorage - the key
    var storageKey: String?

    // Access control
    var isPrivate: Bool

    // Relationship to view file
    var viewFile: ViewFile?

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
        name: String,
        propertyWrapper: PropertyWrapperType,
        typeDefinition: TypeDefinition,
        defaultValue: String? = nil,
        sortOrder: Int = 0
    ) {
        self.id = id
        self.name = name
        self.propertyWrapper = propertyWrapper
        self.typeDefinitionData = try? JSONEncoder().encode(typeDefinition)
        self.defaultValue = defaultValue
        self.sortOrder = sortOrder
        self.isPrivate = propertyWrapper.isPrivateByDefault
    }

    // MARK: - Convenience Initializers

    static func state(name: String, type: TypeDefinition, defaultValue: String) -> ViewProperty {
        ViewProperty(
            name: name,
            propertyWrapper: .state,
            typeDefinition: type,
            defaultValue: defaultValue
        )
    }

    static func binding(name: String, type: TypeDefinition) -> ViewProperty {
        ViewProperty(
            name: name,
            propertyWrapper: .binding,
            typeDefinition: type
        )
    }

    static func environment(name: String, keyPath: String, type: TypeDefinition) -> ViewProperty {
        let prop = ViewProperty(
            name: name,
            propertyWrapper: .environment,
            typeDefinition: type
        )
        prop.environmentKeyPath = keyPath
        return prop
    }

    static func query(name: String, modelType: String, predicate: String? = nil, sort: String? = nil) -> ViewProperty {
        let prop = ViewProperty(
            name: name,
            propertyWrapper: .query,
            typeDefinition: .array(of: .custom(modelType))
        )
        prop.queryPredicate = predicate
        prop.querySortDescriptors = sort
        return prop
    }

    // MARK: - Display

    var displayName: String {
        "\(propertyWrapper.displayName) \(name)"
    }

    var signature: String {
        var result = ""

        if isPrivate {
            result += "private "
        }

        result += propertyWrapper.swiftCode

        // Handle special cases
        switch propertyWrapper {
        case .environment:
            if let keyPath = environmentKeyPath {
                result += "(\\.\(keyPath))"
            }
        case .appStorage, .sceneStorage:
            if let key = storageKey {
                result += "(\"\(key)\")"
            }
        case .query:
            // Query has complex configuration
            break
        default:
            break
        }

        if !result.isEmpty && !propertyWrapper.swiftCode.isEmpty {
            result += " "
        }

        result += "var \(name): \(typeDefinition.toSwiftCode())"

        if let defaultValue = defaultValue, propertyWrapper.requiresInitialValue {
            result += " = \(defaultValue)"
        }

        return result
    }

    // MARK: - Code Generation

    func toSwiftCode() -> String {
        var lines: [String] = []

        var declaration = ""

        // Access control
        if isPrivate {
            declaration += "private "
        }

        // Property wrapper
        switch propertyWrapper {
        case .environment:
            if let keyPath = environmentKeyPath {
                declaration += "@Environment(\\.\(keyPath)) "
            } else {
                declaration += "@Environment "
            }
        case .appStorage:
            if let key = storageKey {
                declaration += "@AppStorage(\"\(key)\") "
            } else {
                declaration += "@AppStorage "
            }
        case .sceneStorage:
            if let key = storageKey {
                declaration += "@SceneStorage(\"\(key)\") "
            } else {
                declaration += "@SceneStorage "
            }
        case .query:
            var queryParts: [String] = []
            if let sort = querySortDescriptors {
                queryParts.append("sort: \(sort)")
            }
            if let animation = queryAnimation {
                queryParts.append("animation: \(animation)")
            }
            if queryParts.isEmpty {
                declaration += "@Query "
            } else {
                declaration += "@Query(\(queryParts.joined(separator: ", "))) "
            }
        case .plain:
            // No wrapper
            break
        default:
            declaration += "\(propertyWrapper.swiftCode) "
        }

        // Variable declaration
        declaration += "var \(name): \(typeDefinition.toSwiftCode())"

        // Default value
        if let defaultValue = defaultValue {
            declaration += " = \(defaultValue)"
        }

        lines.append(declaration)

        return lines.joined(separator: "\n")
    }
}
