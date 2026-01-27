//
//  ExpressionType.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import Foundation

/// Expression node types for the expression tree builder
enum ExpressionType: String, Codable, CaseIterable, Identifiable, Sendable {
    var id: String { rawValue }

    // MARK: - Literals
    case stringLiteral
    case intLiteral
    case doubleLiteral
    case boolLiteral
    case nilLiteral
    case arrayLiteral
    case dictionaryLiteral

    // MARK: - References
    case variableReference
    case propertyReference
    case keyPath
    case selfReference

    // MARK: - Calls
    case functionCall
    case methodCall
    case initializerCall
    case subscriptAccess

    // MARK: - Arithmetic Operators
    case add
    case subtract
    case multiply
    case divide
    case modulo
    case negate

    // MARK: - Comparison Operators
    case equal
    case notEqual
    case lessThan
    case greaterThan
    case lessOrEqual
    case greaterOrEqual

    // MARK: - Logical Operators
    case and
    case or
    case not

    // MARK: - Bitwise Operators
    case bitwiseAnd
    case bitwiseOr
    case bitwiseXor
    case bitwiseNot
    case leftShift
    case rightShift

    // MARK: - Range Operators
    case closedRange
    case halfOpenRange
    case oneeSidedRangeTo
    case oneSidedRangeFrom

    // MARK: - Optional Operators
    case optionalChain
    case nilCoalesce
    case forceUnwrap
    case optionalTry
    case forceTry

    // MARK: - Type Operations
    case typeCheck        // is
    case typeCast         // as
    case optionalCast     // as?
    case forceCast        // as!

    // MARK: - String Operations
    case stringInterpolation
    case stringConcat

    // MARK: - Collection Operations
    case arrayAccess
    case dictionaryAccess

    // MARK: - Ternary
    case ternaryConditional

    // MARK: - Closures
    case closure
    case trailingClosure

    // MARK: - Member Access
    case memberAccess
    case staticMemberAccess

    // MARK: - Display Properties

    var displayName: String {
        switch self {
        case .stringLiteral: return "String"
        case .intLiteral: return "Integer"
        case .doubleLiteral: return "Decimal"
        case .boolLiteral: return "Boolean"
        case .nilLiteral: return "Nil"
        case .arrayLiteral: return "Array"
        case .dictionaryLiteral: return "Dictionary"
        case .variableReference: return "Variable"
        case .propertyReference: return "Property"
        case .keyPath: return "Key Path"
        case .selfReference: return "Self"
        case .functionCall: return "Function Call"
        case .methodCall: return "Method Call"
        case .initializerCall: return "Initializer"
        case .subscriptAccess: return "Subscript"
        case .add: return "Add (+)"
        case .subtract: return "Subtract (-)"
        case .multiply: return "Multiply (*)"
        case .divide: return "Divide (/)"
        case .modulo: return "Modulo (%)"
        case .negate: return "Negate (-)"
        case .equal: return "Equal (==)"
        case .notEqual: return "Not Equal (!=)"
        case .lessThan: return "Less Than (<)"
        case .greaterThan: return "Greater Than (>)"
        case .lessOrEqual: return "Less or Equal (<=)"
        case .greaterOrEqual: return "Greater or Equal (>=)"
        case .and: return "And (&&)"
        case .or: return "Or (||)"
        case .not: return "Not (!)"
        case .bitwiseAnd: return "Bitwise And (&)"
        case .bitwiseOr: return "Bitwise Or (|)"
        case .bitwiseXor: return "Bitwise XOR (^)"
        case .bitwiseNot: return "Bitwise Not (~)"
        case .leftShift: return "Left Shift (<<)"
        case .rightShift: return "Right Shift (>>)"
        case .closedRange: return "Closed Range (...)"
        case .halfOpenRange: return "Half-Open Range (..<)"
        case .oneeSidedRangeTo: return "One-Sided Range To"
        case .oneSidedRangeFrom: return "One-Sided Range From"
        case .optionalChain: return "Optional Chain (?)"
        case .nilCoalesce: return "Nil Coalesce (??)"
        case .forceUnwrap: return "Force Unwrap (!)"
        case .optionalTry: return "Optional Try (try?)"
        case .forceTry: return "Force Try (try!)"
        case .typeCheck: return "Type Check (is)"
        case .typeCast: return "Type Cast (as)"
        case .optionalCast: return "Optional Cast (as?)"
        case .forceCast: return "Force Cast (as!)"
        case .stringInterpolation: return "String Interpolation"
        case .stringConcat: return "String Concatenation"
        case .arrayAccess: return "Array Access"
        case .dictionaryAccess: return "Dictionary Access"
        case .ternaryConditional: return "Ternary (?:)"
        case .closure: return "Closure"
        case .trailingClosure: return "Trailing Closure"
        case .memberAccess: return "Member Access"
        case .staticMemberAccess: return "Static Member"
        }
    }

