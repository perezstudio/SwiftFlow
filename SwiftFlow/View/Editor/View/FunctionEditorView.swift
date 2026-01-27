//
//  FunctionEditorView.swift
//  SwiftFlow
//
//  Created on 1/27/26.
//

import SwiftUI
import SwiftData

/// Editor for a function's body using logic blocks
struct FunctionEditorView: View {
    @Bindable var function: ViewFunction
    let viewFile: ViewFile
    @Environment(\.modelContext) private var modelContext

    @State private var selectedBlockId: UUID?

    var body: some View {
        VStack(spacing: 0) {
            // Function header
            functionHeader

            Divider()

            // Function body
            HStack(spacing: 0) {
                // Logic block palette
                logicBlockPalette
                    .frame(width: 200)

                Divider()

                // Body editor
                bodyEditor
            }
        }
        .background(Color(nsColor: .windowBackgroundColor))
    }

    // MARK: - Header

    private var functionHeader: some View {
        HStack(spacing: 12) {
            // Function icon
            Image(systemName: "function")
                .font(.system(size: 16))
                .foregroundStyle(.orange)

            // Function signature
            VStack(alignment: .leading, spacing: 2) {
                Text(function.name)
                    .font(.system(size: 14, weight: .semibold))

                Text(function.signature)
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            // Function settings
            Menu {
                Toggle("async", isOn: Binding(
                    get: { function.isAsync },
                    set: { function.isAsync = $0 }
                ))

                Toggle("throws", isOn: Binding(
                    get: { function.throwsError },
                    set: { function.throwsError = $0 }
                ))

                Divider()

                Button("Edit Parameters...") {
                    // TODO: Show parameters editor
                }

                Button("Edit Return Type...") {
                    // TODO: Show return type editor
                }
            } label: {
                Image(systemName: "gear")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
            }
            .menuStyle(.borderlessButton)
        }
        .padding(12)
        .background(Color(nsColor: .controlBackgroundColor).opacity(0.5))
    }

    // MARK: - Logic Block Palette

    private var logicBlockPalette: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                paletteSection("Control Flow") {
                    palettItem(.ifStatement, icon: "arrow.triangle.branch", color: .blue)
                    palettItem(.guardStatement, icon: "shield", color: .orange)
                    palettItem(.forLoop, icon: "arrow.triangle.2.circlepath", color: .green)
                    palettItem(.whileLoop, icon: "repeat", color: .green)
                    palettItem(.switchStatement, icon: "switch.2", color: .purple)
                }

                paletteSection("Actions") {
                    palettItem(.assignVariable, icon: "equal", color: .blue)
                    palettItem(.functionCall, icon: "function", color: .orange)
                    palettItem(.returnStatement, icon: "return", color: .red)
                }

                paletteSection("Error Handling") {
                    palettItem(.doTryCatch, icon: "exclamationmark.triangle", color: .yellow)
                    palettItem(.throwError, icon: "exclamationmark.circle", color: .red)
                }
            }
            .padding(12)
        }
        .background(Color(nsColor: .controlBackgroundColor).opacity(0.3))
    }

    private func paletteSection(_ title: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(.tertiary)

            content()
        }
    }

    private func palettItem(_ type: LogicBlockType, icon: String, color: Color) -> some View {
        Button(action: { addBlock(type) }) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 12))
                    .foregroundStyle(color)
                    .frame(width: 20)

                Text(type.displayName)
                    .font(.system(size: 11))
                    .foregroundStyle(.primary)

                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color(nsColor: .controlBackgroundColor))
            .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Body Editor

    private var bodyEditor: some View {
        ScrollView {
            LazyVStack(spacing: 4) {
                if function.sortedBodyBlocks.isEmpty {
                    emptyBodyState
                } else {
                    ForEach(function.sortedBodyBlocks) { block in
                        LogicBlockRowView(
                            block: block,
                            isSelected: selectedBlockId == block.id,
                            onSelect: { selectedBlockId = block.id },
                            onDelete: { deleteBlock(block) }
                        )
                    }
                }
            }
            .padding(12)
        }
    }

    private var emptyBodyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "curlybraces")
                .font(.system(size: 32))
                .foregroundStyle(.tertiary)

            Text("Empty Function Body")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.secondary)

            Text("Drag logic blocks here or click to add")
                .font(.system(size: 11))
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(32)
    }

    // MARK: - Actions

    private func addBlock(_ type: LogicBlockType) {
        let block = LogicBlock(blockType: type)
        function.addBodyBlock(block)
        selectedBlockId = block.id
    }

    private func deleteBlock(_ block: LogicBlock) {
        if selectedBlockId == block.id {
            selectedBlockId = nil
        }
        function.removeBodyBlock(block)
        modelContext.delete(block)
    }
}

