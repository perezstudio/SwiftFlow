//
//  ListRow.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import SwiftUI

/// A selectable list row with consistent styling
struct ListRow<Content: View>: View {
    let isSelected: Bool
    let content: Content
    let onSelect: () -> Void

    init(
        isSelected: Bool = false,
        onSelect: @escaping () -> Void = {},
        @ViewBuilder content: () -> Content
    ) {
        self.isSelected = isSelected
        self.onSelect = onSelect
        self.content = content()
    }

    var body: some View {
        content
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(isSelected ? Color.accentColor.opacity(0.15) : Color.clear)
            .contentShape(Rectangle())
            .onTapGesture(perform: onSelect)
    }
}

/// A file list row with icon and name
struct FileListRow: View {
    let name: String
    let systemImage: String
    let isSelected: Bool
    let onSelect: () -> Void
    let onDoubleClick: (() -> Void)?

    init(
        name: String,
        systemImage: String,
        isSelected: Bool = false,
        onSelect: @escaping () -> Void = {},
        onDoubleClick: (() -> Void)? = nil
    ) {
        self.name = name
        self.systemImage = systemImage
        self.isSelected = isSelected
        self.onSelect = onSelect
        self.onDoubleClick = onDoubleClick
    }

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: systemImage)
                .font(.system(size: 14))
                .foregroundStyle(isSelected ? .primary : .secondary)
                .frame(width: 20)

            Text(name)
                .font(.system(size: 13))
                .foregroundStyle(.primary)
                .lineLimit(1)

            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(isSelected ? Color.accentColor.opacity(0.15) : Color.clear)
        .contentShape(Rectangle())
        .onTapGesture(perform: onSelect)
        .onTapGesture(count: 2) {
            onDoubleClick?()
        }
    }
}

/// A property list row
struct PropertyListRow: View {
    let wrapper: String
    let name: String
    let type: String
    let isSelected: Bool
    let onSelect: () -> Void

    init(
        wrapper: String,
        name: String,
        type: String,
        isSelected: Bool = false,
        onSelect: @escaping () -> Void = {}
    ) {
        self.wrapper = wrapper
        self.name = name
        self.type = type
        self.isSelected = isSelected
        self.onSelect = onSelect
    }

    var body: some View {
        HStack(spacing: 4) {
            Text(wrapper)
                .font(.system(size: 11, design: .monospaced))
                .foregroundStyle(.orange)

            Text(name)
                .font(.system(size: 12, design: .monospaced))
                .foregroundStyle(.primary)

            Text(":")
                .font(.system(size: 12, design: .monospaced))
                .foregroundStyle(.secondary)

            Text(type)
                .font(.system(size: 12, design: .monospaced))
                .foregroundStyle(.cyan)

            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .background(isSelected ? Color.accentColor.opacity(0.15) : Color.clear)
        .contentShape(Rectangle())
        .onTapGesture(perform: onSelect)
    }
}

/// A function list row
struct FunctionListRow: View {
    let name: String
    let signature: String
    let isAsync: Bool
    let throws_: Bool
    let isSelected: Bool
    let onSelect: () -> Void

    init(
        name: String,
        signature: String = "()",
        isAsync: Bool = false,
        throws_: Bool = false,
        isSelected: Bool = false,
        onSelect: @escaping () -> Void = {}
    ) {
        self.name = name
        self.signature = signature
        self.isAsync = isAsync
        self.throws_ = throws_
        self.isSelected = isSelected
        self.onSelect = onSelect
    }

    var body: some View {
        HStack(spacing: 4) {
            Text("func")
                .font(.system(size: 11, design: .monospaced))
                .foregroundStyle(.purple)

            Text(name)
                .font(.system(size: 12, design: .monospaced))
                .foregroundStyle(.primary)

            Text(signature)
                .font(.system(size: 12, design: .monospaced))
                .foregroundStyle(.secondary)

            if isAsync {
                Text("async")
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundStyle(.orange)
            }

            if throws_ {
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
        .onTapGesture(perform: onSelect)
    }
}

#Preview {
    VStack(spacing: 0) {
        // File rows
        FileListRow(name: "ContentView", systemImage: "doc", isSelected: true, onSelect: {})
        FileListRow(name: "DetailView", systemImage: "doc", isSelected: false, onSelect: {})
        FileListRow(name: "SettingsView", systemImage: "doc", isSelected: false, onSelect: {})

        Divider()
            .padding(.vertical, 8)

        // Property rows
        PropertyListRow(wrapper: "@State", name: "count", type: "Int", isSelected: false, onSelect: {})
        PropertyListRow(wrapper: "@Binding", name: "isPresented", type: "Bool", isSelected: true, onSelect: {})
        PropertyListRow(wrapper: "@Query", name: "items", type: "[Item]", isSelected: false, onSelect: {})

        Divider()
            .padding(.vertical, 8)

        // Function rows
        FunctionListRow(name: "increment", signature: "()", isSelected: false, onSelect: {})
        FunctionListRow(name: "fetchData", signature: "()", isAsync: true, throws_: true, isSelected: true, onSelect: {})
        FunctionListRow(name: "reset", signature: "()", isSelected: false, onSelect: {})
    }
    .frame(width: 280)
    .padding(.vertical, 8)
}
