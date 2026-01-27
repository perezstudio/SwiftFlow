//
//  FunctionListEditor.swift
//  SwiftFlow
//
//  Created on 1/27/26.
//

import SwiftUI
import SwiftData

/// Editor for managing view functions
struct FunctionListEditor: View {
    @Bindable var viewFile: ViewFile
    @Environment(\.modelContext) private var modelContext

    @State private var selectedFunctionId: UUID?
    @State private var showingAddSheet = false

    var body: some View {
        CollapsibleSectionLocal("Functions", initiallyExpanded: true) {
            VStack(spacing: 4) {
                if viewFile.sortedFunctions.isEmpty {
                    emptyState
                } else {
                    ForEach(viewFile.sortedFunctions) { function in
                        FunctionRowView(
                            function: function,
                            isSelected: selectedFunctionId == function.id,
                            onSelect: { selectedFunctionId = function.id },
                            onDelete: { deleteFunction(function) }
                        )
                    }
                }

                // Add button
                addButton
            }
            .padding(.vertical, 4)
        }
        .sheet(isPresented: $showingAddSheet) {
            AddFunctionSheet(viewFile: viewFile) { function in
                selectedFunctionId = function.id
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 8) {
            Image(systemName: "function")
                .font(.system(size: 20))
                .foregroundStyle(.tertiary)

            Text("No Functions")
                .font(.system(size: 11))
                .foregroundStyle(.secondary)

            Text("Add custom functions to your view")
                .font(.system(size: 10))
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
    }

    private var addButton: some View {
        Button(action: { showingAddSheet = true }) {
            HStack(spacing: 4) {
                Image(systemName: "plus")
                    .font(.system(size: 10, weight: .medium))

                Text("Add Function")
                    .font(.system(size: 11, weight: .medium))
            }
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 6)
            .background(Color(nsColor: .controlBackgroundColor).opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .buttonStyle(.plain)
    }

    private func deleteFunction(_ function: ViewFunction) {
        if selectedFunctionId == function.id {
            selectedFunctionId = nil
        }
        viewFile.removeFunction(function)
        modelContext.delete(function)
    }
}

// MARK: - Add Function Sheet

struct AddFunctionSheet: View {
    @Bindable var viewFile: ViewFile
    var onAdd: ((ViewFunction) -> Void)?

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var functionName = ""
    @State private var isAsync = false
    @State private var throwsError = false
    @State private var hasReturnType = false
    @State private var returnType: TypeDefinition = .void

    var body: some View {
        VStack(spacing: 0) {
            // Header
            header

            Divider()

            // Form
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    nameSection
                    modifiersSection

                    if hasReturnType {
                        returnTypeSection
                    }
                }
                .padding(16)
            }

            Divider()

            // Footer
            footer
        }
        .frame(width: 320, height: 360)
    }

    private var header: some View {
        HStack {
            Text("Add Function")
                .font(.headline)

            Spacer()

            Button(action: { dismiss() }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(.tertiary)
            }
            .buttonStyle(.plain)
        }
        .padding(16)
    }

    private var nameSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Name")
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.secondary)

            TextField("functionName", text: $functionName)
                .textFieldStyle(.roundedBorder)
                .font(.system(size: 13, design: .monospaced))
        }
    }

    private var modifiersSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Modifiers")
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.secondary)

            Toggle("async", isOn: $isAsync)
                .font(.system(size: 12, design: .monospaced))

            Toggle("throws", isOn: $throwsError)
                .font(.system(size: 12, design: .monospaced))

            Toggle("Has return type", isOn: $hasReturnType)
                .font(.system(size: 12))
        }
    }

    private var returnTypeSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Return Type")
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.secondary)

            TypeSelector(selectedType: $returnType)
        }
    }

    private var footer: some View {
        HStack {
            Button("Cancel") {
                dismiss()
            }
            .keyboardShortcut(.escape, modifiers: [])

            Spacer()

            Button("Add Function") {
                addFunction()
            }
            .keyboardShortcut(.return, modifiers: .command)
            .disabled(!isValid)
            .buttonStyle(.borderedProminent)
        }
        .padding(16)
    }

    private var isValid: Bool {
        guard !functionName.isEmpty else { return false }
        guard functionName.first?.isLetter == true else { return false }
        return true
    }

    private func addFunction() {
        let function = ViewFunction(
            name: functionName,
            isAsync: isAsync,
            throwsError: throwsError,
            returnType: hasReturnType ? returnType : nil
        )

        viewFile.addFunction(function)
        onAdd?(function)
        dismiss()
    }
}

#Preview {
    FunctionListEditor(viewFile: ViewFile(name: "ContentView"))
        .frame(width: 280)
        .padding()
}
