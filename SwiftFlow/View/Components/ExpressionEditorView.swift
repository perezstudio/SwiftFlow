//
//  ExpressionEditorView.swift
//  SwiftFlow
//
//  Created on 1/27/26.
//

import SwiftUI
import SwiftData

/// Visual editor for building Swift expressions
struct ExpressionEditorView: View {
    @Bindable var expression: Expression
    let viewFile: ViewFile?
    let onUpdate: () -> Void

    @State private var showingVariablePicker = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Expression preview
            expressionPreview

            // Editor based on expression type
            expressionEditor
        }
    }

    // MARK: - Preview

    private var expressionPreview: some View {
        HStack {
            Text(expression.toSwiftCode())
                .font(.system(size: 12, design: .monospaced))
                .foregroundStyle(.primary)
                .lineLimit(1)

            Spacer()

            if let resultType = expression.resultType {
                Text(resultType.displayName)
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color(nsColor: .controlBackgroundColor))
                    .clipShape(RoundedRectangle(cornerRadius: 4))
            }
        }
        .padding(8)
        .background(Color(nsColor: .textBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }

    // MARK: - Editor

    @ViewBuilder
    private var expressionEditor: some View {
        switch expression.expressionType {
        case .stringLiteral:
            stringLiteralEditor
        case .intLiteral:
            intLiteralEditor
        case .doubleLiteral:
            doubleLiteralEditor
        case .boolLiteral:
            boolLiteralEditor
        case .variableReference:
            variableReferenceEditor
        case .propertyReference:
            propertyReferenceEditor
        default:
            genericEditor
        }
    }

    private var stringLiteralEditor: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("String Value")
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.secondary)

            TextField("value", text: Binding(
                get: { expression.stringValue ?? "" },
                set: {
                    expression.stringValue = $0
                    onUpdate()
                }
            ))
            .textFieldStyle(.roundedBorder)
            .font(.system(size: 12))
        }
    }

    private var intLiteralEditor: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Integer Value")
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.secondary)

            TextField("0", value: Binding(
                get: { expression.intValue ?? 0 },
                set: {
                    expression.intValue = $0
                    onUpdate()
                }
            ), format: .number)
            .textFieldStyle(.roundedBorder)
            .font(.system(size: 12, design: .monospaced))
        }
    }

    private var doubleLiteralEditor: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Decimal Value")
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.secondary)

            TextField("0.0", value: Binding(
                get: { expression.doubleValue ?? 0.0 },
                set: {
                    expression.doubleValue = $0
                    onUpdate()
                }
            ), format: .number)
            .textFieldStyle(.roundedBorder)
            .font(.system(size: 12, design: .monospaced))
        }
    }

    private var boolLiteralEditor: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Boolean Value")
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.secondary)

            Picker("", selection: Binding(
                get: { expression.boolValue ?? false },
                set: {
                    expression.boolValue = $0
                    onUpdate()
                }
            )) {
                Text("true").tag(true)
                Text("false").tag(false)
            }
            .pickerStyle(.segmented)
        }
    }

    private var variableReferenceEditor: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Variable")
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.secondary)

            HStack {
                Text(expression.variableName ?? "Select variable")
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundStyle(expression.variableName != nil ? .primary : .tertiary)

                Spacer()

                Button(action: { showingVariablePicker = true }) {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 10))
                }
                .buttonStyle(.borderless)
            }
            .padding(8)
            .background(Color(nsColor: .controlBackgroundColor))
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .popover(isPresented: $showingVariablePicker) {
                if let viewFile {
                    VariablePickerView(viewFile: viewFile) { name, type in
                        expression.variableName = name
                        expression.resultType = type
                        showingVariablePicker = false
                        onUpdate()
                    }
                }
            }
        }
    }

    private var propertyReferenceEditor: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Property Path")
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.secondary)

            TextField("object.property", text: Binding(
                get: { expression.propertyPath ?? "" },
                set: {
                    expression.propertyPath = $0
                    onUpdate()
                }
            ))
            .textFieldStyle(.roundedBorder)
            .font(.system(size: 12, design: .monospaced))
        }
    }

    private var genericEditor: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Expression Type: \(String(describing: expression.expressionType))")
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.secondary)

            Text("Complex expression editing coming soon")
                .font(.system(size: 11))
                .foregroundStyle(.tertiary)
                .padding(8)
                .frame(maxWidth: .infinity)
                .background(Color(nsColor: .controlBackgroundColor))
                .clipShape(RoundedRectangle(cornerRadius: 6))
        }
    }
}

// MARK: - Expression Type Picker

struct ExpressionTypePicker: View {
    @Binding var selectedType: ExpressionType

    private let commonTypes: [ExpressionType] = [
        .stringLiteral,
        .intLiteral,
        .doubleLiteral,
        .boolLiteral,
        .variableReference,
        .propertyReference,
        .functionCall
    ]

    var body: some View {
        Menu {
            ForEach(commonTypes, id: \.self) { type in
                Button(type.displayName) {
                    selectedType = type
                }
            }
        } label: {
            HStack {
                Text(selectedType.displayName)
                    .font(.system(size: 11))

                Image(systemName: "chevron.down")
                    .font(.system(size: 9))
            }
            .foregroundStyle(.primary)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color(nsColor: .controlBackgroundColor))
            .clipShape(RoundedRectangle(cornerRadius: 4))
        }
        .menuStyle(.borderlessButton)
    }
}

#Preview {
    VStack(spacing: 16) {
        ExpressionEditorView(
            expression: Expression.stringLiteral("Hello"),
            viewFile: nil,
            onUpdate: {}
        )

        ExpressionEditorView(
            expression: Expression.intLiteral(42),
            viewFile: nil,
            onUpdate: {}
        )

        ExpressionEditorView(
            expression: Expression.boolLiteral(true),
            viewFile: nil,
            onUpdate: {}
        )
    }
    .padding()
    .frame(width: 280)
}
