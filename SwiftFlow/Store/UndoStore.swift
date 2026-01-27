//
//  UndoStore.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import Foundation

/// Manages undo/redo operations
@Observable
final class UndoStore {
    // MARK: - Stacks

    private var undoStack: [UndoAction] = []
    private var redoStack: [UndoAction] = []

    /// Maximum number of undo actions to keep
    var maxUndoLevels: Int = 50

    // MARK: - Action Types

    struct UndoAction: Sendable {
        let id: UUID
        let name: String
        let timestamp: Date
        let undoHandler: @Sendable () -> Void
        let redoHandler: @Sendable () -> Void

        init(
            name: String,
            undo: @escaping @Sendable () -> Void,
            redo: @escaping @Sendable () -> Void
        ) {
            self.id = UUID()
            self.name = name
            self.timestamp = Date()
            self.undoHandler = undo
            self.redoHandler = redo
        }
    }

    // MARK: - Computed Properties

    var canUndo: Bool {
        !undoStack.isEmpty
    }

    var canRedo: Bool {
        !redoStack.isEmpty
    }

    var undoActionName: String? {
        undoStack.last?.name
    }

    var redoActionName: String? {
        redoStack.last?.name
    }

    var undoMenuTitle: String {
        if let name = undoActionName {
            return "Undo \(name)"
        }
        return "Undo"
    }

    var redoMenuTitle: String {
        if let name = redoActionName {
            return "Redo \(name)"
        }
        return "Redo"
    }

    // MARK: - Registration

    /// Register an undoable action
    func registerUndo(
        name: String,
        undo: @escaping @Sendable () -> Void,
        redo: @escaping @Sendable () -> Void
    ) {
        let action = UndoAction(name: name, undo: undo, redo: redo)
        undoStack.append(action)

        // Clear redo stack when new action is registered
        redoStack.removeAll()

        // Trim undo stack if needed
        while undoStack.count > maxUndoLevels {
            undoStack.removeFirst()
        }
    }

    // MARK: - Undo/Redo

    func undo() {
        guard let action = undoStack.popLast() else { return }
        action.undoHandler()
        redoStack.append(action)
    }

    func redo() {
        guard let action = redoStack.popLast() else { return }
        action.redoHandler()
        undoStack.append(action)
    }

    // MARK: - Clear

    func clear() {
        undoStack.removeAll()
        redoStack.removeAll()
    }

    func clearRedoStack() {
        redoStack.removeAll()
    }

    // MARK: - Grouping

    private var groupingLevel: Int = 0
    private var groupedActions: [UndoAction] = []
    private var groupName: String?

    /// Begin a group of actions that should be undone together
    func beginGrouping(name: String) {
        if groupingLevel == 0 {
            groupName = name
            groupedActions.removeAll()
        }
        groupingLevel += 1
    }

    /// End the current action group
    func endGrouping() {
        guard groupingLevel > 0 else { return }
        groupingLevel -= 1

        if groupingLevel == 0 && !groupedActions.isEmpty {
            let actions = groupedActions
            let name = groupName ?? "Multiple Changes"

            registerUndo(
                name: name,
                undo: {
                    for action in actions.reversed() {
                        action.undoHandler()
                    }
                },
                redo: {
                    for action in actions {
                        action.redoHandler()
                    }
                }
            )

            groupedActions.removeAll()
            groupName = nil
        }
    }

    /// Register an action within a group
    func registerGroupedUndo(
        undo: @escaping @Sendable () -> Void,
        redo: @escaping @Sendable () -> Void
    ) {
        guard groupingLevel > 0 else { return }
        let action = UndoAction(name: "", undo: undo, redo: redo)
        groupedActions.append(action)
    }

    var isGrouping: Bool {
        groupingLevel > 0
    }
}
