//
//  VariablePickerView.swift
//  SwiftFlow
//
//  Created on 1/27/26.
//

import SwiftUI

/// A picker for selecting variables from available properties and functions
struct VariablePickerView: View {
    let viewFile: ViewFile
    let onSelect: (String, TypeDefinition?) -> Void

    @State private var searchText = ""
    @State private var selectedCategory: VariableCategory = .all

    enum VariableCategory: String, CaseIterable {
        case all = "All"
        case state = "State"
        case bindings = "Bindings"
        case environment = "Environment"
        case functions = "Functions"
    }

    var body: some View {
        VStack(spacing: 0) {
            // Search field
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 12))
                    .foregroundStyle(.tertiary)

                TextField("Search...", text: $searchText)
                    .textFieldStyle(.plain)
                    .font(.system(size: 12))
            }
            .padding(8)
            .background(Color(nsColor: .controlBackgroundColor))

            Divider()

            // Category picker
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 4) {
                    ForEach(VariableCategory.allCases, id: \.self) { category in
                        categoryChip(category)
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
            }

            Divider()

            // Variable list
            ScrollView {
                LazyVStack(spacing: 2) {
                    ForEach(filteredVariables, id: \.name) { variable in
                        variableRow(variable)
                    }

                    if filteredVariables.isEmpty {
                        emptyState
                    }
                }
                .padding(8)
            }
        }
        .frame(width: 260, height: 300)
        .background(Color(nsColor: .windowBackgroundColor))
    }

    private func categoryChip(_ category: VariableCategory) -> some View {
        Button(action: { selectedCategory = category }) {
            Text(category.rawValue)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(selectedCategory == category ? .white : .primary)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(selectedCategory == category ? Color.accentColor : Color(nsColor: .controlBackgroundColor))
                )
        }
        .buttonStyle(.plain)
    }

    private func variableRow(_ variable: VariableInfo) -> some View {
        Button(action: { onSelect(variable.name, variable.type) }) {
            HStack(spacing: 8) {
                // Icon
                Image(systemName: variable.icon)
                    .font(.system(size: 11))
                    .foregroundStyle(variable.color)
                    .frame(width: 16)

                // Name and type
                VStack(alignment: .leading, spacing: 2) {
                    Text(variable.name)
                        .font(.system(size: 12, weight: .medium, design: .monospaced))
                        .foregroundStyle(.primary)

                    if let type = variable.type {
                        Text(type.displayName)
                            .font(.system(size: 10))
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()

                // Wrapper badge
                if let wrapper = variable.wrapper {
                    Text(wrapper)
                        .font(.system(size: 9, weight: .medium, design: .monospaced))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(Color(nsColor: .controlBackgroundColor))
                        .clipShape(RoundedRectangle(cornerRadius: 3))
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private var emptyState: some View {
        VStack(spacing: 8) {
            Image(systemName: "tray")
                .font(.system(size: 24))
                .foregroundStyle(.tertiary)

            Text("No variables found")
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
    }

    // MARK: - Data

    private var filteredVariables: [VariableInfo] {
        var variables: [VariableInfo] = []

        // Properties
        for property in viewFile.sortedProperties {
            let matchesCategory: Bool
            switch selectedCategory {
            case .all:
                matchesCategory = true
            case .state:
                matchesCategory = property.propertyWrapper == .state || property.propertyWrapper == .stateObject
            case .bindings:
                matchesCategory = property.propertyWrapper == .binding || property.propertyWrapper == .bindable
            case .environment:
                matchesCategory = property.propertyWrapper == .environment || property.propertyWrapper == .environmentObject
            case .functions:
                matchesCategory = false
            }

            if matchesCategory {
                variables.append(VariableInfo(
                    name: property.name,
                    type: property.typeDefinition,
                    wrapper: property.propertyWrapper.displayName,
                    icon: "cube",
                    color: colorForWrapper(property.propertyWrapper)
                ))
            }
        }

        // Functions
        if selectedCategory == .all || selectedCategory == .functions {
            for function in viewFile.sortedFunctions {
                variables.append(VariableInfo(
                    name: "\(function.name)()",
                    type: function.returnType,
                    wrapper: nil,
                    icon: "function",
                    color: .orange
                ))
            }
        }

        // Filter by search
        if !searchText.isEmpty {
            variables = variables.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }

        return variables
    }

    private func colorForWrapper(_ wrapper: PropertyWrapperType) -> Color {
        switch wrapper.category {
        case .stateManagement: return .blue
        case .observation: return .purple
        case .swiftData: return .orange
        case .environment: return .green
        case .focus: return .cyan
        case .storage: return .yellow
        case .gesture: return .pink
        case .animation: return .mint
        case .plain: return .gray
        }
    }
}

// MARK: - Variable Info

private struct VariableInfo {
    let name: String
    let type: TypeDefinition?
    let wrapper: String?
    let icon: String
    let color: Color
}

#Preview {
    VariablePickerView(viewFile: ViewFile(name: "ContentView")) { name, type in
        print("Selected: \(name)")
    }
}
