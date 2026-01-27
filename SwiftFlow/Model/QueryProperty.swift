//
//  QueryProperty.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import Foundation
import SwiftData

/// Represents a property in an @Observable query object
@Model
final class QueryProperty {
    @Attribute(.unique) var id: UUID
    var name: String
    var typeDefinitionData: Data?
    var defaultValue: String?
    var sortOrder: Int

    // Access control
    var isPrivate: Bool
    var isPrivateSetter: Bool          // private(set)

    // Observation behavior
    var isObservationIgnored: Bool     // @ObservationIgnored

    // Relationship to query file
    var queryFile: QueryFile?

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
        typeDefinition: TypeDefinition,
        defaultValue: String? = nil,
        sortOrder: Int = 0
    ) {
        self.id = id
        self.name = name
        self.typeDefinitionData = try? JSONEncoder().encode(typeDefinition)
        self.defaultValue = defaultValue
        self.sortOrder = sortOrder
        self.isPrivate = false
        self.isPrivateSetter = false
        self.isObservationIgnored = false
    }

    // MARK: - Display

    var displayName: String {
        name
    }

    var signature: String {
        var result = ""

        if isPrivate {
            result += "private "
        } else if isPrivateSetter {
            result += "private(set) "
        }

        result += "var \(name): \(typeDefinition.toSwiftCode())"

        if let defaultValue = defaultValue {
            result += " = \(defaultValue)"
        }

        return result
    }

    // MARK: - Code Generation

    func toSwiftCode(indent: String = "    ") -> String {
        var lines: [String] = []

        if isObservationIgnored {
            lines.append("\(indent)@ObservationIgnored")
        }

        var declaration = indent

        if isPrivate {
            declaration += "private "
        } else if isPrivateSetter {
            declaration += "private(set) "
        }

        declaration += "var \(name): \(typeDefinition.toSwiftCode())"

        if let defaultValue = defaultValue {
            declaration += " = \(defaultValue)"
        }

        lines.append(declaration)

        return lines.joined(separator: "\n")
    }
}
