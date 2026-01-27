//
//  QueryFile.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import Foundation
import SwiftData

/// Represents an @Observable query/service object in the project
@Model
final class QueryFile {
    @Attribute(.unique) var id: UUID
    var name: String
    var createdAt: Date
    var modifiedAt: Date

    // Relationship to project
    var project: Project?

    // Properties in the observable object
    @Relationship(deleteRule: .cascade, inverse: \QueryProperty.queryFile)
    var properties: [QueryProperty]?

    // Functions in the observable object
    @Relationship(deleteRule: .cascade, inverse: \QueryFunction.queryFile)
    var functions: [QueryFunction]?

    init(
        id: UUID = UUID(),
        name: String
    ) {
        self.id = id
        self.name = name
        self.createdAt = Date()
        self.modifiedAt = Date()
        self.properties = []
        self.functions = []
    }

    // MARK: - Properties

    var sortedProperties: [QueryProperty] {
        (properties ?? []).sorted { $0.sortOrder < $1.sortOrder }
    }

    func addProperty(_ property: QueryProperty) {
        property.queryFile = self
        property.sortOrder = (properties ?? []).count
        if properties == nil {
            properties = []
        }
        properties?.append(property)
        markModified()
    }

    func removeProperty(_ property: QueryProperty) {
        properties?.removeAll { $0.id == property.id }
        reindexProperties()
        markModified()
    }

    private func reindexProperties() {
        for (index, prop) in sortedProperties.enumerated() {
            prop.sortOrder = index
        }
    }

    // MARK: - Functions

    var sortedFunctions: [QueryFunction] {
        (functions ?? []).sorted { $0.sortOrder < $1.sortOrder }
    }

    func addFunction(_ function: QueryFunction) {
        function.queryFile = self
        function.sortOrder = (functions ?? []).count
        if functions == nil {
            functions = []
        }
        functions?.append(function)
        markModified()
    }

    func removeFunction(_ function: QueryFunction) {
        functions?.removeAll { $0.id == function.id }
        reindexFunctions()
        markModified()
    }

    private func reindexFunctions() {
        for (index, func_) in sortedFunctions.enumerated() {
            func_.sortOrder = index
        }
    }

    // MARK: - Lookup

    func property(named name: String) -> QueryProperty? {
        properties?.first { $0.name == name }
    }

    func function(named name: String) -> QueryFunction? {
        functions?.first { $0.name == name }
    }

    // MARK: - Update

    func markModified() {
        modifiedAt = Date()
        project?.markModified()
    }
}
