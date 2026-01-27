//
//  DevicePreviewView.swift
//  SwiftFlow
//
//  Created on 1/27/26.
//

import SwiftUI
import SwiftData

/// Main device preview container for the view editor
struct DevicePreviewView: View {
    let viewFile: ViewFile
    @Binding var selectedDevice: DeviceType
    @Binding var zoomLevel: CGFloat

    @Environment(AppStore.self) private var appStore
    @Environment(\.modelContext) private var modelContext

    @State private var dragOffset: CGSize = .zero

    var body: some View {
        GeometryReader { geometry in
            ScrollView([.horizontal, .vertical], showsIndicators: true) {
                ZStack {
                    // Canvas background
                    Color.clear
                        .frame(
                            width: max(geometry.size.width * 2, canvasWidth),
                            height: max(geometry.size.height * 2, canvasHeight)
                        )

                    // Device frame with preview
                    DeviceFrameView(device: selectedDevice) {
                        previewContent
                    }
                    .scaleEffect(zoomLevel)
                    .offset(dragOffset)
                }
                .frame(
                    width: max(geometry.size.width * 2, canvasWidth),
                    height: max(geometry.size.height * 2, canvasHeight)
                )
            }
            .gesture(panGesture)
            .gesture(magnificationGesture)
        }
        .background(canvasBackground)
    }

    // MARK: - Canvas Sizing

    private var canvasWidth: CGFloat {
        selectedDevice.screenSize.width * zoomLevel + 200
    }

    private var canvasHeight: CGFloat {
        selectedDevice.screenSize.height * zoomLevel + 200
    }

    // MARK: - Preview Content

    @ViewBuilder
    private var previewContent: some View {
        if let rootBlock = viewFile.rootBlock {
            ZStack {
                // Rendered block preview
                BlockPreviewRenderer(
                    block: rootBlock,
                    selectedBlockId: appStore.selectedBlockId,
                    onBlockTapped: { block in
                        appStore.selection.selectBlock(id: block.id)
                    }
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                // Drop zone overlay
                PreviewDropZone(viewFile: viewFile)
            }
            .deviceSafeAreaPadding(selectedDevice.safeAreaInsets)
        } else {
            // Empty state with drop zone
            EmptyPreviewDropZone(viewFile: viewFile)
        }
    }

    // MARK: - Canvas Background

    private var canvasBackground: some View {
        ZStack {
            Color(nsColor: .windowBackgroundColor)

            // Grid pattern
            GeometryReader { geometry in
                Path { path in
                    let gridSpacing: CGFloat = 20 * zoomLevel
                    let cols = Int(geometry.size.width / gridSpacing) + 1
                    let rows = Int(geometry.size.height / gridSpacing) + 1

                    for col in 0...cols {
                        let x = CGFloat(col) * gridSpacing
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                    }

                    for row in 0...rows {
                        let y = CGFloat(row) * gridSpacing
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                    }
                }
                .stroke(Color.secondary.opacity(0.1), lineWidth: 0.5)
            }
        }
    }

    // MARK: - Gestures

    private var panGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                dragOffset = value.translation
            }
            .onEnded { value in
                appStore.editor.canvasOffset.x += value.translation.width
                appStore.editor.canvasOffset.y += value.translation.height
                dragOffset = .zero
            }
    }

    private var magnificationGesture: some Gesture {
        MagnifyGesture()
            .onChanged { value in
                let newZoom = zoomLevel * value.magnification
                zoomLevel = min(max(newZoom, 0.25), 2.0)
            }
    }
}

// MARK: - Extension for Device Safe Area Padding

extension View {
    func deviceSafeAreaPadding(_ insets: EdgeInsets) -> some View {
        self.padding(.top, insets.top)
            .padding(.leading, insets.leading)
            .padding(.bottom, insets.bottom)
            .padding(.trailing, insets.trailing)
    }
}

#Preview {
    DevicePreviewView(
        viewFile: ViewFile(name: "Preview"),
        selectedDevice: .constant(.iPhone15Pro),
        zoomLevel: .constant(0.5)
    )
    .environment(AppStore())
    .frame(width: 800, height: 600)
}
