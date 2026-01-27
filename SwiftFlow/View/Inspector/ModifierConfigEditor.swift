//
//  ModifierConfigEditor.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import SwiftUI

/// Configuration editor for a specific modifier
struct ModifierConfigEditor: View {
    @Bindable var modifier: ViewModifier
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        VStack(spacing: 8) {
            // Header
            HStack {
                Image(systemName: modifier.modifierType.iconName)
                    .font(.system(size: 12))
                    .foregroundStyle(modifier.modifierType.category.color)

                Text(modifier.modifierType.displayName)
                    .font(.system(size: 11, weight: .semibold))

                Spacer()
            }
            .padding(.horizontal, 12)

            Divider()

            // Configuration fields
            VStack(spacing: 8) {
                switch modifier.modifierType {
                case .padding:
                    paddingConfig
                case .frame:
                    frameConfig
                case .foregroundStyle:
                    foregroundStyleConfig
                case .background:
                    backgroundConfig
                case .font:
                    fontConfig
                case .cornerRadius:
                    cornerRadiusConfig
                case .opacity:
                    opacityConfig
                case .shadow:
                    shadowConfig
                case .offset:
                    offsetConfig
                case .border:
                    borderConfig
                case .blur:
                    blurConfig
                case .onTapGesture:
                    tapGestureConfig
                case .disabled:
                    disabledConfig
                case .lineLimit:
                    lineLimitConfig
                case .accessibilityLabel:
                    accessibilityLabelConfig
                default:
                    defaultConfig
                }
            }
            .padding(.horizontal, 12)
        }
        .padding(.vertical, 8)
        .background(Color(nsColor: .controlBackgroundColor).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .padding(.horizontal, 8)
    }

    // MARK: - Padding Config

