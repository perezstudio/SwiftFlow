//
//  TypeDefinition.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import Foundation

/// Represents a Swift type in a serializable format
struct TypeDefinition: Codable, Hashable, Equatable, Sendable {
    var baseType: BaseType
    var genericParameters: [TypeDefinition]?
    var isOptional: Bool
    var customTypeName: String?  // For DataModel references or external types
    var enumCases: [String]?     // For inline enum definitions

    // MARK: - Convenience Initializers

    init(
        baseType: BaseType,
        genericParameters: [TypeDefinition]? = nil,
        isOptional: Bool = false,
        customTypeName: String? = nil,
        enumCases: [String]? = nil
    ) {
        self.baseType = baseType
        self.genericParameters = genericParameters
        self.isOptional = isOptional
        self.customTypeName = customTypeName
        self.enumCases = enumCases
    }

    // MARK: - Static Constructors for Common Types

    static var string: TypeDefinition {
        TypeDefinition(baseType: .string)
    }

    static var int: TypeDefinition {
        TypeDefinition(baseType: .int)
    }

    static var double: TypeDefinition {
        TypeDefinition(baseType: .double)
    }

    static var bool: TypeDefinition {
        TypeDefinition(baseType: .bool)
    }

    static var date: TypeDefinition {
        TypeDefinition(baseType: .date)
    }

    static var data: TypeDefinition {
        TypeDefinition(baseType: .data)
    }

    static var uuid: TypeDefinition {
        TypeDefinition(baseType: .uuid)
    }

    static var url: TypeDefinition {
        TypeDefinition(baseType: .url)
    }

    static var void: TypeDefinition {
        TypeDefinition(baseType: .void)
    }

    static var any: TypeDefinition {
        TypeDefinition(baseType: .any)
    }

    static var color: TypeDefinition {
        TypeDefinition(baseType: .color)
    }

    static var image: TypeDefinition {
        TypeDefinition(baseType: .image)
    }

    // MARK: - Type Constructors

    static func optional(_ inner: TypeDefinition) -> TypeDefinition {
        var copy = inner
        copy.isOptional = true
        return copy
    }

    static func array(of element: TypeDefinition) -> TypeDefinition {
        TypeDefinition(baseType: .array, genericParameters: [element])
    }

    static func dictionary(key: TypeDefinition, value: TypeDefinition) -> TypeDefinition {
        TypeDefinition(baseType: .dictionary, genericParameters: [key, value])
    }

    static func set(of element: TypeDefinition) -> TypeDefinition {
        TypeDefinition(baseType: .set, genericParameters: [element])
    }

    static func custom(_ name: String) -> TypeDefinition {
        TypeDefinition(baseType: .custom, customTypeName: name)
    }

    static func result(success: TypeDefinition, failure: TypeDefinition) -> TypeDefinition {
        TypeDefinition(baseType: .result, genericParameters: [success, failure])
    }

    static func `enum`(cases: [String]) -> TypeDefinition {
        TypeDefinition(baseType: .enumType, enumCases: cases)
    }

    static func closure(parameters: [TypeDefinition], returns: TypeDefinition) -> TypeDefinition {
        TypeDefinition(baseType: .closure, genericParameters: parameters + [returns])
    }

    // MARK: - Type Checking

    func isAssignable(from other: TypeDefinition) -> Bool {
        // Same types are always assignable
        if self == other {
            return true
        }

        // Optional can accept non-optional of same base type
        if isOptional && !other.isOptional {
            var nonOptionalSelf = self
            nonOptionalSelf.isOptional = false
            return nonOptionalSelf == other
        }

        // Any accepts anything
        if baseType == .any {
            return true
        }

        // Check generic parameters for collections
        if baseType == other.baseType,
           let selfGenerics = genericParameters,
           let otherGenerics = other.genericParameters,
           selfGenerics.count == otherGenerics.count {
            return zip(selfGenerics, otherGenerics).allSatisfy { $0.isAssignable(from: $1) }
        }

        return false
    }

    var isCollection: Bool {
        switch baseType {
        case .array, .dictionary, .set:
            return true
        default:
            return false
        }
    }

    var elementType: TypeDefinition? {
        guard isCollection, let generics = genericParameters, !generics.isEmpty else {
            return nil
        }
        return generics[0]
    }

    // MARK: - Code Generation

