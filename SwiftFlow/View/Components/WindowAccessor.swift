//
//  WindowAccessor.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import SwiftUI
import AppKit

// MARK: - Title Bar Metrics

/// Metrics for positioning content in the title bar area
struct TitleBarMetrics {
    /// Height of the title bar area (where traffic lights live)
    let height: CGFloat

    /// Left inset to clear the traffic light buttons (close/minimize/zoom)
    let trafficLightInset: CGFloat

    /// Standard macOS title bar metrics
    static let standard = TitleBarMetrics(
        height: 52,
        trafficLightInset: 78
    )
}

/// Environment key for title bar metrics
private struct TitleBarMetricsKey: EnvironmentKey {
    static let defaultValue = TitleBarMetrics.standard
}

extension EnvironmentValues {
    var titleBarMetrics: TitleBarMetrics {
        get { self[TitleBarMetricsKey.self] }
        set { self[TitleBarMetricsKey.self] = newValue }
    }
}

// MARK: - Window Accessor

/// Custom NSView that configures its window when added to the view hierarchy
private class WindowAccessorView: NSView {
    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        guard let window = window else { return }

        // Make content extend under title bar
        window.styleMask.insert(.fullSizeContentView)
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden

        // Allow dragging the window by its background
        window.isMovableByWindowBackground = true
    }
}

/// A view that accesses and configures the NSWindow for edge-to-edge content
struct WindowAccessor: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        WindowAccessorView()
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}

extension View {
    /// Makes the window content extend edge-to-edge, under the title bar
    func edgeToEdgeWindow() -> some View {
        self.background(WindowAccessor())
    }
}

// MARK: - Visual Effect Background

/// NSVisualEffectView wrapper for SwiftUI to provide macOS material backgrounds
struct VisualEffectBackground: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode
    let isEmphasized: Bool

    init(
        material: NSVisualEffectView.Material = .sidebar,
        blendingMode: NSVisualEffectView.BlendingMode = .behindWindow,
        isEmphasized: Bool = false
    ) {
        self.material = material
        self.blendingMode = blendingMode
        self.isEmphasized = isEmphasized
    }

    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.isEmphasized = isEmphasized
        view.state = .followsWindowActiveState
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
        nsView.isEmphasized = isEmphasized
    }
}

extension View {
    /// Applies a macOS visual effect material background (like Finder's sidebar)
    func materialBackground(
        _ material: NSVisualEffectView.Material = .sidebar,
        blendingMode: NSVisualEffectView.BlendingMode = .behindWindow,
        isEmphasized: Bool = false
    ) -> some View {
        self.background(
            VisualEffectBackground(
                material: material,
                blendingMode: blendingMode,
                isEmphasized: isEmphasized
            )
        )
    }
}
