//
//  FunctionRowView.swift
//  SwiftFlow
//
//  Created on 1/27/26.
//

import SwiftUI

/// A single row displaying a view function in the function list
struct FunctionRowView: View {
    let function: ViewFunction
    let isSelected: Bool
    let onSelect: () -> Void
    let onDelete: () -> Void

    @State private var isHovering = false

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 8) {
                // Function icon
                Image(systemName: "function")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.orange)
                    .frame(width: 20)

                // Function info
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 4) {
                        Text(function.name)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.primary)

                        if function.isAsync {
                            asyncBadge
                        }

                        if function.throwsError {
                            throwsBadge
                        }
                    }

                    Text(function.signature)
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                Spacer()

                // Delete button (shown on hover)
                if isHovering {
                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .font(.system(size: 10))
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.borderless)
                    .help("Delete Function")
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            isHovering = hovering
        }
    }

    private var asyncBadge: some View {
        Text("async")
            .font(.system(size: 9, weight: .medium, design: .monospaced))
            .foregroundStyle(.purple)
            .padding(.horizontal, 4)
            .padding(.vertical, 2)
            .background(Color.purple.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 3))
    }

    private var throwsBadge: some View {
        Text("throws")
            .font(.system(size: 9, weight: .medium, design: .monospaced))
            .foregroundStyle(.red)
            .padding(.horizontal, 4)
            .padding(.vertical, 2)
            .background(Color.red.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 3))
    }

    private var backgroundColor: Color {
        if isSelected {
            return Color.accentColor.opacity(0.2)
        } else if isHovering {
            return Color(nsColor: .controlBackgroundColor)
        } else {
            return Color.clear
        }
    }
}

#Preview {
    VStack(spacing: 4) {
        FunctionRowView(
            function: ViewFunction(name: "handleTap"),
            isSelected: false,
            onSelect: {},
            onDelete: {}
        )

        FunctionRowView(
            function: ViewFunction(name: "fetchData", isAsync: true, throwsError: true),
            isSelected: true,
            onSelect: {},
            onDelete: {}
        )
    }
    .padding()
    .frame(width: 280)
}
