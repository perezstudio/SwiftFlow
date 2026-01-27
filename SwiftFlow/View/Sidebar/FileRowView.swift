//
//  FileRowView.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import SwiftUI

/// A row displaying a file in the sidebar
struct FileRowView: View {
    let name: String
    let systemImage: String
    var isSelected: Bool = false
    var badge: String? = nil
    var badgeColor: Color = .secondary
    let onSelect: () -> Void

    @State private var isHovered = false

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: systemImage)
                .font(.system(size: 13))
                .foregroundStyle(isSelected ? .primary : .secondary)
                .frame(width: 18)

            Text(name)
                .font(.system(size: 12))
                .foregroundStyle(.primary)
                .lineLimit(1)

            Spacer()

            if let badge {
                Text(badge)
                    .font(.system(size: 9, weight: .medium))
                    .foregroundStyle(badgeColor)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 2)
                    .background(badgeColor.opacity(0.15))
                    .clipShape(Capsule())
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 5)
        .background(
            Group {
                if isSelected {
                    Color.accentColor.opacity(0.15)
                } else if isHovered {
                    Color(nsColor: .separatorColor).opacity(0.3)
                } else {
                    Color.clear
                }
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .padding(.horizontal, 4)
        .contentShape(Rectangle())
        .onTapGesture(perform: onSelect)
        .onHover { hovering in
            isHovered = hovering
        }
        .contextMenu {
            Button("Rename") {
                // Rename action
            }
            Button("Duplicate") {
                // Duplicate action
            }
            Divider()
            Button("Delete", role: .destructive) {
                // Delete action
            }
        }
    }
}

/// A draggable file row for reordering
struct DraggableFileRow: View {
    let name: String
    let systemImage: String
    let id: UUID
    var isSelected: Bool = false
    let onSelect: () -> Void

    var body: some View {
        FileRowView(
            name: name,
            systemImage: systemImage,
            isSelected: isSelected,
            onSelect: onSelect
        )
        .draggable(id.uuidString) {
            // Drag preview
            HStack(spacing: 8) {
                Image(systemName: systemImage)
                Text(name)
            }
            .padding(8)
            .background(Color(nsColor: .controlBackgroundColor))
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .shadow(radius: 4)
        }
    }
}

/// An editable file row for renaming
struct EditableFileRow: View {
    let systemImage: String
    @Binding var name: String
    @Binding var isEditing: Bool
    var isSelected: Bool = false
    let onSelect: () -> Void
    let onCommit: () -> Void

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: systemImage)
                .font(.system(size: 13))
                .foregroundStyle(isSelected ? .primary : .secondary)
                .frame(width: 18)

            if isEditing {
                TextField("Name", text: $name)
                    .textFieldStyle(.plain)
                    .font(.system(size: 12))
                    .focused($isFocused)
                    .onSubmit {
                        isEditing = false
                        onCommit()
                    }
                    .onAppear {
                        isFocused = true
                    }
            } else {
                Text(name)
                    .font(.system(size: 12))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
            }

            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 5)
        .background(isSelected ? Color.accentColor.opacity(0.15) : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .padding(.horizontal, 4)
        .contentShape(Rectangle())
        .onTapGesture(perform: onSelect)
        .onTapGesture(count: 2) {
            isEditing = true
        }
    }
}

#Preview {
    VStack(spacing: 0) {
        FileRowView(
            name: "ContentView",
            systemImage: "doc",
            isSelected: true,
            badge: "Entry"
        ) {}

        FileRowView(
            name: "DetailView",
            systemImage: "doc",
            isSelected: false
        ) {}

        FileRowView(
            name: "Item",
            systemImage: "tablecells",
            isSelected: false,
            badge: "2v",
            badgeColor: .orange
        ) {}

        FileRowView(
            name: "ItemStore",
            systemImage: "function",
            isSelected: false
        ) {}
    }
    .frame(width: 220)
    .padding(.vertical, 8)
}