// MARK: - Logic Block Row

struct LogicBlockRowView: View {
    let block: LogicBlock
    let isSelected: Bool
    let onSelect: () -> Void
    let onDelete: () -> Void

    @State private var isHovering = false

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 8) {
                // Block icon
                Image(systemName: iconForType(block.blockType))
                    .font(.system(size: 12))
                    .foregroundStyle(colorForType(block.blockType))
                    .frame(width: 20)

                // Block info
                VStack(alignment: .leading, spacing: 2) {
                    Text(block.blockType.displayName)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.primary)

                    if let condition = block.conditionExpression {
                        Text(condition.toSwiftCode())
                            .font(.system(size: 10, design: .monospaced))
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }

                Spacer()

                // Delete button
                if isHovering {
                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .font(.system(size: 10))
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.borderless)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 2)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            isHovering = hovering
        }
    }

    private var backgroundColor: Color {
        if isSelected {
            return Color.accentColor.opacity(0.1)
        } else if isHovering {
            return Color(nsColor: .controlBackgroundColor)
        } else {
            return Color(nsColor: .controlBackgroundColor).opacity(0.5)
        }
    }

    private func iconForType(_ type: LogicBlockType) -> String {
        switch type {
        case .ifStatement: return "arrow.triangle.branch"
        case .elseIfStatement: return "arrow.triangle.branch"
        case .elseStatement: return "arrow.triangle.branch"
        case .guardStatement: return "shield"
        case .forLoop: return "arrow.triangle.2.circlepath"
        case .forEachLoop: return "arrow.triangle.2.circlepath"
        case .whileLoop: return "repeat"
        case .repeatWhileLoop: return "repeat"
        case .switchStatement: return "switch.2"
        case .caseStatement: return "number"
        case .defaultCase: return "number"
        case .assignVariable, .declareVariable, .declareConstant: return "equal"
        case .functionCall: return "function"
        case .returnStatement: return "return"
        case .breakStatement: return "stop"
        case .continueStatement: return "arrow.forward"
        case .doTryCatch: return "exclamationmark.triangle"
        case .throwError: return "exclamationmark.circle"
        case .taskBlock: return "bolt"
        case .comment: return "text.quote"
        case .customCode: return "chevron.left.forwardslash.chevron.right"
        default: return type.iconName
        }
    }

    private func colorForType(_ type: LogicBlockType) -> Color {
        switch type {
        case .ifStatement, .elseIfStatement, .elseStatement, .guardStatement:
            return .blue
        case .forLoop, .forEachLoop, .whileLoop, .repeatWhileLoop:
            return .green
        case .switchStatement, .caseStatement, .defaultCase:
            return .purple
        case .assignVariable, .declareVariable, .declareConstant:
            return .blue
        case .functionCall:
            return .orange
        case .returnStatement, .breakStatement, .continueStatement:
            return .red
        case .doTryCatch, .throwError, .catchBlock:
            return .yellow
        case .taskBlock, .asyncAwait, .mainActor:
            return .cyan
        case .comment, .customCode:
            return .gray
        default:
            return .secondary
        }
    }
}

#Preview {
    let function = ViewFunction(name: "handleTap", isAsync: false, throwsError: false)
    return FunctionEditorView(function: function, viewFile: ViewFile(name: "ContentView"))
        .frame(width: 600, height: 400)
}
