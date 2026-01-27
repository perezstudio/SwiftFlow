//
//  AddPropertySheet.swift
//  SwiftFlow
//
//  Created on 1/27/26.
//

import SwiftUI
import SwiftData

/// Sheet for adding a new property to a view
struct AddPropertySheet: View {
    @Bindable var viewFile: ViewFile
    var onAdd: ((ViewProperty) -> Void)?

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var propertyName = ""
    @State private var selectedWrapper: PropertyWrapperType = .state
    @State private var selectedType: TypeDefinition = .string
    @State private var defaultValue = ""

    // Environment-specific
    @State private var environmentKeyPath = ""

    // Storage-specific
    @State private var storageKey = ""

    // Query-specific
    @State private var queryModelType = ""

    var body: some View {
        VStack(spacing: 0) {
            // Header
            header

            Divider()

            // Form
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    nameSection
                    wrapperSection
                    typeSection

                    // Wrapper-specific options
                    switch selectedWrapper {
                    case .environment:
                        environmentSection
                    case .appStorage, .sceneStorage:
                        storageSection
                    case .query:
                        querySection
                    default:
                        if selectedWrapper.requiresInitialValue {
                            defaultValueSection
                        }
                    }
                }
                .padding(16)
            }

            Divider()

            // Footer
            footer
        }
        .frame(width: 340, height: 480)
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Text("Add Property")
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

    // MARK: - Form Sections

    private var nameSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Name")
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.secondary)

            TextField("propertyName", text: $propertyName)
                .textFieldStyle(.roundedBorder)
                .font(.system(size: 13, design: .monospaced))
        }
    }

    private var wrapperSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Property Wrapper")
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.secondary)

            // Group by category
            ForEach(PropertyWrapperCategory.allCases.filter { !$0.wrappers.isEmpty && $0 != .plain }) { category in
                VStack(alignment: .leading, spacing: 4) {
                    Text(category.displayName)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(.tertiary)
                        .padding(.top, 4)

                    FlowLayout(spacing: 4) {
                        ForEach(category.wrappers) { wrapper in
                            wrapperChip(wrapper)
                        }
                    }
                }
            }
        }
    }

    private func wrapperChip(_ wrapper: PropertyWrapperType) -> some View {
        Button(action: { selectedWrapper = wrapper }) {
            Text(wrapper.displayName)
                .font(.system(size: 11, weight: .medium, design: .monospaced))
                .foregroundStyle(selectedWrapper == wrapper ? .white : .primary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(selectedWrapper == wrapper ? Color.accentColor : Color(nsColor: .controlBackgroundColor))
                )
        }
        .buttonStyle(.plain)
        .help(wrapper.description)
    }

    private var typeSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Type")
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.secondary)

            TypeSelector(selectedType: $selectedType)
        }
    }

    private var defaultValueSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Default Value")
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.secondary)

            TextField("value", text: $defaultValue)
                .textFieldStyle(.roundedBorder)
                .font(.system(size: 13, design: .monospaced))

            Text("Enter a valid Swift expression")
                .font(.system(size: 10))
                .foregroundStyle(.tertiary)
        }
    }

    private var environmentSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Environment Key Path")
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.secondary)

            TextField("colorScheme", text: $environmentKeyPath)
                .textFieldStyle(.roundedBorder)
                .font(.system(size: 13, design: .monospaced))

            Text("e.g., colorScheme, dismiss, modelContext")
                .font(.system(size: 10))
                .foregroundStyle(.tertiary)
        }
    }

    private var storageSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Storage Key")
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.secondary)

            TextField("settingKey", text: $storageKey)
                .textFieldStyle(.roundedBorder)
                .font(.system(size: 13, design: .monospaced))

            if !defaultValue.isEmpty {
                // Also show default value for storage
            }

            defaultValueSection
        }
    }

    private var querySection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Model Type")
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.secondary)

            TextField("Item", text: $queryModelType)
                .textFieldStyle(.roundedBorder)
                .font(.system(size: 13, design: .monospaced))

            Text("The SwiftData model type to query")
                .font(.system(size: 10))
                .foregroundStyle(.tertiary)
        }
    }

    // MARK: - Footer

    private var footer: some View {
        HStack {
            Button("Cancel") {
                dismiss()
            }
            .keyboardShortcut(.escape, modifiers: [])

            Spacer()

            Button("Add Property") {
                addProperty()
            }
            .keyboardShortcut(.return, modifiers: .command)
            .disabled(!isValid)
            .buttonStyle(.borderedProminent)
        }
        .padding(16)
    }

    // MARK: - Validation

    private var isValid: Bool {
        guard !propertyName.isEmpty else { return false }
        guard propertyName.first?.isLetter == true else { return false }

        switch selectedWrapper {
        case .environment:
            return !environmentKeyPath.isEmpty
        case .appStorage, .sceneStorage:
            return !storageKey.isEmpty
        case .query:
            return !queryModelType.isEmpty
        default:
            return true
        }
    }

    // MARK: - Actions

    private func addProperty() {
        let property: ViewProperty

        switch selectedWrapper {
        case .environment:
            property = ViewProperty.environment(
                name: propertyName,
                keyPath: environmentKeyPath,
                type: selectedType
            )
        case .appStorage, .sceneStorage:
            property = ViewProperty(
                name: propertyName,
                propertyWrapper: selectedWrapper,
                typeDefinition: selectedType,
                defaultValue: defaultValue.isEmpty ? nil : defaultValue
            )
            property.storageKey = storageKey
        case .query:
            property = ViewProperty.query(name: propertyName, modelType: queryModelType)
        default:
            property = ViewProperty(
                name: propertyName,
                propertyWrapper: selectedWrapper,
                typeDefinition: selectedType,
                defaultValue: defaultValue.isEmpty ? nil : defaultValue
            )
        }

        viewFile.addProperty(property)
        onAdd?(property)
        dismiss()
    }
}

// MARK: - Flow Layout

/// A simple flow layout for wrapping chips
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.width ?? 0, subviews: subviews, spacing: spacing)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x,
                                       y: bounds.minY + result.positions[index].y),
                         proposal: .unspecified)
        }
    }

    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []

        init(in width: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var rowHeight: CGFloat = 0

            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)

                if x + size.width > width && x > 0 {
                    x = 0
                    y += rowHeight + spacing
                    rowHeight = 0
                }

                positions.append(CGPoint(x: x, y: y))
                rowHeight = max(rowHeight, size.height)
                x += size.width + spacing
            }

            self.size = CGSize(width: width, height: y + rowHeight)
        }
    }
}

#Preview {
    AddPropertySheet(viewFile: ViewFile(name: "ContentView"))
}
