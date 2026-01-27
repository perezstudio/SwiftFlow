//
//  CustomTextField.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import SwiftUI

/// A styled text field for consistent appearance across the app
struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    var isMonospaced: Bool = false
    var onCommit: (() -> Void)?

    init(
        _ placeholder: String,
        text: Binding<String>,
        isMonospaced: Bool = false,
        onCommit: (() -> Void)? = nil
    ) {
        self.placeholder = placeholder
        self._text = text
        self.isMonospaced = isMonospaced
        self.onCommit = onCommit
    }

    var body: some View {
        TextField(placeholder, text: $text)
            .textFieldStyle(.plain)
            .font(isMonospaced ? .system(size: 12, design: .monospaced) : .system(size: 12))
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(Color(nsColor: .textBackgroundColor))
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .strokeBorder(Color(nsColor: .separatorColor), lineWidth: 1)
            )
            .onSubmit {
                onCommit?()
            }
    }
}

/// A number text field that only accepts numeric input
struct CustomNumberField: View {
    let placeholder: String
    @Binding var value: Double
    var range: ClosedRange<Double>?
    var step: Double = 1

    init(
        _ placeholder: String,
        value: Binding<Double>,
        range: ClosedRange<Double>? = nil,
        step: Double = 1
    ) {
        self.placeholder = placeholder
        self._value = value
        self.range = range
        self.step = step
    }

    var body: some View {
        HStack(spacing: 0) {
            TextField(placeholder, value: $value, format: .number)
                .textFieldStyle(.plain)
                .font(.system(size: 12, design: .monospaced))
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .multilineTextAlignment(.trailing)
                .onSubmit {
                    clampValue()
                }

            // Stepper buttons
            VStack(spacing: 0) {
                Button(action: increment) {
                    Image(systemName: "chevron.up")
                        .font(.system(size: 8, weight: .semibold))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .buttonStyle(.plain)

                Divider()

                Button(action: decrement) {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 8, weight: .semibold))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .buttonStyle(.plain)
            }
            .frame(width: 16)
            .foregroundStyle(.secondary)
        }
        .background(Color(nsColor: .textBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .strokeBorder(Color(nsColor: .separatorColor), lineWidth: 1)
        )
        .frame(height: 28)
    }

    private func increment() {
        value += step
        clampValue()
    }

    private func decrement() {
        value -= step
        clampValue()
    }

    private func clampValue() {
        if let range {
            value = min(max(value, range.lowerBound), range.upperBound)
        }
    }
}

/// A text field styled for code/expression input
struct CodeTextField: View {
    let placeholder: String
    @Binding var text: String

    var body: some View {
        TextField(placeholder, text: $text)
            .textFieldStyle(.plain)
            .font(.system(size: 12, design: .monospaced))
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(Color(nsColor: .textBackgroundColor).opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .strokeBorder(Color.accentColor.opacity(0.3), lineWidth: 1)
            )
    }
}

#Preview {
    VStack(spacing: 16) {
        CustomTextField("Enter name...", text: .constant("MyView"))

        CustomTextField("Enter code...", text: .constant("count + 1"), isMonospaced: true)

        CustomNumberField("Value", value: .constant(8), range: 0...100, step: 1)
            .frame(width: 80)

        CodeTextField(placeholder: "Expression", text: .constant("items.count"))
    }
    .padding()
    .frame(width: 250)
}
