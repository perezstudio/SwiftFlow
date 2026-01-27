//
//  FileInspectorView.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import SwiftUI
import SwiftData

/// Inspector for file-level settings
struct FileInspectorView: View {
    let fileId: UUID
    let fileType: SelectionStore.FileType

    @Environment(\.modelContext) private var modelContext

    var body: some View {
        VStack(spacing: 0) {
            switch fileType {
            case .view:
                if let viewFile = fetchViewFile() {
                    ViewFileInspector(viewFile: viewFile)
                }
            case .dataModel:
                if let dataModel = fetchDataModel() {
                    DataModelFileInspector(dataModel: dataModel)
                }
            case .query:
                if let queryFile = fetchQueryFile() {
                    QueryFileInspector(queryFile: queryFile)
                }
            }
        }
    }

    // MARK: - Data Fetching

    private func fetchViewFile() -> ViewFile? {
        let descriptor = FetchDescriptor<ViewFile>(
            predicate: #Predicate { $0.id == fileId }
        )
        return try? modelContext.fetch(descriptor).first
    }

    private func fetchDataModel() -> DataModel? {
        let descriptor = FetchDescriptor<DataModel>(
            predicate: #Predicate { $0.id == fileId }
        )
        return try? modelContext.fetch(descriptor).first
    }

    private func fetchQueryFile() -> QueryFile? {
        let descriptor = FetchDescriptor<QueryFile>(
            predicate: #Predicate { $0.id == fileId }
        )
        return try? modelContext.fetch(descriptor).first
    }
}

// MARK: - View File Inspector

private struct ViewFileInspector: View {
    @Bindable var viewFile: ViewFile
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        VStack(spacing: 0) {
            // File info section
            InspectorSection( "File Info") {
                LabeledContent("Name") {
                    TextField("Name", text: $viewFile.name)
                        .textFieldStyle(.plain)
                        .multilineTextAlignment(.trailing)
                }

                LabeledContent("Type") {
                    Text("View")
                        .foregroundStyle(.secondary)
                }

                Toggle("Is Component", isOn: $viewFile.isComponent)
            }

            Divider()
                .padding(.vertical, 8)

            // Statistics section
            InspectorSection( "Statistics") {
                LabeledContent("Blocks") {
                    Text("\(viewFile.allBlocks().count)")
                        .foregroundStyle(.secondary)
                }

                LabeledContent("Properties") {
                    Text("\(viewFile.sortedProperties.count)")
                        .foregroundStyle(.secondary)
                }

                LabeledContent("Functions") {
                    Text("\(viewFile.sortedFunctions.count)")
                        .foregroundStyle(.secondary)
                }
            }

            Divider()
                .padding(.vertical, 8)

            // Timestamps section
            InspectorSection( "Timestamps") {
                LabeledContent("Created") {
                    Text(viewFile.createdAt, style: .date)
                        .foregroundStyle(.secondary)
                }

                LabeledContent("Modified") {
                    Text(viewFile.modifiedAt, style: .date)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Data Model File Inspector

private struct DataModelFileInspector: View {
    @Bindable var dataModel: DataModel
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        VStack(spacing: 0) {
            // File info section
            InspectorSection( "Model Info") {
                LabeledContent("Name") {
                    TextField("Name", text: $dataModel.name)
                        .textFieldStyle(.plain)
                        .multilineTextAlignment(.trailing)
                }

                LabeledContent("Type") {
                    Text("Data Model")
                        .foregroundStyle(.secondary)
                }
            }

            Divider()
                .padding(.vertical, 8)

            // Version info
            InspectorSection( "Versioning") {
                LabeledContent("Current Version") {
                    if let version = dataModel.currentVersion {
                        Text("v\(version.versionNumber)")
                            .foregroundStyle(.secondary)
                    } else {
                        Text("None")
                            .foregroundStyle(.tertiary)
                    }
                }

                LabeledContent("Total Versions") {
                    Text("\(dataModel.sortedVersions.count)")
                        .foregroundStyle(.secondary)
                }
            }

            Divider()
                .padding(.vertical, 8)

            // Timestamps section
            InspectorSection( "Timestamps") {
                LabeledContent("Created") {
                    Text(dataModel.createdAt, style: .date)
                        .foregroundStyle(.secondary)
                }

                LabeledContent("Modified") {
                    Text(dataModel.modifiedAt, style: .date)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Query File Inspector

private struct QueryFileInspector: View {
    @Bindable var queryFile: QueryFile
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        VStack(spacing: 0) {
            // File info section
            InspectorSection( "Query Info") {
                LabeledContent("Name") {
                    TextField("Name", text: $queryFile.name)
                        .textFieldStyle(.plain)
                        .multilineTextAlignment(.trailing)
                }

                LabeledContent("Type") {
                    Text("Query")
                        .foregroundStyle(.secondary)
                }
            }

            Divider()
                .padding(.vertical, 8)

            // Statistics section
            InspectorSection( "Statistics") {
                LabeledContent("Properties") {
                    Text("\(queryFile.sortedProperties.count)")
                        .foregroundStyle(.secondary)
                }

                LabeledContent("Functions") {
                    Text("\(queryFile.sortedFunctions.count)")
                        .foregroundStyle(.secondary)
                }
            }

            Divider()
                .padding(.vertical, 8)

            // Timestamps section
            InspectorSection( "Timestamps") {
                LabeledContent("Created") {
                    Text(queryFile.createdAt, style: .date)
                        .foregroundStyle(.secondary)
                }

                LabeledContent("Modified") {
                    Text(queryFile.modifiedAt, style: .date)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    FileInspectorView(fileId: UUID(), fileType: .view)
        .frame(width: 280, height: 500)
}
