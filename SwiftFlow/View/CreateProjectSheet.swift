//
//  CreateProjectSheet.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import SwiftUI
import SwiftData

/// Sheet for creating a new project
struct CreateProjectSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let onProjectCreated: (Project) -> Void

    @State private var projectName = ""
    @State private var bundleIdentifier = "com.example."
    @State private var createDefaultView = true

    @FocusState private var isNameFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            // Header
            header

            Divider()

            // Form content
            formContent

            Divider()

            // Actions
            actions
        }
        .frame(width: 450, height: 340)
        .background(Color(nsColor: .windowBackgroundColor))
        .onAppear {
            isNameFocused = true
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack(spacing: 12) {
            Image(systemName: "folder.badge.plus")
                .font(.system(size: 28))
                .foregroundStyle(.blue)

            VStack(alignment: .leading, spacing: 2) {
                Text("Create New Project")
                    .font(.headline)

                Text("Set up your new SwiftFlow project")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(20)
    }

    // MARK: - Form Content

    private var formContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Project name
            VStack(alignment: .leading, spacing: 6) {
                Text("Project Name")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.secondary)

                TextField("My App", text: $projectName)
                    .textFieldStyle(.roundedBorder)
                    .focused($isNameFocused)
                    .onChange(of: projectName) { _, newValue in
                        updateBundleIdentifier(from: newValue)
                    }
            }

            // Bundle identifier
            VStack(alignment: .leading, spacing: 6) {
                Text("Bundle Identifier")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.secondary)

                TextField("com.example.myapp", text: $bundleIdentifier)
                    .textFieldStyle(.roundedBorder)
                    .font(.system(size: 13, design: .monospaced))
            }

            // Options
            VStack(alignment: .leading, spacing: 12) {
                Text("Options")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.secondary)

                Toggle(isOn: $createDefaultView) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Create default ContentView")
                            .font(.system(size: 13))

                        Text("Adds a starter view with basic layout")
                            .font(.system(size: 11))
                            .foregroundStyle(.tertiary)
                    }
                }
                .toggleStyle(.checkbox)
            }
        }
        .padding(20)
    }

    // MARK: - Actions

    private var actions: some View {
        HStack {
            Button("Cancel") {
                dismiss()
            }
            .keyboardShortcut(.cancelAction)

            Spacer()

            Button("Create Project") {
                createProject()
            }
            .keyboardShortcut(.defaultAction)
            .disabled(projectName.trimmingCharacters(in: .whitespaces).isEmpty)
        }
        .padding(20)
    }

    // MARK: - Helpers

    private func updateBundleIdentifier(from name: String) {
        let sanitized = name
            .lowercased()
            .replacingOccurrences(of: " ", with: "")
            .filter { $0.isLetter || $0.isNumber }

        if !sanitized.isEmpty {
            bundleIdentifier = "com.example.\(sanitized)"
        }
    }

    private func createProject() {
        let trimmedName = projectName.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else { return }

        // Create the project
        let project = Project(name: trimmedName)
        project.bundleIdentifier = bundleIdentifier

        modelContext.insert(project)

        // Create default view if requested
        if createDefaultView {
            let contentView = ViewFile(name: "ContentView")
            project.addViewFile(contentView)

            // Add a root VStack
            let rootBlock = ViewBlock(blockType: .vStack)
            contentView.setRootBlock(rootBlock)

            // Add welcome text
            let textBlock = ViewBlock(blockType: .text, sortOrder: 0)
            textBlock.textContent = "Hello, World!"
            rootBlock.addChild(textBlock)
        }

        try? modelContext.save()

        // Notify and dismiss
        onProjectCreated(project)
        dismiss()
    }
}

#Preview {
    CreateProjectSheet { project in
        print("Created: \(project.name)")
    }
}
