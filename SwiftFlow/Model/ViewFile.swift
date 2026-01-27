//
//  ViewFile.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import Foundation
import SwiftData

/// Represents a SwiftUI view file in the project
@Model
final class ViewFile {
    @Attribute(.unique) var id: UUID
    var name: String
    var isComponent: Bool          // Standalone view vs reusable component
    var createdAt: Date
    var modifiedAt: Date

    // Relationship to project
    var project: Project?

    // Root block of the view hierarchy
    @Relationship(deleteRule: .cascade)
    var rootBlock: ViewBlock?

    // State properties (@State, @Binding, @Bindable, @Query, @Environment)
    @Relationship(deleteRule: .cascade, inverse: \ViewProperty.viewFile)
    var properties: [ViewProperty]?

    // Custom functions defined in this view
    @Relationship(deleteRule: .cascade, inverse: \ViewFunction.viewFile)
    var functions: [ViewFunction]?

    init(
        id: UUID = UUID(),
        name: String,
        isComponent: Bool = false
    ) {
        self.id = id
        self.name = name
        self.isComponent = isComponent
        self.createdAt = Date()
        self.modifiedAt = Date()
        self.properties = []
        self.functions = []
    }

    // MARK: - Convenience Accessors

    var sortedProperties: [ViewProperty] {
        (properties ?? []).sorted { $0.sortOrder < $1.sortOrder }
    }

    var sortedFunctions: [ViewFunction] {
        (functions ?? []).sorted { $0.sortOrder < $1.sortOrder }
    }

    // Properties by wrapper type
    var stateProperties: [ViewProperty] {
        sortedProperties.filter { $0.propertyWrapper == .state }
    }

    var bindingProperties: [ViewProperty] {
        sortedProperties.filter { $0.propertyWrapper == .binding }
    }

    var queryProperties: [ViewProperty] {
        sortedProperties.filter { $0.propertyWrapper == .query }
    }

    var environmentProperties: [ViewProperty] {
        sortedProperties.filter { $0.propertyWrapper == .environment }
    }

    // MARK: - Property Management

    func addProperty(_ property: ViewProperty) {
        property.viewFile = self
        property.sortOrder = (properties ?? []).count
        if properties == nil {
            properties = []
        }
        properties?.append(property)
        markModified()
    }

    func removeProperty(_ property: ViewProperty) {
        properties?.removeAll { $0.id == property.id }
        reindexProperties()
        markModified()
    }

    func moveProperty(from source: Int, to destination: Int) {
        guard var props = properties,
              source >= 0, source < props.count,
              destination >= 0, destination <= props.count else { return }

        let sorted = props.sorted { $0.sortOrder < $1.sortOrder }
        var mutableSorted = sorted
        let item = mutableSorted.remove(at: source)
        mutableSorted.insert(item, at: destination > source ? destination - 1 : destination)

        for (index, prop) in mutableSorted.enumerated() {
            prop.sortOrder = index
        }
        markModified()
    }

    private func reindexProperties() {
        for (index, prop) in sortedProperties.enumerated() {
            prop.sortOrder = index
        }
    }

    // MARK: - Function Management

    func addFunction(_ function: ViewFunction) {
        function.viewFile = self
        function.sortOrder = (functions ?? []).count
        if functions == nil {
            functions = []
        }
        functions?.append(function)
        markModified()
    }

    func removeFunction(_ function: ViewFunction) {
        functions?.removeAll { $0.id == function.id }
        reindexFunctions()
        markModified()
    }

    private func reindexFunctions() {
        for (index, func_) in sortedFunctions.enumerated() {
            func_.sortOrder = index
        }
    }

    // MARK: - Block Management

    func setRootBlock(_ block: ViewBlock) {
        rootBlock = block
        markModified()
    }

    // MARK: - Lookup

    func property(named name: String) -> ViewProperty? {
        properties?.first { $0.name == name }
    }

    func function(named name: String) -> ViewFunction? {
        functions?.first { $0.name == name }
    }

    // MARK: - Flattened Block List

    func allBlocks() -> [ViewBlock] {
        guard let root = rootBlock else { return [] }
        return flattenBlocks(root)
    }

    private func flattenBlocks(_ block: ViewBlock) -> [ViewBlock] {
        var result = [block]
        for child in block.sortedChildren {
            result.append(contentsOf: flattenBlocks(child))
        }
        return result
    }

    // MARK: - Update

    func markModified() {
        modifiedAt = Date()
        project?.markModified()
    }
}

// MARK: - ProjectFile Protocol Conformance

