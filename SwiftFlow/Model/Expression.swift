//
//  Expression.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import Foundation
import SwiftData

/// Represents an expression node in the expression tree
/// Used for computed values, conditions, and function calls
@Model
final class Expression {
    @Attribute(.unique) var id: UUID
    var expressionType: ExpressionType
    var sortOrder: Int

    // Literal values (stored as encoded data)
    var stringValue: String?
    var intValue: Int?
    var doubleValue: Double?
    var boolValue: Bool?

    // Reference values
    var variableName: String?        // For variableReference
    var propertyPath: String?        // For propertyReference (e.g., "user.name")
    var functionName: String?        // For functionCall
    var typeName: String?            // For type operations

    // Parent expression (for tree structure)
    var parent: Expression?

    // Child expressions (operands)
    @Relationship(deleteRule: .cascade, inverse: \Expression.parent)
    var children: [Expression]?

    // Resulting type (inferred or specified)
    var resultTypeData: Data?

    // Computed accessor for resultType
    var resultType: TypeDefinition? {
        get {
            guard let data = resultTypeData,
                  let decoded = try? JSONDecoder().decode(TypeDefinition.self, from: data) else {
                return nil
            }
            return decoded
        }
        set {
            if let newValue {
                resultTypeData = try? JSONEncoder().encode(newValue)
            } else {
                resultTypeData = nil
            }
        }
    }

    init(
        id: UUID = UUID(),
        expressionType: ExpressionType,
        sortOrder: Int = 0
    ) {
        self.id = id
        self.expressionType = expressionType
        self.sortOrder = sortOrder
        self.children = []
    }

    // MARK: - Convenience Initializers

    static func stringLiteral(_ value: String) -> Expression {
        let expr = Expression(expressionType: .stringLiteral)
        expr.stringValue = value
        expr.resultType = .string
        return expr
    }

    static func intLiteral(_ value: Int) -> Expression {
        let expr = Expression(expressionType: .intLiteral)
        expr.intValue = value
        expr.resultType = .int
        return expr
    }

    static func doubleLiteral(_ value: Double) -> Expression {
        let expr = Expression(expressionType: .doubleLiteral)
        expr.doubleValue = value
        expr.resultType = .double
        return expr
    }

    static func boolLiteral(_ value: Bool) -> Expression {
        let expr = Expression(expressionType: .boolLiteral)
        expr.boolValue = value
        expr.resultType = .bool
        return expr
    }

    static func nilLiteral() -> Expression {
        let expr = Expression(expressionType: .nilLiteral)
        return expr
    }

    static func variableReference(_ name: String, type: TypeDefinition? = nil) -> Expression {
        let expr = Expression(expressionType: .variableReference)
        expr.variableName = name
        expr.resultType = type
        return expr
    }

    static func propertyReference(_ path: String, type: TypeDefinition? = nil) -> Expression {
        let expr = Expression(expressionType: .propertyReference)
        expr.propertyPath = path
        expr.resultType = type
        return expr
    }

    static func functionCall(_ name: String, arguments: [Expression] = [], resultType: TypeDefinition? = nil) -> Expression {
        let expr = Expression(expressionType: .functionCall)
        expr.functionName = name
        expr.children = arguments.enumerated().map { index, arg in
            arg.sortOrder = index
            arg.parent = expr
            return arg
        }
        expr.resultType = resultType
        return expr
    }

    static func binaryOperation(_ type: ExpressionType, left: Expression, right: Expression, resultType: TypeDefinition? = nil) -> Expression {
        let expr = Expression(expressionType: type)
        left.sortOrder = 0
        left.parent = expr
        right.sortOrder = 1
        right.parent = expr
        expr.children = [left, right]
        expr.resultType = resultType
        return expr
    }

    static func unaryOperation(_ type: ExpressionType, operand: Expression, resultType: TypeDefinition? = nil) -> Expression {
        let expr = Expression(expressionType: type)
        operand.sortOrder = 0
        operand.parent = expr
        expr.children = [operand]
        expr.resultType = resultType
        return expr
    }

    // MARK: - Child Access

    var sortedChildren: [Expression] {
        (children ?? []).sorted { $0.sortOrder < $1.sortOrder }
    }

    var leftOperand: Expression? {
        sortedChildren.first
    }

    var rightOperand: Expression? {
        guard sortedChildren.count > 1 else { return nil }
        return sortedChildren[1]
    }

    func addChild(_ child: Expression) {
        child.sortOrder = (children ?? []).count
        child.parent = self
        if children == nil {
            children = []
        }
        children?.append(child)
    }

    func removeChild(_ child: Expression) {
        children?.removeAll { $0.id == child.id }
        // Re-sort remaining children
        for (index, child) in (children ?? []).sorted(by: { $0.sortOrder < $1.sortOrder }).enumerated() {
            child.sortOrder = index
        }
    }

    // MARK: - Code Generation

