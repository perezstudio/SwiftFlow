//
//  EditorStore.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import Foundation
import CoreGraphics

/// Manages editor state including zoom, pan, and mode
@Observable
final class EditorStore {
    // MARK: - Canvas State

    /// Current zoom level (1.0 = 100%)
    var zoomLevel: CGFloat = 0.75

    /// Canvas offset for panning
    var canvasOffset: CGPoint = .zero

    /// Selected device for preview
    var selectedDevice: DeviceType = .iPhone15Pro

    /// Minimum zoom level
    let minZoom: CGFloat = 0.25

    /// Maximum zoom level
    let maxZoom: CGFloat = 4.0

    /// Zoom step for zoom in/out actions
    let zoomStep: CGFloat = 0.25

    // MARK: - Editor Mode

    /// Current editor mode
    var mode: EditorMode = .select

    /// Available editor modes
    enum EditorMode: String, CaseIterable, Sendable {
        case select     // Default selection mode
        case pan        // Pan/scroll mode (space + drag)
        case connect    // Connection drawing mode
        case insert     // Insert new block mode
    }

    // MARK: - Grid Settings

    /// Whether to show the grid
    var showGrid: Bool = true

    /// Grid size in points
    var gridSize: CGFloat = 20

    /// Whether to snap to grid
    var snapToGrid: Bool = true

    // MARK: - View Options

    /// Whether to show connection lines
    var showConnections: Bool = true

    /// Whether to show block labels
    var showBlockLabels: Bool = true

    /// Whether to show minimap
    var showMinimap: Bool = false

    // MARK: - Palette State

    /// Whether the block palette is visible
    var showBlockPalette: Bool = true

    /// Search filter for block palette
    var paletteSearchText: String = ""

    /// Selected category in block palette
    var selectedPaletteCategory: String?

    // MARK: - Zoom Methods

    func zoomIn() {
        zoomLevel = min(zoomLevel + zoomStep, maxZoom)
    }

    func zoomOut() {
        zoomLevel = max(zoomLevel - zoomStep, minZoom)
    }

    func resetZoom() {
        zoomLevel = 1.0
    }

    func fitToContent() {
        // Implementation would calculate bounds and set appropriate zoom/offset
        zoomLevel = 1.0
        canvasOffset = .zero
    }

    func setZoom(_ level: CGFloat) {
        zoomLevel = min(max(level, minZoom), maxZoom)
    }

    // MARK: - Pan Methods

    func pan(by delta: CGPoint) {
        canvasOffset.x += delta.x
        canvasOffset.y += delta.y
    }

    func resetPan() {
        canvasOffset = .zero
    }

    func centerOn(point: CGPoint) {
        canvasOffset = CGPoint(x: -point.x, y: -point.y)
    }

    // MARK: - Grid Methods

    func snapPoint(_ point: CGPoint) -> CGPoint {
        guard snapToGrid else { return point }
        return CGPoint(
            x: round(point.x / gridSize) * gridSize,
            y: round(point.y / gridSize) * gridSize
        )
    }

    // MARK: - Mode Methods

    func setMode(_ newMode: EditorMode) {
        mode = newMode
    }

    func togglePanMode() {
        mode = mode == .pan ? .select : .pan
    }

    // MARK: - Reset

    func reset() {
        zoomLevel = 1.0
        canvasOffset = .zero
        mode = .select
        paletteSearchText = ""
        selectedPaletteCategory = nil
    }
}
