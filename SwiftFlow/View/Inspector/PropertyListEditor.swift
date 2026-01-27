//
//  PropertyListEditor.swift
//  SwiftFlow
//
//  Created on 1/27/26.
//

import SwiftUI
import SwiftData

/// Editor for managing view properties (@State, @Binding, etc.)
struct PropertyListEditor: View {
    @Bindable var viewFile: ViewFile
    @Environment(\.modelContext) private var modelContext

    @State private var selectedPropertyId: UUID?
    @State private var showingAddSheet = false

    var body: some View {
        CollapsibleSectionLocal("Properties", initiallyExpanded: true) {
            VStack(spacing: 4) {
                if viewFile.sortedProperties.isEmpty {
                    emptyState
                } else {
                    ForEach(viewFile.sortedProperties) { property in
                        PropertyRowView(
                            property: property,
                            isSelected: selectedPropertyId == property.id,
                            onSelect: { selectedPropertyId = property.id },
                            onDelete: { deleteProperty(property) }
                        )
                    }
                }

                // Add button
                addButton
            }
            .padding(.vertical, 4)
        }
        .sheet(isPresented: $showingAddSheet) {
            AddPropertySheet(viewFile: viewFile) { property in
                selectedPropertyId = property.id
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 8) {
            Image(systemName: "tray")
                .font(.system(size: 20))
                .foregroundStyle(.tertiary)

            Text("No Properties")
                .font(.system(size: 11))
                .foregroundStyle(.secondary)

            Text("Add @State, @Binding, and other properties")
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

                Text("Add Property")
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

    private func deleteProperty(_ property: ViewProperty) {
        if selectedPropertyId == property.id {
            selectedPropertyId = nil
        }
        viewFile.removeProperty(property)
        modelContext.delete(property)
    }
}

#Preview {
    PropertyListEditor(viewFile: ViewFile(name: "ContentView"))
        .frame(width: 280)
        .padding()
}
