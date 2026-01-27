//
//  DropIndicatorView.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import SwiftUI

/// A visual indicator showing where an item will be dropped
struct DropIndicatorView: View {
    var style: DropIndicatorStyle = .line
    var color: Color = .accentColor

    enum DropIndicatorStyle {
        case line       // Horizontal line between items
        case outline    // Outline around target container
        case highlight  // Highlight background
    }

    var body: some View {
        switch style {
        case .line:
            lineIndicator
        case .outline:
            outlineIndicator
        case .highlight:
            highlightIndicator
        }
    }

    private var lineIndicator: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 6, height: 6)

            Rectangle()
                .fill(color)
                .frame(height: 2)

            Circle()
                .fill(color)
                .frame(width: 6, height: 6)
        }
        .padding(.horizontal, 4)
    }

    private var outlineIndicator: some View {
        RoundedRectangle(cornerRadius: 8)
            .strokeBorder(color, style: StrokeStyle(lineWidth: 2, dash: [6, 3]))
            .background(color.opacity(0.05))
    }

    private var highlightIndicator: some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(color.opacity(0.15))
    }
}

/// Drop indicator for tree node insertion
struct TreeDropIndicator: View {
    let depth: Int
    let position: DropPosition
    var color: Color = .accentColor

    enum DropPosition {
        case above
        case below
        case inside
    }

    private let indentWidth: CGFloat = 16

    var body: some View {
        switch position {
        case .above, .below:
            HStack(spacing: 0) {
                Color.clear
                    .frame(width: CGFloat(depth) * indentWidth + 24)

                HStack(spacing: 4) {
                    Circle()
                        .fill(color)
                        .frame(width: 6, height: 6)

                    Rectangle()
                        .fill(color)
                        .frame(height: 2)
                }
            }
            .frame(height: 4)

        case .inside:
            RoundedRectangle(cornerRadius: 4)
                .strokeBorder(color, style: StrokeStyle(lineWidth: 2, dash: [4, 2]))
                .background(color.opacity(0.1).clipShape(RoundedRectangle(cornerRadius: 4)))
        }
    }
}

/// A drop zone area for canvas drops
struct DropZoneView: View {
    let isActive: Bool
    let label: String?
    var color: Color = .accentColor

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(
                    isActive ? color : Color.secondary.opacity(0.3),
                    style: StrokeStyle(lineWidth: 2, dash: isActive ? [] : [8, 4])
                )
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isActive ? color.opacity(0.1) : Color.clear)
                )

            if let label {
                VStack(spacing: 8) {
                    Image(systemName: isActive ? "arrow.down.circle.fill" : "plus.circle")
                        .font(.system(size: 24))
                        .foregroundStyle(isActive ? color : .secondary)

                    Text(label)
                        .font(.subheadline)
                        .foregroundStyle(isActive ? color : .secondary)
                }
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isActive)
    }
}

/// Visual feedback during drag operations
struct DragPreviewView<Content: View>: View {
    let content: Content
    var opacity: Double = 0.8

    init(opacity: Double = 0.8, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.opacity = opacity
    }

    var body: some View {
        content
            .opacity(opacity)
            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    VStack(spacing: 24) {
        // Line indicators
        VStack(spacing: 8) {
            Text("Line Indicator")
                .font(.caption)
            DropIndicatorView(style: .line)
        }

        // Outline indicator
        VStack(spacing: 8) {
            Text("Outline Indicator")
                .font(.caption)
            DropIndicatorView(style: .outline)
                .frame(width: 200, height: 60)
        }

        // Highlight indicator
        VStack(spacing: 8) {
            Text("Highlight Indicator")
                .font(.caption)
            DropIndicatorView(style: .highlight)
                .frame(width: 200, height: 40)
        }

        // Tree drop indicators
        VStack(spacing: 4) {
            Text("Tree Drop Indicators")
                .font(.caption)

            TreeDropIndicator(depth: 1, position: .above)
            HStack {
                Text("Item")
                Spacer()
            }
            .padding(8)
            .background(Color(nsColor: .controlBackgroundColor))

            TreeDropIndicator(depth: 2, position: .inside)
                .frame(height: 30)
        }
        .frame(width: 250)

        // Drop zones
        HStack(spacing: 16) {
            DropZoneView(isActive: false, label: "Drop here")
                .frame(width: 120, height: 80)

            DropZoneView(isActive: true, label: "Release to drop")
                .frame(width: 120, height: 80)
        }
    }
    .padding()
}