    func toSwiftCode() -> String {
        var result: String

        switch baseType {
        case .string: result = "String"
        case .int: result = "Int"
        case .double: result = "Double"
        case .bool: result = "Bool"
        case .date: result = "Date"
        case .data: result = "Data"
        case .uuid: result = "UUID"
        case .url: result = "URL"
        case .void: result = "Void"
        case .any: result = "Any"
        case .color: result = "Color"
        case .image: result = "Image"
        case .array:
            if let elementType = genericParameters?.first {
                result = "[\(elementType.toSwiftCode())]"
            } else {
                result = "[Any]"
            }
        case .dictionary:
            if let generics = genericParameters, generics.count >= 2 {
                result = "[\(generics[0].toSwiftCode()): \(generics[1].toSwiftCode())]"
            } else {
                result = "[String: Any]"
            }
        case .set:
            if let elementType = genericParameters?.first {
                result = "Set<\(elementType.toSwiftCode())>"
            } else {
                result = "Set<Any>"
            }
        case .result:
            if let generics = genericParameters, generics.count >= 2 {
                result = "Result<\(generics[0].toSwiftCode()), \(generics[1].toSwiftCode())>"
            } else {
                result = "Result<Any, Error>"
            }
        case .custom:
            result = customTypeName ?? "Any"
        case .enumType:
            result = customTypeName ?? "CustomEnum"
        case .closure:
            if let generics = genericParameters, !generics.isEmpty {
                let params = generics.dropLast().map { $0.toSwiftCode() }.joined(separator: ", ")
                let returnType = generics.last?.toSwiftCode() ?? "Void"
                result = "(\(params)) -> \(returnType)"
            } else {
                result = "() -> Void"
            }
        }

        if isOptional {
            result += "?"
        }

        return result
    }

    var displayName: String {
        toSwiftCode()
    }
}

/// Base types supported in the type system
enum BaseType: String, Codable, CaseIterable, Identifiable, Sendable {
    var id: String { rawValue }

    // Primitives
    case string
    case int
    case double
    case bool

    // Foundation types
    case date
    case data
    case uuid
    case url

    // SwiftUI types
    case color
    case image

    // Collections
    case array
    case dictionary
    case set

    // Special
    case void
    case any
    case custom      // References a DataModel or external type
    case enumType    // Inline enum
    case closure     // Function type
    case result      // Result type

    var displayName: String {
        switch self {
        case .string: return "String"
        case .int: return "Int"
        case .double: return "Double"
        case .bool: return "Bool"
        case .date: return "Date"
        case .data: return "Data"
        case .uuid: return "UUID"
        case .url: return "URL"
        case .color: return "Color"
        case .image: return "Image"
        case .array: return "Array"
        case .dictionary: return "Dictionary"
        case .set: return "Set"
        case .void: return "Void"
        case .any: return "Any"
        case .custom: return "Custom"
        case .enumType: return "Enum"
        case .closure: return "Closure"
        case .result: return "Result"
        }
    }

    var isPrimitive: Bool {
        switch self {
        case .string, .int, .double, .bool:
            return true
        default:
            return false
        }
    }

    var requiresImport: String? {
        switch self {
        case .color, .image:
            return "SwiftUI"
        case .date, .data, .uuid, .url:
            return "Foundation"
        default:
            return nil
        }
    }
}

// MARK: - Delete Rule Type

enum DeleteRuleType: String, Codable, CaseIterable, Identifiable, Sendable {
    var id: String { rawValue }

    case nullify
    case cascade
    case deny
    case noAction

    var displayName: String {
        switch self {
        case .nullify: return "Nullify"
        case .cascade: return "Cascade"
        case .deny: return "Deny"
        case .noAction: return "No Action"
        }
    }

    var swiftDataCode: String {
        switch self {
        case .nullify: return ".nullify"
        case .cascade: return ".cascade"
        case .deny: return ".deny"
        case .noAction: return ".noAction"
        }
    }
}

// MARK: - Relationship Type

enum RelationshipType: String, Codable, CaseIterable, Identifiable, Sendable {
    var id: String { rawValue }

    case oneToOne
    case oneToMany
    case manyToMany

    var displayName: String {
        switch self {
        case .oneToOne: return "One to One"
        case .oneToMany: return "One to Many"
        case .manyToMany: return "Many to Many"
        }
    }
}

// MARK: - Asset Type

enum AssetType: String, Codable, CaseIterable, Identifiable, Sendable {
    var id: String { rawValue }

    case image
    case color
    case sfSymbol
    case customFont

    var displayName: String {
        switch self {
        case .image: return "Image"
        case .color: return "Color"
        case .sfSymbol: return "SF Symbol"
        case .customFont: return "Custom Font"
        }
    }

    var iconName: String {
        switch self {
        case .image: return "photo"
        case .color: return "paintpalette"
        case .sfSymbol: return "star.square"
        case .customFont: return "textformat"
        }
    }
}

// MARK: - File Type

enum FileType: String, Codable, CaseIterable, Identifiable, Sendable {
    var id: String { rawValue }

    case view
    case data
    case query

    var displayName: String {
        switch self {
        case .view: return "Views"
        case .data: return "Data"
        case .query: return "Queries"
        }
    }

    var singularName: String {
        switch self {
        case .view: return "View"
        case .data: return "Model"
        case .query: return "Query"
        }
    }

    var iconName: String {
        switch self {
        case .view: return "rectangle.3.group"
        case .data: return "cylinder"
        case .query: return "arrow.triangle.branch"
        }
    }
}