    var category: ExpressionCategory {
        switch self {
        case .stringLiteral, .intLiteral, .doubleLiteral, .boolLiteral, .nilLiteral, .arrayLiteral, .dictionaryLiteral:
            return .literals
        case .variableReference, .propertyReference, .keyPath, .selfReference:
            return .references
        case .functionCall, .methodCall, .initializerCall, .subscriptAccess:
            return .calls
        case .add, .subtract, .multiply, .divide, .modulo, .negate:
            return .arithmetic
        case .equal, .notEqual, .lessThan, .greaterThan, .lessOrEqual, .greaterOrEqual:
            return .comparison
        case .and, .or, .not:
            return .logical
        case .bitwiseAnd, .bitwiseOr, .bitwiseXor, .bitwiseNot, .leftShift, .rightShift:
            return .bitwise
        case .closedRange, .halfOpenRange, .oneeSidedRangeTo, .oneSidedRangeFrom:
            return .range
        case .optionalChain, .nilCoalesce, .forceUnwrap, .optionalTry, .forceTry:
            return .optional
        case .typeCheck, .typeCast, .optionalCast, .forceCast:
            return .typeOperations
        case .stringInterpolation, .stringConcat:
            return .string
        case .arrayAccess, .dictionaryAccess:
            return .collection
        case .ternaryConditional:
            return .conditional
        case .closure, .trailingClosure:
            return .closures
        case .memberAccess, .staticMemberAccess:
            return .memberAccess
        }
    }

    var operandCount: Int {
        switch self {
        // No operands (literals and references)
        case .stringLiteral, .intLiteral, .doubleLiteral, .boolLiteral, .nilLiteral, .selfReference:
            return 0
        // One operand (unary)
        case .negate, .not, .bitwiseNot, .optionalChain, .forceUnwrap, .optionalTry, .forceTry:
            return 1
        // Two operands (binary)
        case .add, .subtract, .multiply, .divide, .modulo,
             .equal, .notEqual, .lessThan, .greaterThan, .lessOrEqual, .greaterOrEqual,
             .and, .or, .bitwiseAnd, .bitwiseOr, .bitwiseXor, .leftShift, .rightShift,
             .closedRange, .halfOpenRange, .nilCoalesce, .typeCheck, .typeCast, .optionalCast, .forceCast,
             .stringConcat, .memberAccess, .staticMemberAccess:
            return 2
        // Three operands (ternary)
        case .ternaryConditional:
            return 3
        // Variable operands
        default:
            return -1
        }
    }

    var swiftOperator: String? {
        switch self {
        case .add: return "+"
        case .subtract: return "-"
        case .multiply: return "*"
        case .divide: return "/"
        case .modulo: return "%"
        case .negate: return "-"
        case .equal: return "=="
        case .notEqual: return "!="
        case .lessThan: return "<"
        case .greaterThan: return ">"
        case .lessOrEqual: return "<="
        case .greaterOrEqual: return ">="
        case .and: return "&&"
        case .or: return "||"
        case .not: return "!"
        case .bitwiseAnd: return "&"
        case .bitwiseOr: return "|"
        case .bitwiseXor: return "^"
        case .bitwiseNot: return "~"
        case .leftShift: return "<<"
        case .rightShift: return ">>"
        case .closedRange: return "..."
        case .halfOpenRange: return "..<"
        case .nilCoalesce: return "??"
        case .optionalChain: return "?"
        case .forceUnwrap: return "!"
        case .typeCheck: return "is"
        case .typeCast: return "as"
        case .optionalCast: return "as?"
        case .forceCast: return "as!"
        case .stringConcat: return "+"
        default: return nil
        }
    }
}

enum ExpressionCategory: String, CaseIterable, Identifiable, Sendable {
    var id: String { rawValue }

    case literals
    case references
    case calls
    case arithmetic
    case comparison
    case logical
    case bitwise
    case range
    case optional
    case typeOperations
    case string
    case collection
    case conditional
    case closures
    case memberAccess

    var displayName: String {
        switch self {
        case .literals: return "Literals"
        case .references: return "References"
        case .calls: return "Calls"
        case .arithmetic: return "Arithmetic"
        case .comparison: return "Comparison"
        case .logical: return "Logical"
        case .bitwise: return "Bitwise"
        case .range: return "Range"
        case .optional: return "Optional"
        case .typeOperations: return "Type Operations"
        case .string: return "String"
        case .collection: return "Collection"
        case .conditional: return "Conditional"
        case .closures: return "Closures"
        case .memberAccess: return "Member Access"
        }
    }

    var expressions: [ExpressionType] {
        ExpressionType.allCases.filter { $0.category == self }
    }
}
