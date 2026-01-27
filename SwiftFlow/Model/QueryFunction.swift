//
//  QueryFunction.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import Foundation
import SwiftData

/// Represents a function in an @Observable query object
@Model
final class QueryFunction {
    @Attribute(.unique) var id: UUID
    var name: String
    var isAsync: Bool
    var throwsError: Bool
    var returnTypeData: Data?
    var sortOrder: Int

    // Access control
    var isPrivate: Bool

    // Main actor isolation
    var isMainActor: Bool

    // Relationship to query file
    var queryFile: QueryFile?

    // Function parameters
    @Relationship(deleteRule: .cascade, inverse: \FunctionParameter.queryFunction)
    var parameters: [FunctionParameter]?

    // Function body as logic blocks
    @Relationship(deleteRule: .cascade, inverse: \LogicBlock.queryFunction)
    var blocks: [LogicBlock]?

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
        self.isPrivate = false
        self.isMainActor = false
        self.parameters = []
        self.blocks = []
    }

    // MARK: - Parameters

    var sortedParameters: [FunctionParameter] {
        (parameters ?? []).sorted { $0.sortOrder < $1.sortOrder }
    }

    func addParameter(_ param: FunctionParameter) {
        param.queryFunction = self
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

    var sortedBlocks: [LogicBlock] {
        (blocks ?? []).filter { $0.parentBlock == nil }.sorted { $0.sortOrder < $1.sortOrder }
    }

    func addBlock(_ block: LogicBlock) {
        block.queryFunction = self
        block.sortOrder = sortedBlocks.count
        if blocks == nil {
            blocks = []
        }
        blocks?.append(block)
    }

    func removeBlock(_ block: LogicBlock) {
        blocks?.removeAll { $0.id == block.id }
        reindexBlocks()
    }

    private func reindexBlocks() {
        for (index, block) in sortedBlocks.enumerated() {
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

        // Main actor attribute
        if isMainActor {
            lines.append("\(indent)@MainActor")
        }

        // Function signature
        var sig = indent
        if isPrivate {
            sig += "private "
        }
        sig += signature

        lines.append("\(sig) {")

        // Body blocks
        for block in sortedBlocks {
            lines.append(block.toSwiftCode(indent: indent + "    "))
        }

        lines.append("\(indent)}")

        return lines.joined(separator: "\n")
    }
}
