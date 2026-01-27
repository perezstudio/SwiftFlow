//
//  LogicBlock.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import Foundation
import SwiftData

/// Represents a logic block in a function's workflow
@Model
final class LogicBlock {
    @Attribute(.unique) var id: UUID
    var blockType: LogicBlockType
    var sortOrder: Int

    // Block-specific configuration stored as JSON
    var configurationData: Data?

    // Parent relationships
    var queryFunction: QueryFunction?
    var viewFunction: ViewFunction?
    var parentBlock: LogicBlock?

    // Child blocks (for control flow blocks)
    @Relationship(deleteRule: .cascade, inverse: \LogicBlock.parentBlock)
    var childBlocks: [LogicBlock]?

    // Associated expressions
    @Relationship(deleteRule: .cascade)
    var conditionExpression: Expression?    // For if/guard/while

    @Relationship(deleteRule: .cascade)
    var valueExpression: Expression?        // For assignment, return

    @Relationship(deleteRule: .cascade)
    var iterableExpression: Expression?     // For forEach/for

    init(
        id: UUID = UUID(),
        blockType: LogicBlockType,
        sortOrder: Int = 0
    ) {
        self.id = id
        self.blockType = blockType
        self.sortOrder = sortOrder
        self.childBlocks = []
    }

    // MARK: - Configuration

