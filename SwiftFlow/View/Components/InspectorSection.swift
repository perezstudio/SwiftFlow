//
//  InspectorSection.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import SwiftUI

/// A styled section for inspector panels with optional header action
struct InspectorSection<Content: View>: View {
    let title: String
    let systemImage: String?
    let headerAction: (() -> Void)?
    let headerActionIcon: String
    let content: Content

    init(
        _ title: String,
        systemImage: String? = nil,
        headerAction: (() -> Void)? = nil,
        headerActionIcon: String = "plus",
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.systemImage = systemImage
        self.headerAction = headerAction
        self.headerActionIcon = headerActionIcon
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Section header
            HStack {
                if let systemImage {
                    Image(systemName: systemImage)
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }

                Text(title)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)

                Spacer()

                if let action = headerAction {
                    Button(action: action) {
                        Image(systemName: headerActionIcon)
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                    .contentShape(Rectangle())
                }
            }
            .padding(.horizontal, 12)
            .padding(.top, 12)

            // Section content
            content
                .padding(.horizontal, 12)
                .padding(.bottom, 12)
        }
        .background(Color(nsColor: .controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

/// A row within an inspector section
struct InspectorRow<Content: View>: View {
    let label: String
    let content: Content

    init(_ label: String, @ViewBuilder content: () -> Content) {
        self.label = label
        self.content = content()
    }

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Text(label)
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
                .frame(width: 80, alignment: .trailing)

            content
        }
    }
}

/// A divider for inspector sections
struct InspectorDivider: View {
    var body: some View {
        Divider()
            .padding(.vertical, 4)
    }
}

#Preview {
    VStack(spacing: 12) {
        InspectorSection("Block", systemImage: "square.stack.3d.up", headerAction: {}) {
            VStack(alignment: .leading, spacing: 8) {
                InspectorRow("Type") {
                    Text("VStack")
                        .font(.system(size: 12, design: .monospaced))
                }

                InspectorRow("Alignment") {
                    Picker("", selection: .constant("center")) {
                        Text("Leading").tag("leading")
                        Text("Center").tag("center")
                        Text("Trailing").tag("trailing")
                    }
                    .labelsHidden()
                    .pickerStyle(.menu)
                }

                InspectorRow("Spacing") {
                    TextField("", value: .constant(8), format: .number)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 60)
                }
            }
        }

        InspectorSection("Modifiers", headerAction: {}, headerActionIcon: "plus") {
            VStack(alignment: .leading, spacing: 4) {
                Text(".padding()")
                Text(".background(Color.blue)")
            }
            .font(.system(size: 12, design: .monospaced))
        }
    }
    .padding()
    .frame(width: 280)
    .background(Color(nsColor: .windowBackgroundColor))
}
