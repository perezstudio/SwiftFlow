//
//  GridBackgroundView.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import SwiftUI

/// Background grid for the canvas editor
struct GridBackgroundView: View {
    @Environment(AppStore.self) private var appStore

    var body: some View {
        GeometryReader { geometry in
            if appStore.editor.showGrid {
                Canvas { context, size in
                    let gridSpacing = appStore.editor.gridSize * appStore.editor.zoomLevel
                    let offset = appStore.editor.canvasOffset

                    // Calculate grid line positions
                    let startX = offset.x.truncatingRemainder(dividingBy: gridSpacing)
                    let startY = offset.y.truncatingRemainder(dividingBy: gridSpacing)

                    // Minor grid lines
                    var minorPath = Path()

                    // Vertical lines
                    var x = startX
                    while x < size.width {
                        minorPath.move(to: CGPoint(x: x, y: 0))
                        minorPath.addLine(to: CGPoint(x: x, y: size.height))
                        x += gridSpacing
                    }

                    // Horizontal lines
                    var y = startY
                    while y < size.height {
                        minorPath.move(to: CGPoint(x: 0, y: y))
                        minorPath.addLine(to: CGPoint(x: size.width, y: y))
                        y += gridSpacing
                    }

                    context.stroke(minorPath, with: .color(.gray.opacity(0.15)), lineWidth: 0.5)

                    // Major grid lines (every 5 cells)
                    let majorSpacing = gridSpacing * 5
                    let majorStartX = offset.x.truncatingRemainder(dividingBy: majorSpacing)
                    let majorStartY = offset.y.truncatingRemainder(dividingBy: majorSpacing)

                    var majorPath = Path()

                    // Vertical major lines
                    x = majorStartX
                    while x < size.width {
                        majorPath.move(to: CGPoint(x: x, y: 0))
                        majorPath.addLine(to: CGPoint(x: x, y: size.height))
                        x += majorSpacing
                    }

                    // Horizontal major lines
                    y = majorStartY
                    while y < size.height {
                        majorPath.move(to: CGPoint(x: 0, y: y))
                        majorPath.addLine(to: CGPoint(x: size.width, y: y))
                        y += majorSpacing
                    }

                    context.stroke(majorPath, with: .color(.gray.opacity(0.25)), lineWidth: 0.5)
                }
            }
        }
        .background(Color(nsColor: .textBackgroundColor))
    }
}

// MARK: - Dot Grid Alternative

/// Alternative dot-based grid background
struct DotGridBackgroundView: View {
    @Environment(AppStore.self) private var appStore

    var body: some View {
        GeometryReader { geometry in
            if appStore.editor.showGrid {
                Canvas { context, size in
                    let gridSpacing = appStore.editor.gridSize * appStore.editor.zoomLevel
                    let offset = appStore.editor.canvasOffset

                    let startX = offset.x.truncatingRemainder(dividingBy: gridSpacing)
                    let startY = offset.y.truncatingRemainder(dividingBy: gridSpacing)

                    let dotRadius: CGFloat = 1.0

                    var x = startX
                    while x < size.width {
                        var y = startY
                        while y < size.height {
                            let rect = CGRect(
                                x: x - dotRadius,
                                y: y - dotRadius,
                                width: dotRadius * 2,
                                height: dotRadius * 2
                            )
                            context.fill(
                                Path(ellipseIn: rect),
                                with: .color(.gray.opacity(0.3))
                            )
                            y += gridSpacing
                        }
                        x += gridSpacing
                    }
                }
            }
        }
        .background(Color(nsColor: .textBackgroundColor))
    }
}

#Preview("Line Grid") {
    GridBackgroundView()
        .environment(AppStore())
        .frame(width: 400, height: 300)
}

#Preview("Dot Grid") {
    DotGridBackgroundView()
        .environment(AppStore())
        .frame(width: 400, height: 300)
}