    var configuration: [String: Any] {
        get {
            guard let data = configurationData,
                  let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                return [:]
            }
            return dict
        }
        set {
            configurationData = try? JSONSerialization.data(withJSONObject: newValue)
        }
    }

    func setConfig(_ key: String, value: Any) {
        var config = configuration
        config[key] = value
        configuration = config
    }

    func getConfig<T>(_ key: String, default defaultValue: T) -> T {
        (configuration[key] as? T) ?? defaultValue
    }

    func getConfig<T>(_ key: String) -> T? {
        configuration[key] as? T
    }

    // MARK: - Common Configuration Accessors

    // Variable declaration
    var variableName: String? {
        get { getConfig("variableName") }
        set { setConfig("variableName", value: newValue ?? "") }
    }

    var variableType: String? {
        get { getConfig("variableType") }
        set { setConfig("variableType", value: newValue ?? "") }
    }

    var isConstant: Bool {
        get { getConfig("isConstant", default: false) }
        set { setConfig("isConstant", value: newValue) }
    }

    // Function call
    var functionName: String? {
        get { getConfig("functionName") }
        set { setConfig("functionName", value: newValue ?? "") }
    }

    var targetObject: String? {
        get { getConfig("targetObject") }
        set { setConfig("targetObject", value: newValue ?? "") }
    }

    // For loop
    var loopVariableName: String? {
        get { getConfig("loopVariable") }
        set { setConfig("loopVariable", value: newValue ?? "") }
    }

    var loopStartValue: String? {
        get { getConfig("loopStart") }
        set { setConfig("loopStart", value: newValue ?? "") }
    }

    var loopEndValue: String? {
        get { getConfig("loopEnd") }
        set { setConfig("loopEnd", value: newValue ?? "") }
    }

    // URL Request
    var urlString: String? {
        get { getConfig("url") }
        set { setConfig("url", value: newValue ?? "") }
    }

    var httpMethod: String? {
        get { getConfig("httpMethod") }
        set { setConfig("httpMethod", value: newValue ?? "") }
    }

    // Comment
    var commentText: String? {
        get { getConfig("comment") }
        set { setConfig("comment", value: newValue ?? "") }
    }

    // Custom code
    var customCode: String? {
        get { getConfig("code") }
        set { setConfig("code", value: newValue ?? "") }
    }

    // Print
    var printMessage: String? {
        get { getConfig("message") }
        set { setConfig("message", value: newValue ?? "") }
    }

    // MARK: - Children Management

    var sortedChildren: [LogicBlock] {
        (childBlocks ?? []).sorted { $0.sortOrder < $1.sortOrder }
    }

    func addChild(_ child: LogicBlock) {
        child.parentBlock = self
        child.sortOrder = (childBlocks ?? []).count
        if childBlocks == nil {
            childBlocks = []
        }
        childBlocks?.append(child)
    }

    func insertChild(_ child: LogicBlock, at index: Int) {
        child.parentBlock = self
        if childBlocks == nil {
            childBlocks = []
        }

        let sorted = sortedChildren
        let insertIndex = min(max(0, index), sorted.count)

        for (i, existingChild) in sorted.enumerated() {
            if i >= insertIndex {
                existingChild.sortOrder = i + 1
            }
        }

        child.sortOrder = insertIndex
        childBlocks?.append(child)
    }

    func removeChild(_ child: LogicBlock) {
        childBlocks?.removeAll { $0.id == child.id }
        reindexChildren()
    }

    private func reindexChildren() {
        for (index, child) in sortedChildren.enumerated() {
            child.sortOrder = index
        }
    }

    // MARK: - Hierarchy

    var depth: Int {
        var count = 0
        var current = parentBlock
        while current != nil {
            count += 1
            current = current?.parentBlock
        }
        return count
    }

    // MARK: - Display

    var displayName: String {
        blockType.displayName
    }

    var summary: String {
        switch blockType {
        case .declareVariable, .declareConstant:
            let keyword = blockType == .declareConstant ? "let" : "var"
            if let name = variableName, let type = variableType {
                return "\(keyword) \(name): \(type)"
            }
            return "\(keyword) ..."

        case .assignVariable:
            if let name = variableName {
                return "\(name) = ..."
            }
            return "assignment"

        case .ifStatement:
            return "if ..."

        case .forLoop:
            if let varName = loopVariableName {
                return "for \(varName) in ..."
            }
            return "for loop"

        case .forEachLoop:
            if let varName = loopVariableName {
                return "forEach { \(varName) in ... }"
            }
            return "forEach"

        case .returnStatement:
            return "return"

        case .functionCall:
            if let target = targetObject, let name = functionName {
                return "\(target).\(name)()"
            } else if let name = functionName {
                return "\(name)()"
            }
            return "function call"

        case .print:
            return "print(...)"

        case .comment:
            if let text = commentText {
                let preview = text.prefix(30)
                return "// \(preview)\(text.count > 30 ? "..." : "")"
            }
            return "// comment"

        case .customCode:
            return "custom code"

        default:
            return blockType.displayName
        }
    }

    // MARK: - Code Generation

    func toSwiftCode(indent: String = "") -> String {
        switch blockType {
        case .declareVariable:
            let keyword = isConstant ? "let" : "var"
            var code = "\(indent)\(keyword) \(variableName ?? "value")"
            if let type = variableType {
                code += ": \(type)"
            }
            if let expr = valueExpression {
                code += " = \(expr.toSwiftCode())"
            }
            return code

        case .declareConstant:
            var code = "\(indent)let \(variableName ?? "value")"
            if let type = variableType {
                code += ": \(type)"
            }
            if let expr = valueExpression {
                code += " = \(expr.toSwiftCode())"
            }
            return code

        case .assignVariable:
            let value = valueExpression?.toSwiftCode() ?? "nil"
            return "\(indent)\(variableName ?? "value") = \(value)"

        case .ifStatement:
            var lines: [String] = []
            let condition = conditionExpression?.toSwiftCode() ?? "true"
            lines.append("\(indent)if \(condition) {")
            for child in sortedChildren {
                lines.append(child.toSwiftCode(indent: indent + "    "))
            }
            lines.append("\(indent)}")
            return lines.joined(separator: "\n")

        case .elseIfStatement:
            var lines: [String] = []
            let condition = conditionExpression?.toSwiftCode() ?? "true"
            lines.append("\(indent)else if \(condition) {")
            for child in sortedChildren {
                lines.append(child.toSwiftCode(indent: indent + "    "))
            }
            lines.append("\(indent)}")
            return lines.joined(separator: "\n")

        case .elseStatement:
            var lines: [String] = []
            lines.append("\(indent)else {")
            for child in sortedChildren {
                lines.append(child.toSwiftCode(indent: indent + "    "))
            }
            lines.append("\(indent)}")
            return lines.joined(separator: "\n")

        case .guardStatement:
            var lines: [String] = []
            let condition = conditionExpression?.toSwiftCode() ?? "true"
            lines.append("\(indent)guard \(condition) else {")
            for child in sortedChildren {
                lines.append(child.toSwiftCode(indent: indent + "    "))
            }
            lines.append("\(indent)}")
            return lines.joined(separator: "\n")

        case .forLoop:
            var lines: [String] = []
            let varName = loopVariableName ?? "i"
            let start = loopStartValue ?? "0"
            let end = loopEndValue ?? "10"
            lines.append("\(indent)for \(varName) in \(start)..<\(end) {")
            for child in sortedChildren {
                lines.append(child.toSwiftCode(indent: indent + "    "))
            }
            lines.append("\(indent)}")
            return lines.joined(separator: "\n")

        case .forEachLoop:
            var lines: [String] = []
            let varName = loopVariableName ?? "item"
            let iterable = iterableExpression?.toSwiftCode() ?? "[]"
            lines.append("\(indent)for \(varName) in \(iterable) {")
            for child in sortedChildren {
                lines.append(child.toSwiftCode(indent: indent + "    "))
            }
            lines.append("\(indent)}")
            return lines.joined(separator: "\n")

        case .whileLoop:
            var lines: [String] = []
            let condition = conditionExpression?.toSwiftCode() ?? "true"
            lines.append("\(indent)while \(condition) {")
            for child in sortedChildren {
                lines.append(child.toSwiftCode(indent: indent + "    "))
            }
            lines.append("\(indent)}")
            return lines.joined(separator: "\n")

        case .returnStatement:
            if let expr = valueExpression {
                return "\(indent)return \(expr.toSwiftCode())"
            }
            return "\(indent)return"

        case .breakStatement:
            return "\(indent)break"

        case .continueStatement:
            return "\(indent)continue"

        case .doTryCatch:
            var lines: [String] = []
            lines.append("\(indent)do {")
            for child in sortedChildren.filter({ $0.blockType != .catchBlock }) {
                lines.append(child.toSwiftCode(indent: indent + "    "))
            }
            lines.append("\(indent)}")
            for catchChild in sortedChildren.filter({ $0.blockType == .catchBlock }) {
                lines.append(catchChild.toSwiftCode(indent: indent))
            }
            return lines.joined(separator: "\n")

        case .catchBlock:
            var lines: [String] = []
            lines.append("\(indent)catch {")
            for child in sortedChildren {
                lines.append(child.toSwiftCode(indent: indent + "    "))
            }
            lines.append("\(indent)}")
            return lines.joined(separator: "\n")

        case .throwError:
            let error = valueExpression?.toSwiftCode() ?? "error"
            return "\(indent)throw \(error)"

        case .print:
            let message = printMessage ?? valueExpression?.toSwiftCode() ?? "\"\""
            return "\(indent)print(\(message))"

        case .comment:
            return "\(indent)// \(commentText ?? "")"

        case .customCode:
            return "\(indent)\(customCode ?? "")"

        case .functionCall:
            var code = indent
            if let target = targetObject {
                code += "\(target)."
            }
            code += "\(functionName ?? "function")()"
            return code

        default:
            return "\(indent)// \(blockType.displayName)"
        }
    }
}
