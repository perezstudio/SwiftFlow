//
//  Project.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import Foundation
import SwiftData

/// Root model representing a SwiftFlow project
@Model
final class Project {
    @Attribute(.unique) var id: UUID
    var name: String
    var createdAt: Date
    var modifiedAt: Date

    // Project settings
    var bundleIdentifier: String?
    var deploymentTarget: String?
    var organizationName: String?

    // Relationships - View files
    @Relationship(deleteRule: .cascade, inverse: \ViewFile.project)
    var viewFiles: [ViewFile]?

    // Relationships - Data models
    @Relationship(deleteRule: .cascade, inverse: \DataModel.project)
    var dataModels: [DataModel]?

    // Relationships - Query files
    @Relationship(deleteRule: .cascade, inverse: \QueryFile.project)
    var queryFiles: [QueryFile]?

    // Relationships - Assets
    @Relationship(deleteRule: .cascade, inverse: \Asset.project)
    var assets: [Asset]?

    init(
        id: UUID = UUID(),
        name: String
    ) {
        self.id = id
        self.name = name
        self.createdAt = Date()
        self.modifiedAt = Date()
        self.viewFiles = []
        self.dataModels = []
        self.queryFiles = []
        self.assets = []
    }

    // MARK: - Convenience Accessors

    var sortedViewFiles: [ViewFile] {
        (viewFiles ?? []).sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    var sortedDataModels: [DataModel] {
        (dataModels ?? []).sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    var sortedQueryFiles: [QueryFile] {
        (queryFiles ?? []).sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    var sortedAssets: [Asset] {
        (assets ?? []).sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    // MARK: - File Management

    func addViewFile(_ file: ViewFile) {
        file.project = self
        if viewFiles == nil {
            viewFiles = []
        }
        viewFiles?.append(file)
        markModified()
    }

    func addDataModel(_ model: DataModel) {
        model.project = self
        if dataModels == nil {
            dataModels = []
        }
        dataModels?.append(model)
        markModified()
    }

    func addQueryFile(_ file: QueryFile) {
        file.project = self
        if queryFiles == nil {
            queryFiles = []
        }
        queryFiles?.append(file)
        markModified()
    }

    func addAsset(_ asset: Asset) {
        asset.project = self
        if assets == nil {
            assets = []
        }
        assets?.append(asset)
        markModified()
    }

    func removeViewFile(_ file: ViewFile) {
        viewFiles?.removeAll { $0.id == file.id }
        markModified()
    }

    func removeDataModel(_ model: DataModel) {
        dataModels?.removeAll { $0.id == model.id }
        markModified()
    }

    func removeQueryFile(_ file: QueryFile) {
        queryFiles?.removeAll { $0.id == file.id }
        markModified()
    }

    func removeAsset(_ asset: Asset) {
        assets?.removeAll { $0.id == asset.id }
        markModified()
    }

    // MARK: - Lookup

    func viewFile(named name: String) -> ViewFile? {
        viewFiles?.first { $0.name == name }
    }

    func dataModel(named name: String) -> DataModel? {
        dataModels?.first { $0.name == name }
    }

    func queryFile(named name: String) -> QueryFile? {
        queryFiles?.first { $0.name == name }
    }

    func asset(named name: String) -> Asset? {
        assets?.first { $0.name == name }
    }

    // MARK: - Statistics

    var totalFileCount: Int {
        (viewFiles?.count ?? 0) + (dataModels?.count ?? 0) + (queryFiles?.count ?? 0)
    }

    var totalAssetCount: Int {
        assets?.count ?? 0
    }

    // MARK: - Update

    func markModified() {
        modifiedAt = Date()
    }
}
