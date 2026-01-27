//
//  ViewBlock.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import Foundation
import SwiftData

/// Represents a SwiftUI view block in the hierarchy
@Model
final class ViewBlock {
    @Attribute(.unique) var id: UUID
    var blockType: ViewBlockType
    var sortOrder: Int

    // For customComponent type - references another ViewFile
    var customComponentId: UUID?
    var customComponentName: String?

    // Block-specific configuration
    // Stored as JSON-encoded dictionary
    var configurationData: Data?

    // Parent-child relationships for hierarchy
    var parent: ViewBlock?

    @Relationship(deleteRule: .cascade, inverse: \ViewBlock.parent)
    var children: [ViewBlock]?

    // Applied modifiers in order
    @Relationship(deleteRule: .cascade, inverse: \ViewModifier.block)
    var modifiers: [ViewModifier]?

    // Conditional rendering expression (for ifBlock, etc.)
    @Relationship(deleteRule: .cascade)
    var conditionalExpression: Expression?

    // ForEach data source expression
    @Relationship(deleteRule: .cascade)
    var dataSourceExpression: Expression?

    // ForEach item variable name
    var forEachItemName: String?

    init(
        id: UUID = UUID(),
        blockType: ViewBlockType,
        sortOrder: Int = 0
    ) {
        self.id = id
        self.blockType = blockType
        self.sortOrder = sortOrder
        self.children = []
        self.modifiers = []
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

    // Text block
    var textContent: String? {
        get { getConfig("text") }
        set { setConfig("text", value: newValue ?? "") }
    }

    // Button block
    var buttonLabel: String? {
        get { getConfig("label") }
        set { setConfig("label", value: newValue ?? "") }
    }

    var buttonActionFunctionName: String? {
        get { getConfig("actionFunction") }
        set { setConfig("actionFunction", value: newValue ?? "") }
    }

    // Image block
    var imageName: String? {
        get { getConfig("imageName") }
        set { setConfig("imageName", value: newValue ?? "") }
    }

    var imageIsSystemName: Bool {
        get { getConfig("isSystemName", default: false) }
        set { setConfig("isSystemName", value: newValue) }
    }

    // Stack alignment
    var stackAlignment: String? {
        get { getConfig("alignment") }
        set { setConfig("alignment", value: newValue ?? "") }
    }

    var stackSpacing: Double? {
        get { getConfig("spacing") }
        set { if let v = newValue { setConfig("spacing", value: v) } }
    }

    // TextField
    var textFieldPlaceholder: String? {
        get { getConfig("placeholder") }
        set { setConfig("placeholder", value: newValue ?? "") }
    }

    var textFieldBindingProperty: String? {
        get { getConfig("bindingProperty") }
        set { setConfig("bindingProperty", value: newValue ?? "") }
    }

    // MARK: - Children Management

    var sortedChildren: [ViewBlock] {
        (children ?? []).sorted { $0.sortOrder < $1.sortOrder }
    }

    func addChild(_ child: ViewBlock) {
        child.parent = self
        child.sortOrder = (children ?? []).count
        if children == nil {
            children = []
        }
        children?.append(child)
    }

    func insertChild(_ child: ViewBlock, at index: Int) {
        child.parent = self
        if children == nil {
            children = []
        }

        let sorted = sortedChildren
        let insertIndex = min(max(0, index), sorted.count)

        // Shift sort orders
        for (i, existingChild) in sorted.enumerated() {
            if i >= insertIndex {
                existingChild.sortOrder = i + 1
            }
        }

        child.sortOrder = insertIndex
        children?.append(child)
    }

    func removeChild(_ child: ViewBlock) {
        children?.removeAll { $0.id == child.id }
        reindexChildren()
    }

    func moveChild(from source: Int, to destination: Int) {
        let sorted = sortedChildren
        guard source >= 0, source < sorted.count,
              destination >= 0, destination <= sorted.count else { return }

        var mutableSorted = sorted
        let item = mutableSorted.remove(at: source)
        mutableSorted.insert(item, at: destination > source ? destination - 1 : destination)

        for (index, child) in mutableSorted.enumerated() {
            child.sortOrder = index
        }
    }

    private func reindexChildren() {
        for (index, child) in sortedChildren.enumerated() {
            child.sortOrder = index
        }
    }

    // MARK: - Modifier Management

    var sortedModifiers: [ViewModifier] {
        (modifiers ?? []).sorted { $0.sortOrder < $1.sortOrder }
    }

    func addModifier(_ modifier: ViewModifier) {
        modifier.block = self
        modifier.sortOrder = (modifiers ?? []).count
        if modifiers == nil {
            modifiers = []
        }
        modifiers?.append(modifier)
    }

    func insertModifier(_ modifier: ViewModifier, at index: Int) {
        modifier.block = self
        if modifiers == nil {
            modifiers = []
        }

        let sorted = sortedModifiers
        let insertIndex = min(max(0, index), sorted.count)

        for (i, existingMod) in sorted.enumerated() {
            if i >= insertIndex {
                existingMod.sortOrder = i + 1
            }
        }

        modifier.sortOrder = insertIndex
        modifiers?.append(modifier)
    }

    func removeModifier(_ modifier: ViewModifier) {
        modifiers?.removeAll { $0.id == modifier.id }
        reindexModifiers()
    }

    func moveModifier(from source: Int, to destination: Int) {
        let sorted = sortedModifiers
        guard source >= 0, source < sorted.count,
              destination >= 0, destination <= sorted.count else { return }

        var mutableSorted = sorted
        let item = mutableSorted.remove(at: source)
        mutableSorted.insert(item, at: destination > source ? destination - 1 : destination)

        for (index, mod) in mutableSorted.enumerated() {
            mod.sortOrder = index
        }
    }

    private func reindexModifiers() {
        for (index, mod) in sortedModifiers.enumerated() {
            mod.sortOrder = index
        }
    }

    // MARK: - Hierarchy

    var depth: Int {
        var count = 0
        var current = parent
        while current != nil {
            count += 1
            current = current?.parent
        }
        return count
    }

    var root: ViewBlock {
        var current = self
        while let p = current.parent {
            current = p
        }
        return current
    }

    func isDescendant(of ancestor: ViewBlock) -> Bool {
        var current = parent
        while let p = current {
            if p.id == ancestor.id {
                return true
            }
            current = p.parent
        }
        return false
    }

    // MARK: - Display

    var displayName: String {
        switch blockType {
        case .text:
            if let content = textContent, !content.isEmpty {
                let preview = content.prefix(20)
                return "Text(\"\(preview)\(content.count > 20 ? "..." : "")\")"
            }
            return "Text"
        case .button:
            if let label = buttonLabel, !label.isEmpty {
                return "Button(\"\(label)\")"
            }
            return "Button"
        case .image:
            if let name = imageName, !name.isEmpty {
                return imageIsSystemName ? "Image(systemName: \"\(name)\")" : "Image(\"\(name)\")"
            }
            return "Image"
        case .customComponent:
            return customComponentName ?? "Custom Component"
        default:
            return blockType.displayName
        }
    }
}
