//
//  DragCoordinator.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import Foundation
import CoreGraphics

/// Coordinates drag and drop operations across the app
@Observable
final class DragCoordinator {
    // MARK: - Drag State

    /// Whether a drag operation is in progress
    private(set) var isDragging: Bool = false

    /// Current drag content
    private(set) var dragContent: DragContent?

    /// Current drag position
    private(set) var dragPosition: CGPoint = .zero

    /// Starting position of the drag
    private(set) var dragStartPosition: CGPoint = .zero

    /// Current drop target
    private(set) var dropTarget: DropTarget?

    /// Whether the current drop target is valid
    private(set) var isDropTargetValid: Bool = false

    // MARK: - Drag Content Types

    enum DragContent: Sendable {
        case viewBlockFromPalette(ViewBlockType)
        case viewBlockFromCanvas(UUID)
        case logicBlockFromPalette(LogicBlockType)
        case logicBlockFromCanvas(UUID)
        case viewProperty(UUID)
        case queryProperty(UUID)
        case viewFunction(UUID)
        case queryFunction(UUID)
        case fileReorder(UUID)
    }

    // MARK: - Drop Target Types

    enum DropTarget: Equatable, Sendable {
        case viewBlockParent(UUID)          // Drop as child of a block
        case viewBlockSibling(UUID, Bool)   // Drop as sibling (before/after)
        case viewCanvas                      // Drop on canvas root
        case logicBlockParent(UUID)         // Drop as child of logic block
        case logicBlockSibling(UUID, Bool)  // Drop as sibling
        case logicCanvas                     // Drop on workflow canvas
        case propertyList                    // Drop in property list
        case functionList                    // Drop in function list
        case fileList(Int)                   // Drop in file list at index
    }

    // MARK: - Drag Lifecycle

    func beginDrag(content: DragContent, at position: CGPoint) {
        isDragging = true
        dragContent = content
        dragPosition = position
        dragStartPosition = position
        dropTarget = nil
        isDropTargetValid = false
    }

    func updateDrag(to position: CGPoint) {
        guard isDragging else { return }
        dragPosition = position
    }

    func setDropTarget(_ target: DropTarget?, isValid: Bool) {
        dropTarget = target
        isDropTargetValid = isValid
    }

    func endDrag() -> (content: DragContent, target: DropTarget)? {
        guard isDragging,
              let content = dragContent,
              let target = dropTarget,
              isDropTargetValid else {
            cancelDrag()
            return nil
        }

        let result = (content: content, target: target)
        resetDragState()
        return result
    }

    func cancelDrag() {
        resetDragState()
    }

    private func resetDragState() {
        isDragging = false
        dragContent = nil
        dragPosition = .zero
        dragStartPosition = .zero
        dropTarget = nil
        isDropTargetValid = false
    }

    // MARK: - Computed Properties

    var dragOffset: CGPoint {
        CGPoint(
            x: dragPosition.x - dragStartPosition.x,
            y: dragPosition.y - dragStartPosition.y
        )
    }

    var isDraggingViewBlock: Bool {
        guard let content = dragContent else { return false }
        switch content {
        case .viewBlockFromPalette, .viewBlockFromCanvas:
            return true
        default:
            return false
        }
    }

    var isDraggingLogicBlock: Bool {
        guard let content = dragContent else { return false }
        switch content {
        case .logicBlockFromPalette, .logicBlockFromCanvas:
            return true
        default:
            return false
        }
    }

    var isDraggingFromPalette: Bool {
        guard let content = dragContent else { return false }
        switch content {
        case .viewBlockFromPalette, .logicBlockFromPalette:
            return true
        default:
            return false
        }
    }

    // MARK: - Drop Validation

    func canDrop(content: DragContent, on target: DropTarget) -> Bool {
        switch (content, target) {
        case (.viewBlockFromPalette, .viewBlockParent),
             (.viewBlockFromPalette, .viewBlockSibling),
             (.viewBlockFromPalette, .viewCanvas),
             (.viewBlockFromCanvas, .viewBlockParent),
             (.viewBlockFromCanvas, .viewBlockSibling),
             (.viewBlockFromCanvas, .viewCanvas):
            return true

        case (.logicBlockFromPalette, .logicBlockParent),
             (.logicBlockFromPalette, .logicBlockSibling),
             (.logicBlockFromPalette, .logicCanvas),
             (.logicBlockFromCanvas, .logicBlockParent),
             (.logicBlockFromCanvas, .logicBlockSibling),
             (.logicBlockFromCanvas, .logicCanvas):
            return true

        case (.viewProperty, .propertyList),
             (.queryProperty, .propertyList):
            return true

        case (.viewFunction, .functionList),
             (.queryFunction, .functionList):
            return true

        case (.fileReorder, .fileList):
            return true

        default:
            return false
        }
    }

    // MARK: - Helper Methods

    func viewBlockType(from content: DragContent) -> ViewBlockType? {
        switch content {
        case .viewBlockFromPalette(let type):
            return type
        default:
            return nil
        }
    }

    func viewBlockId(from content: DragContent) -> UUID? {
        switch content {
        case .viewBlockFromCanvas(let id):
            return id
        default:
            return nil
        }
    }

    func logicBlockType(from content: DragContent) -> LogicBlockType? {
        switch content {
        case .logicBlockFromPalette(let type):
            return type
        default:
            return nil
        }
    }

    func logicBlockId(from content: DragContent) -> UUID? {
        switch content {
        case .logicBlockFromCanvas(let id):
            return id
        default:
            return nil
        }
    }
}