    func toSwiftCode() -> String {
        switch expressionType {
        // Literals
        case .stringLiteral:
            return "\"\(stringValue ?? "")\""
        case .intLiteral:
            return "\(intValue ?? 0)"
        case .doubleLiteral:
            return "\(doubleValue ?? 0.0)"
        case .boolLiteral:
            return "\(boolValue ?? false)"
        case .nilLiteral:
            return "nil"
        case .arrayLiteral:
            let elements = sortedChildren.map { $0.toSwiftCode() }.joined(separator: ", ")
            return "[\(elements)]"
        case .dictionaryLiteral:
            // Children should be key-value pairs
            let pairs = stride(from: 0, to: sortedChildren.count, by: 2).compactMap { i -> String? in
                guard i + 1 < sortedChildren.count else { return nil }
                return "\(sortedChildren[i].toSwiftCode()): \(sortedChildren[i + 1].toSwiftCode())"
            }.joined(separator: ", ")
            return "[\(pairs)]"

        // References
        case .variableReference:
            return variableName ?? ""
        case .propertyReference:
            return propertyPath ?? ""
        case .selfReference:
            return "self"
        case .keyPath:
            return "\\\(propertyPath ?? "")"

        // Calls
        case .functionCall:
            let args = sortedChildren.map { $0.toSwiftCode() }.joined(separator: ", ")
            return "\(functionName ?? "")(\(args))"
        case .methodCall:
            guard let target = leftOperand else { return "" }
            let args = sortedChildren.dropFirst().map { $0.toSwiftCode() }.joined(separator: ", ")
            return "\(target.toSwiftCode()).\(functionName ?? "")(\(args))"
        case .initializerCall:
            let args = sortedChildren.map { $0.toSwiftCode() }.joined(separator: ", ")
            return "\(typeName ?? "")(\(args))"
        case .subscriptAccess:
            guard let target = leftOperand, let index = rightOperand else { return "" }
            return "\(target.toSwiftCode())[\(index.toSwiftCode())]"

        // Binary operators
        case .add, .subtract, .multiply, .divide, .modulo,
             .equal, .notEqual, .lessThan, .greaterThan, .lessOrEqual, .greaterOrEqual,
             .and, .or, .bitwiseAnd, .bitwiseOr, .bitwiseXor, .leftShift, .rightShift,
             .closedRange, .halfOpenRange, .nilCoalesce, .stringConcat:
            guard let left = leftOperand, let right = rightOperand,
                  let op = expressionType.swiftOperator else { return "" }
            return "(\(left.toSwiftCode()) \(op) \(right.toSwiftCode()))"

        // Unary operators
        case .negate:
            guard let operand = leftOperand else { return "" }
            return "-\(operand.toSwiftCode())"
        case .not:
            guard let operand = leftOperand else { return "" }
            return "!\(operand.toSwiftCode())"
        case .bitwiseNot:
            guard let operand = leftOperand else { return "" }
            return "~\(operand.toSwiftCode())"
        case .optionalChain:
            guard let operand = leftOperand else { return "" }
            return "\(operand.toSwiftCode())?"
        case .forceUnwrap:
            guard let operand = leftOperand else { return "" }
            return "\(operand.toSwiftCode())!"

        // Type operations
        case .typeCheck:
            guard let operand = leftOperand else { return "" }
            return "\(operand.toSwiftCode()) is \(typeName ?? "")"
        case .typeCast:
            guard let operand = leftOperand else { return "" }
            return "\(operand.toSwiftCode()) as \(typeName ?? "")"
        case .optionalCast:
            guard let operand = leftOperand else { return "" }
            return "\(operand.toSwiftCode()) as? \(typeName ?? "")"
        case .forceCast:
            guard let operand = leftOperand else { return "" }
            return "\(operand.toSwiftCode()) as! \(typeName ?? "")"
        case .optionalTry:
            guard let operand = leftOperand else { return "" }
            return "try? \(operand.toSwiftCode())"
        case .forceTry:
            guard let operand = leftOperand else { return "" }
            return "try! \(operand.toSwiftCode())"

        // Ternary
        case .ternaryConditional:
            guard sortedChildren.count >= 3 else { return "" }
            return "(\(sortedChildren[0].toSwiftCode()) ? \(sortedChildren[1].toSwiftCode()) : \(sortedChildren[2].toSwiftCode()))"

        // Member access
        case .memberAccess:
            guard let target = leftOperand else { return "" }
            return "\(target.toSwiftCode()).\(propertyPath ?? "")"
        case .staticMemberAccess:
            return "\(typeName ?? "").\(propertyPath ?? "")"

        // Collection access
        case .arrayAccess, .dictionaryAccess:
            guard let target = leftOperand, let index = rightOperand else { return "" }
            return "\(target.toSwiftCode())[\(index.toSwiftCode())]"

        // String operations
        case .stringInterpolation:
            let parts = sortedChildren.map { child -> String in
                if child.expressionType == .stringLiteral {
                    return child.stringValue ?? ""
                } else {
                    return "\\(\(child.toSwiftCode()))"
                }
            }.joined()
            return "\"\(parts)\""

        // Closures
        case .closure, .trailingClosure:
            // Simplified closure generation
            let body = sortedChildren.map { $0.toSwiftCode() }.joined(separator: "\n")
            return "{ \(body) }"

        // Ranges
        case .oneeSidedRangeTo:
            guard let end = leftOperand else { return "" }
            return "..<\(end.toSwiftCode())"
        case .oneSidedRangeFrom:
            guard let start = leftOperand else { return "" }
            return "\(start.toSwiftCode())..."

        }
    }
}
