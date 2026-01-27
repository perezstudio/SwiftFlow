//
//  FileSelectorView.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import SwiftUI
import SwiftData

/// File list showing Views, Data Models, and Queries in sections
struct FileSelectorView: View {
    @Environment(AppStore.self) private var appStore
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \ViewFile.name) private var viewFiles: [ViewFile]
    @Query(sort: \DataModel.name) private var dataModels: [DataModel]
    @Query(sort: \QueryFile.name) private var queryFiles: [QueryFile]

    @State private var isViewsExpanded = true
    @State private var isDataExpanded = true
    @State private var isQueriesExpanded = true

    @State private var showingNewFileSheet = false
    @State private var newFileType: FileType = .view
    @State private var newFileName = ""

    enum FileType {
        case view, dataModel, query
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                // Views section
                fileSection(
                    title: "Views",
                    systemImage: "rectangle.on.rectangle",
                    isExpanded: $isViewsExpanded,
                    count: currentProjectViewFiles.count,
                    onAdd: { showNewFileSheet(type: .view) }
                ) {
                    ForEach(currentProjectViewFiles) { file in
                        FileRowView(
                            name: file.name,
                            systemImage: "doc",
                            isSelected: appStore.selectedFileId == file.id,
                            badge: file.isComponent ? "Component" : nil
                        ) {
                            appStore.selection.selectFile(id: file.id, type: .view)
                        }
                    }
                }

                // Data Models section
                fileSection(
                    title: "Data",
                    systemImage: "cylinder",
                    isExpanded: $isDataExpanded,
                    count: currentProjectDataModels.count,
                    onAdd: { showNewFileSheet(type: .dataModel) }
                ) {
                    ForEach(currentProjectDataModels) { model in
                        FileRowView(
                            name: model.name,
                            systemImage: "tablecells",
                            isSelected: appStore.selectedFileId == model.id,
                            badge: model.versions.map { "\($0.count)v" }
                        ) {
                            appStore.selection.selectFile(id: model.id, type: .dataModel)
                        }
                    }
                }

                // Queries section
                fileSection(
                    title: "Queries",
                    systemImage: "gearshape.2",
                    isExpanded: $isQueriesExpanded,
                    count: currentProjectQueryFiles.count,
                    onAdd: { showNewFileSheet(type: .query) }
                ) {
                    ForEach(currentProjectQueryFiles) { file in
                        FileRowView(
                            name: file.name,
                            systemImage: "function",
                            isSelected: appStore.selectedFileId == file.id
                        ) {
                            appStore.selection.selectFile(id: file.id, type: .query)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingNewFileSheet) {
            NewFileSheet(
                fileType: newFileType,
                fileName: $newFileName,
                onCreate: createNewFile,
                onCancel: { showingNewFileSheet = false }
            )
        }
    }

    // MARK: - Filtered Files (by current project)

    private var currentProjectViewFiles: [ViewFile] {
        guard let project = appStore.currentProject else { return [] }
        return viewFiles.filter { $0.project?.id == project.id }
    }

    private var currentProjectDataModels: [DataModel] {
        guard let project = appStore.currentProject else { return [] }
        return dataModels.filter { $0.project?.id == project.id }
    }

    private var currentProjectQueryFiles: [QueryFile] {
        guard let project = appStore.currentProject else { return [] }
        return queryFiles.filter { $0.project?.id == project.id }
    }

    // MARK: - Section Builder

    @ViewBuilder
    private func fileSection<Content: View>(
        title: String,
        systemImage: String,
        isExpanded: Binding<Bool>,
        count: Int,
        onAdd: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(spacing: 0) {
            // Section header
            Button(action: { withAnimation { isExpanded.wrappedValue.toggle() } }) {
                HStack(spacing: 6) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundStyle(.tertiary)
                        .rotationEffect(.degrees(isExpanded.wrappedValue ? 90 : 0))

                    Image(systemName: systemImage)
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)

                    Text(title)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(.secondary)

                    Text("\(count)")
                        .font(.system(size: 10))
                        .foregroundStyle(.tertiary)

                    Spacer()

                    Button(action: onAdd) {
                        Image(systemName: "plus")
                            .font(.system(size: 10))
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            // Section content
            if isExpanded.wrappedValue {
                content()
            }
        }
    }

    // MARK: - Actions

    private func showNewFileSheet(type: FileType) {
        newFileType = type
        newFileName = ""
        showingNewFileSheet = true
    }

    private func createNewFile() {
        guard !newFileName.isEmpty else { return }

        do {
            switch newFileType {
            case .view:
                try appStore.createViewFile(name: newFileName)
            case .dataModel:
                try appStore.createDataModel(name: newFileName)
            case .query:
                try appStore.createQueryFile(name: newFileName)
            }
        } catch {
            print("Failed to create file: \(error)")
        }

        showingNewFileSheet = false
    }
}

// MARK: - New File Sheet

private struct NewFileSheet: View {
    let fileType: FileSelectorView.FileType
    @Binding var fileName: String
    let onCreate: () -> Void
    let onCancel: () -> Void

    private var fileTypeTitle: String {
        switch fileType {
        case .view: return "View"
        case .dataModel: return "Data Model"
        case .query: return "Query"
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("New \(fileTypeTitle)")
                .font(.headline)

            CustomTextField("Name", text: $fileName)

            HStack {
                Button("Cancel", action: onCancel)
                    .keyboardShortcut(.cancelAction)

                Button("Create", action: onCreate)
                    .keyboardShortcut(.defaultAction)
                    .disabled(fileName.isEmpty)
            }
        }
        .padding()
        .frame(width: 280)
    }
}

#Preview {
    FileSelectorView()
        .environment(AppStore())
        .frame(width: 250, height: 400)
}
