//
//  ModelNavigatorView.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import SwiftUI
import SwiftData

/// Navigator for Data Model files showing versions, properties, and relationships
struct ModelNavigatorView: View {
    @Environment(AppStore.self) private var appStore
    @Environment(\.modelContext) private var modelContext

    @State private var isVersionsExpanded = true
    @State private var isPropertiesExpanded = true
    @State private var isRelationshipsExpanded = true

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                if let dataModel = currentDataModel {
                    // Versions section
                    versionsSection(dataModel)

                    Divider()
                        .padding(.vertical, 4)

                    // Current version details
                    if let currentVersion = dataModel.currentVersion {
                        // Properties section
                        propertiesSection(currentVersion)

                        Divider()
                            .padding(.vertical, 4)

                        // Relationships section
                        relationshipsSection(currentVersion)
                    } else {
                        CompactEmptyState(message: "No version selected", systemImage: "doc.badge.clock")
                    }
                } else {
                    CompactEmptyState(message: "No model selected", systemImage: "tablecells")
                }
            }
            .padding(.vertical, 8)
        }
    }

    // MARK: - Current Data Model

    private var currentDataModel: DataModel? {
        guard let fileId = appStore.selectedFileId,
              appStore.selectedFileType == .dataModel else {
            return nil
        }

        let descriptor = FetchDescriptor<DataModel>(
            predicate: #Predicate { $0.id == fileId }
        )

        return try? modelContext.fetch(descriptor).first
    }

    // MARK: - Versions Section

    @ViewBuilder
    private func versionsSection(_ dataModel: DataModel) -> some View {
        CollapsibleSection(
            isExpanded: $isVersionsExpanded,
            header: {
                HStack {
                    Text("Versions")
                        .font(.headline)

                    Spacer()

                    Button(action: { createNewVersion(for: dataModel) }) {
                        Image(systemName: "plus")
                            .font(.system(size: 10))
                    }
                    .buttonStyle(.plain)
                }
            },
            content: {
                ForEach(dataModel.sortedVersions) { version in
                    versionRow(version, in: dataModel)
                }
            }
        )
    }

    @ViewBuilder
    private func versionRow(_ version: ModelVersion, in dataModel: DataModel) -> some View {
        let isSelected = appStore.selection.selectedVersionId == version.id
        let isCurrent = dataModel.currentVersionId == version.id

        HStack(spacing: 8) {
            Image(systemName: isCurrent ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 12))
                .foregroundStyle(isCurrent ? Color.green : Color.gray.opacity(0.5))

            Text("v\(version.versionNumber)")
                .font(.system(size: 12, design: .monospaced))

            if isCurrent {
                Text("Current")
                    .font(.system(size: 9, weight: .medium))
                    .foregroundStyle(.green)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 2)
                    .background(Color.green.opacity(0.15))
                    .clipShape(Capsule())
            }

            Spacer()

            Text("\(version.sortedProperties.count)p")
                .font(.system(size: 10))
                .foregroundStyle(.tertiary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .background(isSelected ? Color.accentColor.opacity(0.15) : Color.clear)
        .contentShape(Rectangle())
        .onTapGesture {
            appStore.selection.selectVersion(id: version.id)
        }
    }

    // MARK: - Properties Section

    @ViewBuilder
    private func propertiesSection(_ version: ModelVersion) -> some View {
        CollapsibleSection(
            isExpanded: $isPropertiesExpanded,
            header: {
                HStack {
                    Text("Properties")
                        .font(.headline)

                    Spacer()

                    Button(action: addProperty) {
                        Image(systemName: "plus")
                            .font(.system(size: 10))
                    }
                    .buttonStyle(.plain)
                }
            },
            content: {
                if version.sortedProperties.isEmpty {
                    CompactEmptyState(message: "No properties", systemImage: "list.bullet")
                } else {
                    ForEach(version.sortedProperties) { property in
                        modelPropertyRow(property)
                    }
                }
            }
        )
    }

    @ViewBuilder
    private func modelPropertyRow(_ property: ModelProperty) -> some View {
        let isSelected = appStore.selection.selectedModelPropertyId == property.id

        HStack(spacing: 4) {
            // Attributes indicators
            HStack(spacing: 2) {
                if property.isUnique {
                    Image(systemName: "key")
                        .font(.system(size: 9))
                        .foregroundStyle(.orange)
                }
                if property.isOptional {
                    Text("?")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.purple)
                }
            }
            .frame(width: 20, alignment: .trailing)

            Text(property.name)
                .font(.system(size: 12, design: .monospaced))
                .foregroundStyle(.primary)

            Text(":")
                .font(.system(size: 12, design: .monospaced))
                .foregroundStyle(.secondary)

            Text(property.typeDisplayName)
                .font(.system(size: 12, design: .monospaced))
                .foregroundStyle(.cyan)

            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .background(isSelected ? Color.accentColor.opacity(0.15) : Color.clear)
        .contentShape(Rectangle())
        .onTapGesture {
            appStore.selection.selectModelProperty(id: property.id)
        }
    }

    // MARK: - Relationships Section

    @ViewBuilder
    private func relationshipsSection(_ version: ModelVersion) -> some View {
        CollapsibleSection(
            isExpanded: $isRelationshipsExpanded,
            header: {
                HStack {
                    Text("Relationships")
                        .font(.headline)

                    Spacer()

                    Button(action: addRelationship) {
                        Image(systemName: "plus")
                            .font(.system(size: 10))
                    }
                    .buttonStyle(.plain)
                }
            },
            content: {
                if version.sortedRelationships.isEmpty {
                    CompactEmptyState(message: "No relationships", systemImage: "arrow.left.arrow.right")
                } else {
                    ForEach(version.sortedRelationships) { relationship in
                        relationshipRow(relationship)
                    }
                }
            }
        )
    }

    @ViewBuilder
    private func relationshipRow(_ relationship: ModelRelationship) -> some View {
        let isSelected = appStore.selection.selectedRelationshipId == relationship.id

        HStack(spacing: 4) {
            Image(systemName: relationship.relationshipType == .oneToOne ? "arrow.right" : "arrow.right.arrow.left")
                .font(.system(size: 10))
                .foregroundStyle(.secondary)
                .frame(width: 16)

            Text(relationship.name)
                .font(.system(size: 12, design: .monospaced))
                .foregroundStyle(.primary)

            Text("->")
                .font(.system(size: 10, design: .monospaced))
                .foregroundStyle(.secondary)

            Text(relationship.targetModelName)
                .font(.system(size: 12, design: .monospaced))
                .foregroundStyle(.green)

            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .background(isSelected ? Color.accentColor.opacity(0.15) : Color.clear)
        .contentShape(Rectangle())
        .onTapGesture {
            appStore.selection.selectRelationship(id: relationship.id)
        }
    }

    // MARK: - Actions

    private func createNewVersion(for dataModel: DataModel) {
        _ = dataModel.createNewVersion()
        try? modelContext.save()
    }

    private func addProperty() {
        // Will be implemented with property editor
    }

    private func addRelationship() {
        // Will be implemented with relationship editor
    }
}

#Preview {
    ModelNavigatorView()
        .environment(AppStore())
        .frame(width: 250, height: 500)
}
