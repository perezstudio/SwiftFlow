//
//  QueryNavigatorView.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import SwiftUI
import SwiftData

/// Navigator for Query files showing properties and functions
struct QueryNavigatorView: View {
    @Environment(AppStore.self) private var appStore
    @Environment(\.modelContext) private var modelContext

    @State private var isPropertiesExpanded = true
    @State private var isFunctionsExpanded = true

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                if let queryFile = currentQueryFile {
                    // Properties section
                    propertiesSection(queryFile)

                    Divider()
                        .padding(.vertical, 4)

                    // Functions section
                    functionsSection(queryFile)
                } else {
                    CompactEmptyState(message: "No query selected", systemImage: "function")
                }
            }
            .padding(.vertical, 8)
        }
    }

    // MARK: - Current Query File

    private var currentQueryFile: QueryFile? {
        guard let fileId = appStore.selectedFileId,
              appStore.selectedFileType == .query else {
            return nil
        }

        let descriptor = FetchDescriptor<QueryFile>(
            predicate: #Predicate { $0.id == fileId }
        )

        return try? modelContext.fetch(descriptor).first
    }

    // MARK: - Properties Section

    @ViewBuilder
    private func propertiesSection(_ queryFile: QueryFile) -> some View {
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
                if queryFile.sortedProperties.isEmpty {
                    CompactEmptyState(message: "No properties", systemImage: "list.bullet")
                } else {
                    ForEach(queryFile.sortedProperties) { property in
                        queryPropertyRow(property)
                    }
                }
            }
        )
    }

    @ViewBuilder
    private func queryPropertyRow(_ property: QueryProperty) -> some View {
        let isSelected = appStore.selection.selectedPropertyId == property.id

        HStack(spacing: 4) {
            // Access modifier indicator
            if property.isPrivate {
                Text("private")
                    .font(.system(size: 9, design: .monospaced))
                    .foregroundStyle(.purple)
            } else if property.isPrivateSetter {
                Text("private(set)")
                    .font(.system(size: 9, design: .monospaced))
                    .foregroundStyle(.purple)
            }

            Text("var")
                .font(.system(size: 11, design: .monospaced))
                .foregroundStyle(.pink)

            Text(property.name)
                .font(.system(size: 12, design: .monospaced))
                .foregroundStyle(.primary)

            Text(":")
                .font(.system(size: 12, design: .monospaced))
                .foregroundStyle(.secondary)

            Text(property.typeDefinition.toSwiftCode())
                .font(.system(size: 12, design: .monospaced))
                .foregroundStyle(.cyan)

            Spacer()

            if property.isObservationIgnored {
                Image(systemName: "eye.slash")
                    .font(.system(size: 9))
                    .foregroundStyle(.orange)
                    .help("@ObservationIgnored")
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .background(isSelected ? Color.accentColor.opacity(0.15) : Color.clear)
        .contentShape(Rectangle())
        .onTapGesture {
            appStore.selection.selectProperty(id: property.id)
        }
    }

    // MARK: - Functions Section

    @ViewBuilder
    private func functionsSection(_ queryFile: QueryFile) -> some View {
        CollapsibleSection(
            isExpanded: $isFunctionsExpanded,
            header: {
                HStack {
                    Text("Functions")
                        .font(.headline)

                    Spacer()

                    Button(action: addFunction) {
                        Image(systemName: "plus")
                            .font(.system(size: 10))
                    }
                    .buttonStyle(.plain)
                }
            },
            content: {
                if queryFile.sortedFunctions.isEmpty {
                    CompactEmptyState(message: "No functions", systemImage: "function")
                } else {
                    ForEach(queryFile.sortedFunctions) { function in
                        queryFunctionRow(function)
                    }
                }
            }
        )
    }

    @ViewBuilder
    private func queryFunctionRow(_ function: QueryFunction) -> some View {
        let isSelected = appStore.selection.selectedFunctionId == function.id

        HStack(spacing: 4) {
            // Attributes
            VStack(alignment: .trailing, spacing: 1) {
                if function.isMainActor {
                    Text("@MainActor")
                        .font(.system(size: 8, design: .monospaced))
                        .foregroundStyle(.orange)
                }
            }
            .frame(width: 60, alignment: .trailing)

            Text("func")
                .font(.system(size: 11, design: .monospaced))
                .foregroundStyle(.purple)

            Text(function.name)
                .font(.system(size: 12, design: .monospaced))
                .foregroundStyle(.primary)

            Text("()")
                .font(.system(size: 12, design: .monospaced))
                .foregroundStyle(.secondary)

            if function.isAsync {
                Text("async")
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundStyle(.orange)
            }

            if function.throwsError {
                Text("throws")
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundStyle(.red)
            }

            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .background(isSelected ? Color.accentColor.opacity(0.15) : Color.clear)
        .contentShape(Rectangle())
        .onTapGesture {
            appStore.selection.selectFunction(id: function.id)
        }
    }

    // MARK: - Actions

    private func addProperty() {
        // Will be implemented with property editor
    }

    private func addFunction() {
        // Will be implemented with function editor
    }
}

#Preview {
    QueryNavigatorView()
        .environment(AppStore())
        .frame(width: 250, height: 500)
}
