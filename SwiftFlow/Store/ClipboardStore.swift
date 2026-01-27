//
//  ClipboardStore.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import Foundation

/// Manages copy/paste operations for blocks and other elements
@Observable
final class ClipboardStore {
    // MARK: - Clipboard Content

    /// Current clipboard content
    private(set) var content: ClipboardContent?

    /// When the content was copied
    private(set) var copiedAt: Date?

    // MARK: - Content Types

    enum ClipboardContent: Sendable {
        case viewBlocks([ViewBlockData])
        case logicBlocks([LogicBlockData])
        case viewProperty(ViewPropertyData)
        case queryProperty(QueryPropertyData)
        case modelProperty(ModelPropertyData)
        case viewFunction(ViewFunctionData)
        case queryFunction(QueryFunctionData)
    }

    // MARK: - Serializable Data Structures

    struct ViewBlockData: Codable, Sendable {
        let blockType: String
        let configuration: [String: String]
        let children: [ViewBlockData]
        let modifiers: [ModifierData]
    }

    struct ModifierData: Codable, Sendable {
        let modifierType: String
        let configuration: [String: String]
    }

    struct LogicBlockData: Codable, Sendable {
        let blockType: String
        let configuration: [String: String]
        let children: [LogicBlockData]
    }

    struct ViewPropertyData: Codable, Sendable {
        let name: String
        let propertyWrapper: String
        let typeDefinition: Data
        let defaultValue: String?
    }

    struct QueryPropertyData: Codable, Sendable {
        let name: String
        let typeDefinition: Data
        let defaultValue: String?
        let isPrivate: Bool
        let isPrivateSetter: Bool
    }

    struct ModelPropertyData: Codable, Sendable {
        let name: String
        let typeDefinition: Data
        let isOptional: Bool
        let isUnique: Bool
        let defaultValue: String?
    }

    struct ViewFunctionData: Codable, Sendable {
        let name: String
        let isAsync: Bool
        let throwsError: Bool
        let returnType: Data?
        let parameters: [ParameterData]
    }

    struct QueryFunctionData: Codable, Sendable {
        let name: String
        let isAsync: Bool
        let throwsError: Bool
        let isMainActor: Bool
        let returnType: Data?
        let parameters: [ParameterData]
    }

    struct ParameterData: Codable, Sendable {
        let externalName: String?
        let internalName: String
        let typeDefinition: Data
        let defaultValue: String?
    }

    // MARK: - Computed Properties

    var hasContent: Bool {
        content != nil
    }

    var contentDescription: String {
        guard let content else { return "Empty" }
        switch content {
        case .viewBlocks(let blocks):
            return "\(blocks.count) view block(s)"
        case .logicBlocks(let blocks):
            return "\(blocks.count) logic block(s)"
        case .viewProperty:
            return "View property"
        case .queryProperty:
            return "Query property"
        case .modelProperty:
            return "Model property"
        case .viewFunction:
            return "View function"
        case .queryFunction:
            return "Query function"
        }
    }

    // MARK: - Copy Methods

    func copyViewBlocks(_ blocks: [ViewBlockData]) {
        content = .viewBlocks(blocks)
        copiedAt = Date()
    }

    func copyLogicBlocks(_ blocks: [LogicBlockData]) {
        content = .logicBlocks(blocks)
        copiedAt = Date()
    }

    func copyViewProperty(_ property: ViewPropertyData) {
        content = .viewProperty(property)
        copiedAt = Date()
    }

    func copyQueryProperty(_ property: QueryPropertyData) {
        content = .queryProperty(property)
        copiedAt = Date()
    }

    func copyModelProperty(_ property: ModelPropertyData) {
        content = .modelProperty(property)
        copiedAt = Date()
    }

    func copyViewFunction(_ function: ViewFunctionData) {
        content = .viewFunction(function)
        copiedAt = Date()
    }

    func copyQueryFunction(_ function: QueryFunctionData) {
        content = .queryFunction(function)
        copiedAt = Date()
    }

    // MARK: - Paste Methods

    func pasteViewBlocks() -> [ViewBlockData]? {
        guard case .viewBlocks(let blocks) = content else { return nil }
        return blocks
    }

    func pasteLogicBlocks() -> [LogicBlockData]? {
        guard case .logicBlocks(let blocks) = content else { return nil }
        return blocks
    }

    func pasteViewProperty() -> ViewPropertyData? {
        guard case .viewProperty(let property) = content else { return nil }
        return property
    }

    func pasteQueryProperty() -> QueryPropertyData? {
        guard case .queryProperty(let property) = content else { return nil }
        return property
    }

    func pasteModelProperty() -> ModelPropertyData? {
        guard case .modelProperty(let property) = content else { return nil }
        return property
    }

    func pasteViewFunction() -> ViewFunctionData? {
        guard case .viewFunction(let function) = content else { return nil }
        return function
    }

    func pasteQueryFunction() -> QueryFunctionData? {
        guard case .queryFunction(let function) = content else { return nil }
        return function
    }

    // MARK: - Clear

    func clear() {
        content = nil
        copiedAt = nil
    }

    // MARK: - Can Paste Checks

    var canPasteViewBlocks: Bool {
        if case .viewBlocks = content { return true }
        return false
    }

    var canPasteLogicBlocks: Bool {
        if case .logicBlocks = content { return true }
        return false
    }

    var canPasteViewProperty: Bool {
        if case .viewProperty = content { return true }
        return false
    }

    var canPasteQueryProperty: Bool {
        if case .queryProperty = content { return true }
        return false
    }

    var canPasteModelProperty: Bool {
        if case .modelProperty = content { return true }
        return false
    }
}
