//
//  SectionHeader.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import SwiftUI

/// A standardized section header with optional actions
struct SectionHeader: View {
    let title: String
    let systemImage: String?
    let actions: [SectionAction]

    struct SectionAction: Identifiable {
        let id = UUID()
        let icon: String
        let action: () -> Void
        let isDisabled: Bool

        init(icon: String, isDisabled: Bool = false, action: @escaping () -> Void) {
            self.icon = icon
            self.action = action
            self.isDisabled = isDisabled
        }
    }

    init(
        _ title: String,
        systemImage: String? = nil,
        actions: [SectionAction] = []
    ) {
        self.title = title
        self.systemImage = systemImage
        self.actions = actions
    }

    var body: some View {
        HStack(spacing: 6) {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(.system(size: 11))
                    .foregroundStyle(.tertiary)
            }

            Text(title)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.secondary)

            Spacer()

            ForEach(actions) { action in
                Button(action: action.action) {
                    Image(systemName: action.icon)
                        .font(.system(size: 11))
                        .foregroundStyle(action.isDisabled ? .tertiary : .secondary)
                }
                .buttonStyle(.plain)
                .disabled(action.isDisabled)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color(nsColor: .separatorColor).opacity(0.3))
    }
}

/// A larger section header for major divisions
struct MajorSectionHeader: View {
    let title: String
    let systemImage: String?

    init(_ title: String, systemImage: String? = nil) {
        self.title = title
        self.systemImage = systemImage
    }

    var body: some View {
        HStack(spacing: 8) {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.primary)
            }

            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.primary)

            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }
}

#Preview {
    VStack(spacing: 0) {
        MajorSectionHeader("Views", systemImage: "square.on.square")

        SectionHeader(
            "Properties",
            systemImage: "list.bullet",
            actions: [
                .init(icon: "plus") { print("Add") },
                .init(icon: "trash", isDisabled: true) { print("Delete") }
            ]
        )

        VStack(alignment: .leading, spacing: 4) {
            Text("@State count: Int")
            Text("@Binding isActive: Bool")
        }
        .font(.system(.caption, design: .monospaced))
        .padding()

        SectionHeader("Functions", systemImage: "function", actions: [
            .init(icon: "plus") { print("Add function") }
        ])

        VStack(alignment: .leading, spacing: 4) {
            Text("func increment()")
            Text("func decrement()")
        }
        .font(.system(.caption, design: .monospaced))
        .padding()
    }
    .frame(width: 250)
    .background(Color(nsColor: .windowBackgroundColor))
}
