//
//  CustomToolbar.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import SwiftUI

/// Custom toolbar styled like macOS 15 Sequoia (without liquid glass)
struct CustomToolbar<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        HStack(spacing: 8) {
            content
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .frame(height: 38)
        .background(Color(nsColor: .windowBackgroundColor))
    }
}

/// Toolbar button styled for macOS 15 Sequoia
struct ToolbarButton: View {
    let icon: String
    let action: () -> Void
    var isActive: Bool = false
    var helpText: String? = nil

    @State private var isHovering = false

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(isActive ? Color.accentColor : Color.primary)
                .frame(width: 28, height: 24)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .fill(backgroundColor)
                )
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            isHovering = hovering
        }
        .help(helpText ?? "")
    }

    private var backgroundColor: Color {
        if isActive {
            return Color.accentColor.opacity(0.15)
        } else if isHovering {
            return Color(nsColor: .controlBackgroundColor)
        } else {
            return Color.clear
        }
    }
}

/// Toolbar button with text label
struct ToolbarTextButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    var helpText: String? = nil

    @State private var isHovering = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 11, weight: .medium))
                }
                Text(title)
                    .font(.system(size: 12, weight: .medium))
            }
            .foregroundStyle(.primary)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .fill(isHovering ? Color(nsColor: .controlBackgroundColor) : Color.clear)
            )
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            isHovering = hovering
        }
        .help(helpText ?? "")
    }
}

/// Toolbar label for displaying values (like zoom percentage)
struct ToolbarLabel: View {
    let text: String
    var minWidth: CGFloat = 40

    var body: some View {
        Text(text)
            .font(.system(size: 11, weight: .medium, design: .monospaced))
            .foregroundStyle(.secondary)
            .frame(minWidth: minWidth)
    }
}

/// Toolbar divider
struct ToolbarDivider: View {
    var body: some View {
        Divider()
            .frame(height: 18)
            .padding(.horizontal, 4)
    }
}

/// Toolbar spacer that pushes content to edges
struct ToolbarSpacer: View {
    var body: some View {
        Spacer()
    }
}

/// Toolbar segment for grouping related items
struct ToolbarSegment<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        HStack(spacing: 2) {
            content
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 3)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(nsColor: .controlBackgroundColor).opacity(0.5))
        )
    }
}

#Preview("Toolbar") {
    VStack(spacing: 0) {
        CustomToolbar {
            ToolbarButton(icon: "sidebar.left", action: {}, isActive: true)

            ToolbarDivider()

            ToolbarSegment {
                ToolbarButton(icon: "minus.magnifyingglass", action: {})
                ToolbarLabel(text: "100%")
                ToolbarButton(icon: "plus.magnifyingglass", action: {})
            }

            ToolbarButton(icon: "1.magnifyingglass", action: {})

            ToolbarDivider()

            ToolbarButton(icon: "grid", action: {}, isActive: false)

            ToolbarSpacer()

            ToolbarTextButton(title: "Run", icon: "play.fill", action: {})
        }

        Divider()

        Color(nsColor: .windowBackgroundColor)
            .frame(height: 300)
    }
    .frame(width: 600, height: 350)
}
