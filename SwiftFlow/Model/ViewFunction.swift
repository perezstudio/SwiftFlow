//
//  ViewFunction.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import Foundation
import SwiftData

/// Represents a function defined in a SwiftUI view
@Model
final class ViewFunction {
    @Attribute(.unique) var id: UUID
    var name: String
    var isAsync: Bool
    var throwsError: Bool
    var returnTypeData: Data?
    var sortOrder: Int

    // Access control
    var isPrivate: Bool

    // Relationship to view file
    var viewFile: ViewFile?

    // Function parameters
    @Relationship(deleteRule: .cascade, inverse: \FunctionParameter.viewFunction)
    var parameters: [FunctionParameter]?

    // Function body as logic blocks
    @Relationship(deleteRule: .cascade)
    var bodyBlocks: [LogicBlock]?

    // Computed accessor for return type
    var returnType: TypeDefinition? {
        get {
            guard let data = returnTypeData,
                  let decoded = try? JSONDecoder().decode(TypeDefinition.self, from: data) else {
                return nil
            }
            return decoded
        }
        set {
            if let newValue {
                returnTypeData = try? JSONEncoder().encode(newValue)
            } else {
                returnTypeData = nil
            }
        }
    }

    init(
        id: UUID = UUID(),
        name: String,
        isAsync: Bool = false,
        throwsError: Bool = false,
        returnType: TypeDefinition? = nil,
        sortOrder: Int = 0
    ) {
        self.id = id
        self.name = name
        self.isAsync = isAsync
        self.throwsError = throwsError
        if let returnType {
            self.returnTypeData = try? JSONEncoder().encode(returnType)
        }
        self.sortOrder = sortOrder
        self.isPrivate = true
        self.parameters = []
        self.bodyBlocks = []
    }

    // MARK: - Parameters

    var sortedParameters: [FunctionParameter] {
        (parameters ?? []).sorted { $0.sortOrder < $1.sortOrder }
    }

    func addParameter(_ param: FunctionParameter) {
        param.viewFunction = self
        param.sortOrder = (parameters ?? []).count
        if parameters == nil {
            parameters = []
        }
        parameters?.append(param)
    }

    func removeParameter(_ param: FunctionParameter) {
        parameters?.removeAll { $0.id == param.id }
        reindexParameters()
    }

    private func reindexParameters() {
        for (index, param) in sortedParameters.enumerated() {
            param.sortOrder = index
        }
    }

    // MARK: - Body Blocks

    var sortedBodyBlocks: [LogicBlock] {
        (bodyBlocks ?? []).filter { $0.parentBlock == nil }.sorted { $0.sortOrder < $1.sortOrder }
    }

    func addBodyBlock(_ block: LogicBlock) {
        block.viewFunction = self
        block.sortOrder = sortedBodyBlocks.count
        if bodyBlocks == nil {
            bodyBlocks = []
        }
        bodyBlocks?.append(block)
    }

    func removeBodyBlock(_ block: LogicBlock) {
        bodyBlocks?.removeAll { $0.id == block.id }
        reindexBodyBlocks()
    }

    private func reindexBodyBlocks() {
        for (index, block) in sortedBodyBlocks.enumerated() {
            block.sortOrder = index
        }
    }

    // MARK: - Display

    var displayName: String {
        name
    }

    var signature: String {
        var result = "func \(name)"

        // Parameters
        let paramStrings = sortedParameters.map { $0.toSwiftCode() }
        result += "(\(paramStrings.joined(separator: ", ")))"

        // Async/throws
        if isAsync {
            result += " async"
        }
        if throwsError {
            result += " throws"
        }

        // Return type
        if let returnType = returnType, returnType.baseType != .void {
            result += " -> \(returnType.toSwiftCode())"
        }

        return result
    }

    // MARK: - Code Generation

    func toSwiftCode(indent: String = "    ") -> String {
        var lines: [String] = []

        // Function signature
        var sig = ""
        if isPrivate {
            sig += "private "
        }
        sig += signature

        lines.append("\(indent)\(sig) {")

        // Body blocks
        for block in sortedBodyBlocks {
            lines.append(block.toSwiftCode(indent: indent + "    "))
        }

        lines.append("\(indent)}")

        return lines.joined(separator: "\n")
    }
}