    private var paddingConfig: some View {
        VStack(spacing: 8) {
            LabeledContent("Edges") {
                Picker("", selection: paddingEdgesBinding) {
                    Text("All").tag("all")
                    Text("Horizontal").tag("horizontal")
                    Text("Vertical").tag("vertical")
                    Text("Leading").tag("leading")
                    Text("Trailing").tag("trailing")
                    Text("Top").tag("top")
                    Text("Bottom").tag("bottom")
                }
                .labelsHidden()
                .frame(width: 100)
            }

            LabeledContent("Value") {
                HStack {
                    TextField("", value: paddingValueBinding, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 50)
                    Text("pt")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private var paddingEdgesBinding: Binding<String> {
        Binding(
            get: { modifier.getParam("edges", default: "all") },
            set: { modifier.setParam("edges", value: $0) }
        )
    }

    private var paddingValueBinding: Binding<Int> {
        Binding(
            get: { modifier.getParam("value", default: 16) },
            set: { modifier.setParam("value", value: $0) }
        )
    }

    // MARK: - Frame Config

    private var frameConfig: some View {
        VStack(spacing: 8) {
            LabeledContent("Width") {
                HStack {
                    TextField("", value: frameWidthBinding, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 50)
                    Toggle("Max", isOn: frameMaxWidthBinding)
                        .toggleStyle(.checkbox)
                }
            }

            LabeledContent("Height") {
                HStack {
                    TextField("", value: frameHeightBinding, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 50)
                    Toggle("Max", isOn: frameMaxHeightBinding)
                        .toggleStyle(.checkbox)
                }
            }

            LabeledContent("Alignment") {
                Picker("", selection: frameAlignmentBinding) {
                    Text("Center").tag("center")
                    Text("Leading").tag("leading")
                    Text("Trailing").tag("trailing")
                    Text("Top").tag("top")
                    Text("Bottom").tag("bottom")
                }
                .labelsHidden()
                .frame(width: 100)
            }
        }
    }

    private var frameWidthBinding: Binding<Int?> {
        Binding(
            get: { modifier.getParam("width") },
            set: { modifier.setParam("width", value: $0 as Any) }
        )
    }

    private var frameHeightBinding: Binding<Int?> {
        Binding(
            get: { modifier.getParam("height") },
            set: { modifier.setParam("height", value: $0 as Any) }
        )
    }

    private var frameMaxWidthBinding: Binding<Bool> {
        Binding(
            get: { modifier.getParam("maxWidth", default: false) },
            set: { modifier.setParam("maxWidth", value: $0) }
        )
    }

    private var frameMaxHeightBinding: Binding<Bool> {
        Binding(
            get: { modifier.getParam("maxHeight", default: false) },
            set: { modifier.setParam("maxHeight", value: $0) }
        )
    }

    private var frameAlignmentBinding: Binding<String> {
        Binding(
            get: { modifier.getParam("alignment", default: "center") },
            set: { modifier.setParam("alignment", value: $0) }
        )
    }

    // MARK: - ForegroundStyle Config

    private var foregroundStyleConfig: some View {
        VStack(spacing: 8) {
            LabeledContent("Color") {
                TextField("blue", text: foregroundColorBinding)
                    .textFieldStyle(.roundedBorder)
            }

            LabeledContent("Style") {
                Picker("", selection: foregroundStyleTypeBinding) {
                    Text("Primary").tag("primary")
                    Text("Secondary").tag("secondary")
                    Text("Tertiary").tag("tertiary")
                    Text("Custom").tag("custom")
                }
                .labelsHidden()
                .frame(width: 100)
            }
        }
    }

    private var foregroundColorBinding: Binding<String> {
        Binding(
            get: { modifier.getParam("color", default: "primary") },
            set: { modifier.setParam("color", value: $0) }
        )
    }

    private var foregroundStyleTypeBinding: Binding<String> {
        Binding(
            get: { modifier.getParam("style", default: "primary") },
            set: { modifier.setParam("style", value: $0) }
        )
    }

    // MARK: - Background Config

    private var backgroundConfig: some View {
        VStack(spacing: 8) {
            LabeledContent("Color") {
                TextField("blue", text: backgroundColorBinding)
                    .textFieldStyle(.roundedBorder)
            }

            LabeledContent("Opacity") {
                Slider(value: backgroundOpacityBinding, in: 0...1)
                    .frame(width: 100)
            }
        }
    }

    private var backgroundColorBinding: Binding<String> {
        Binding(
            get: { modifier.getParam("color", default: "blue") },
            set: { modifier.setParam("color", value: $0) }
        )
    }

    private var backgroundOpacityBinding: Binding<Double> {
        Binding(
            get: { modifier.getParam("opacity", default: 1.0) },
            set: { modifier.setParam("opacity", value: $0) }
        )
    }

    // MARK: - Font Config

    private var fontConfig: some View {
        VStack(spacing: 8) {
            LabeledContent("Style") {
                Picker("", selection: fontStyleBinding) {
                    Text("Body").tag("body")
                    Text("Title").tag("title")
                    Text("Title 2").tag("title2")
                    Text("Title 3").tag("title3")
                    Text("Headline").tag("headline")
                    Text("Subheadline").tag("subheadline")
                    Text("Caption").tag("caption")
                    Text("Footnote").tag("footnote")
                    Text("Custom").tag("custom")
                }
                .labelsHidden()
                .frame(width: 100)
            }

            LabeledContent("Size") {
                TextField("", value: fontSizeBinding, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 50)
            }

            LabeledContent("Design") {
                Picker("", selection: fontDesignBinding) {
                    Text("Default").tag("default")
                    Text("Rounded").tag("rounded")
                    Text("Monospaced").tag("monospaced")
                    Text("Serif").tag("serif")
                }
                .labelsHidden()
                .frame(width: 100)
            }
        }
    }

    private var fontStyleBinding: Binding<String> {
        Binding(
            get: { modifier.getParam("style", default: "body") },
            set: { modifier.setParam("style", value: $0) }
        )
    }

    private var fontSizeBinding: Binding<Int> {
        Binding(
            get: { modifier.getParam("size", default: 17) },
            set: { modifier.setParam("size", value: $0) }
        )
    }

    private var fontDesignBinding: Binding<String> {
        Binding(
            get: { modifier.getParam("design", default: "default") },
            set: { modifier.setParam("design", value: $0) }
        )
    }

    // MARK: - Corner Radius Config

    private var cornerRadiusConfig: some View {
        LabeledContent("Radius") {
            HStack {
                Slider(value: cornerRadiusValueBinding, in: 0...50)
                    .frame(width: 80)
                Text("\(Int(cornerRadiusValueBinding.wrappedValue))pt")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(width: 35)
            }
        }
    }

    private var cornerRadiusValueBinding: Binding<Double> {
        Binding(
            get: { Double(modifier.getParam("radius", default: 8)) },
            set: { modifier.setParam("radius", value: Int($0)) }
        )
    }

    // MARK: - Opacity Config

    private var opacityConfig: some View {
        LabeledContent("Value") {
            HStack {
                Slider(value: opacityValueBinding, in: 0...1)
                    .frame(width: 80)
                Text("\(Int(opacityValueBinding.wrappedValue * 100))%")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(width: 35)
            }
        }
    }

    private var opacityValueBinding: Binding<Double> {
        Binding(
            get: { modifier.getParam("value", default: 1.0) },
            set: { modifier.setParam("value", value: $0) }
        )
    }

    // MARK: - Shadow Config

    private var shadowConfig: some View {
        VStack(spacing: 8) {
            LabeledContent("Color") {
                TextField("black", text: shadowColorBinding)
                    .textFieldStyle(.roundedBorder)
            }

            LabeledContent("Radius") {
                TextField("", value: shadowRadiusBinding, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 50)
            }

            LabeledContent("X Offset") {
                TextField("", value: shadowXBinding, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 50)
            }

            LabeledContent("Y Offset") {
                TextField("", value: shadowYBinding, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 50)
            }
        }
    }

    private var shadowColorBinding: Binding<String> {
        Binding(
            get: { modifier.getParam("color", default: "black") },
            set: { modifier.setParam("color", value: $0) }
        )
    }

    private var shadowRadiusBinding: Binding<Int> {
        Binding(
            get: { modifier.getParam("radius", default: 4) },
            set: { modifier.setParam("radius", value: $0) }
        )
    }

    private var shadowXBinding: Binding<Int> {
        Binding(
            get: { modifier.getParam("x", default: 0) },
            set: { modifier.setParam("x", value: $0) }
        )
    }

    private var shadowYBinding: Binding<Int> {
        Binding(
            get: { modifier.getParam("y", default: 2) },
            set: { modifier.setParam("y", value: $0) }
        )
    }

    // MARK: - Offset Config

    private var offsetConfig: some View {
        VStack(spacing: 8) {
            LabeledContent("X") {
                TextField("", value: offsetXBinding, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 50)
            }

            LabeledContent("Y") {
                TextField("", value: offsetYBinding, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 50)
            }
        }
    }

    private var offsetXBinding: Binding<Int> {
        Binding(
            get: { modifier.getParam("x", default: 0) },
            set: { modifier.setParam("x", value: $0) }
        )
    }

    private var offsetYBinding: Binding<Int> {
        Binding(
            get: { modifier.getParam("y", default: 0) },
            set: { modifier.setParam("y", value: $0) }
        )
    }

    // MARK: - Border Config

    private var borderConfig: some View {
        VStack(spacing: 8) {
            LabeledContent("Color") {
                TextField("gray", text: borderColorBinding)
                    .textFieldStyle(.roundedBorder)
            }

            LabeledContent("Width") {
                TextField("", value: borderWidthBinding, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 50)
            }
        }
    }

    private var borderColorBinding: Binding<String> {
        Binding(
            get: { modifier.getParam("color", default: "gray") },
            set: { modifier.setParam("color", value: $0) }
        )
    }

    private var borderWidthBinding: Binding<Int> {
        Binding(
            get: { modifier.getParam("width", default: 1) },
            set: { modifier.setParam("width", value: $0) }
        )
    }

    // MARK: - Blur Config

    private var blurConfig: some View {
        LabeledContent("Radius") {
            HStack {
                Slider(value: blurRadiusBinding, in: 0...20)
                    .frame(width: 80)
                Text("\(Int(blurRadiusBinding.wrappedValue))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(width: 25)
            }
        }
    }

    private var blurRadiusBinding: Binding<Double> {
        Binding(
            get: { Double(modifier.getParam("radius", default: 3)) },
            set: { modifier.setParam("radius", value: Int($0)) }
        )
    }

    // MARK: - Tap Gesture Config

    private var tapGestureConfig: some View {
        VStack(spacing: 8) {
            LabeledContent("Action") {
                TextField("functionName", text: tapActionBinding)
                    .textFieldStyle(.roundedBorder)
            }

            LabeledContent("Count") {
                Stepper(value: tapCountBinding, in: 1...3) {
                    Text("\(tapCountBinding.wrappedValue)")
                }
            }
        }
    }

    private var tapActionBinding: Binding<String> {
        Binding(
            get: { modifier.getParam("action", default: "") },
            set: { modifier.setParam("action", value: $0) }
        )
    }

    private var tapCountBinding: Binding<Int> {
        Binding(
            get: { modifier.getParam("count", default: 1) },
            set: { modifier.setParam("count", value: $0) }
        )
    }

    // MARK: - Disabled Config

    private var disabledConfig: some View {
        LabeledContent("Condition") {
            TextField("isDisabled", text: disabledConditionBinding)
                .textFieldStyle(.roundedBorder)
        }
    }

    private var disabledConditionBinding: Binding<String> {
        Binding(
            get: { modifier.getParam("condition", default: "false") },
            set: { modifier.setParam("condition", value: $0) }
        )
    }

    // MARK: - Line Limit Config

    private var lineLimitConfig: some View {
        LabeledContent("Lines") {
            Stepper(value: lineLimitValueBinding, in: 1...100) {
                Text("\(lineLimitValueBinding.wrappedValue)")
            }
        }
    }

    private var lineLimitValueBinding: Binding<Int> {
        Binding(
            get: { modifier.getParam("limit", default: 1) },
            set: { modifier.setParam("limit", value: $0) }
        )
    }

    // MARK: - Accessibility Label Config

    private var accessibilityLabelConfig: some View {
        LabeledContent("Label") {
            TextField("Description", text: accessibilityLabelValueBinding)
                .textFieldStyle(.roundedBorder)
        }
    }

    private var accessibilityLabelValueBinding: Binding<String> {
        Binding(
            get: { modifier.getParam("label", default: "") },
            set: { modifier.setParam("label", value: $0) }
        )
    }

    // MARK: - Default Config

    private var defaultConfig: some View {
        Text("No additional configuration")
            .font(.caption)
            .foregroundStyle(.tertiary)
    }
}

#Preview {
    ModifierConfigEditor(modifier: ViewModifier(modifierType: .padding, sortOrder: 0))
        .frame(width: 280)
}
