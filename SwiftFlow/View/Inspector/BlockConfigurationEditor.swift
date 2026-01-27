//
//  BlockConfigurationEditor.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import SwiftUI

/// Block-specific configuration editor that shows relevant fields based on block type
struct BlockConfigurationEditor: View {
    @Bindable var block: ViewBlock
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        VStack(spacing: 12) {
            switch block.blockType {
            // Layout blocks
            case .vStack, .hStack, .zStack:
                stackConfiguration
            case .lazyVStack, .lazyHStack:
                lazyStackConfiguration
            case .lazyVGrid, .lazyHGrid:
                gridConfiguration
            case .scrollView:
                scrollViewConfiguration
            case .spacer:
                spacerConfiguration

            // Text blocks
            case .text:
                textConfiguration
            case .label:
                labelConfiguration
            case .textField:
                textFieldConfiguration

            // Button blocks
            case .button:
                buttonConfiguration
            case .link:
                linkConfiguration
            case .toggle:
                toggleConfiguration

            // Image blocks
            case .image:
                imageConfiguration

            // Shape blocks
            case .rectangle, .roundedRectangle, .circle, .ellipse, .capsule:
                shapeConfiguration

            // Control flow
            case .forEach:
                forEachConfiguration
            case .ifBlock:
                ifBlockConfiguration

            // Navigation
            case .navigationStack:
                navigationStackConfiguration
            case .navigationLink:
                navigationLinkConfiguration
            case .sheet, .fullScreenCover:
                presentationConfiguration

            default:
                defaultConfiguration
            }
        }
        .padding(.horizontal, 12)
    }

    // MARK: - Stack Configuration

    private var stackConfiguration: some View {
        VStack(spacing: 8) {
            // Alignment
            LabeledContent("Alignment") {
                Picker("", selection: alignmentBinding) {
                    ForEach(StackAlignment.allCases) { alignment in
                        Text(alignment.displayName).tag(alignment)
                    }
                }
                .labelsHidden()
                .frame(width: 120)
            }

            // Spacing
            LabeledContent("Spacing") {
                HStack(spacing: 4) {
                    TextField("", value: spacingBinding, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 60)
                    Stepper("", value: spacingBinding, in: 0...100)
                        .labelsHidden()
                }
            }
        }
    }

    private var alignmentBinding: Binding<StackAlignment> {
        Binding(
            get: { StackAlignment(rawValue: block.getConfig("alignment", default: "center")) ?? .center },
            set: { block.setConfig("alignment", value: $0.rawValue) }
        )
    }

    private var spacingBinding: Binding<Int> {
        Binding(
            get: { block.getConfig("spacing", default: 8) },
            set: { block.setConfig("spacing", value: $0) }
        )
    }

    // MARK: - Lazy Stack Configuration

    private var lazyStackConfiguration: some View {
        VStack(spacing: 8) {
            stackConfiguration

            // Pinned views
            LabeledContent("Pinned Headers") {
                Toggle("", isOn: pinnedHeadersBinding)
                    .labelsHidden()
            }

            LabeledContent("Pinned Footers") {
                Toggle("", isOn: pinnedFootersBinding)
                    .labelsHidden()
            }
        }
    }

    private var pinnedHeadersBinding: Binding<Bool> {
        Binding(
            get: { block.getConfig("pinnedHeaders", default: false) },
            set: { block.setConfig("pinnedHeaders", value: $0) }
        )
    }

    private var pinnedFootersBinding: Binding<Bool> {
        Binding(
            get: { block.getConfig("pinnedFooters", default: false) },
            set: { block.setConfig("pinnedFooters", value: $0) }
        )
    }

    // MARK: - Grid Configuration

    private var gridConfiguration: some View {
        VStack(spacing: 8) {
            LabeledContent("Columns") {
                TextField("", value: columnsBinding, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 60)
            }

            LabeledContent("Spacing") {
                TextField("", value: spacingBinding, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 60)
            }
        }
    }

    private var columnsBinding: Binding<Int> {
        Binding(
            get: { block.getConfig("columns", default: 2) },
            set: { block.setConfig("columns", value: $0) }
        )
    }

    // MARK: - ScrollView Configuration

    private var scrollViewConfiguration: some View {
        VStack(spacing: 8) {
            LabeledContent("Axes") {
                Picker("", selection: scrollAxesBinding) {
                    Text("Vertical").tag("vertical")
                    Text("Horizontal").tag("horizontal")
                    Text("Both").tag("both")
                }
                .labelsHidden()
                .frame(width: 120)
            }

            LabeledContent("Show Indicators") {
                Toggle("", isOn: showIndicatorsBinding)
                    .labelsHidden()
            }
        }
    }

    private var scrollAxesBinding: Binding<String> {
        Binding(
            get: { block.getConfig("axes", default: "vertical") },
            set: { block.setConfig("axes", value: $0) }
        )
    }

    private var showIndicatorsBinding: Binding<Bool> {
        Binding(
            get: { block.getConfig("showIndicators", default: true) },
            set: { block.setConfig("showIndicators", value: $0) }
        )
    }

    // MARK: - Spacer Configuration

    private var spacerConfiguration: some View {
        VStack(spacing: 8) {
            LabeledContent("Min Length") {
                HStack(spacing: 4) {
                    TextField("", value: minLengthBinding, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 60)
                    Text("pt")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private var minLengthBinding: Binding<Int> {
        Binding(
            get: { block.getConfig("minLength", default: 0) },
            set: { block.setConfig("minLength", value: $0) }
        )
    }

    // MARK: - Text Configuration

    private var textConfiguration: some View {
        VStack(spacing: 8) {
            LabeledContent("Content") {
                TextField("Text content", text: textContentBinding)
                    .textFieldStyle(.roundedBorder)
            }

            LabeledContent("Font") {
                Picker("", selection: fontStyleBinding) {
                    Text("Body").tag("body")
                    Text("Title").tag("title")
                    Text("Headline").tag("headline")
                    Text("Subheadline").tag("subheadline")
                    Text("Caption").tag("caption")
                    Text("Footnote").tag("footnote")
                }
                .labelsHidden()
                .frame(width: 120)
            }

            LabeledContent("Weight") {
                Picker("", selection: fontWeightBinding) {
                    Text("Regular").tag("regular")
                    Text("Medium").tag("medium")
                    Text("Semibold").tag("semibold")
                    Text("Bold").tag("bold")
                }
                .labelsHidden()
                .frame(width: 120)
            }
        }
    }

    private var textContentBinding: Binding<String> {
        Binding(
            get: { block.textContent ?? "" },
            set: { block.textContent = $0 }
        )
    }

    private var fontStyleBinding: Binding<String> {
        Binding(
            get: { block.getConfig("fontStyle", default: "body") },
            set: { block.setConfig("fontStyle", value: $0) }
        )
    }

    private var fontWeightBinding: Binding<String> {
        Binding(
            get: { block.getConfig("fontWeight", default: "regular") },
            set: { block.setConfig("fontWeight", value: $0) }
        )
    }

    // MARK: - Label Configuration

    private var labelConfiguration: some View {
        VStack(spacing: 8) {
            LabeledContent("Title") {
                TextField("Label title", text: labelTitleBinding)
                    .textFieldStyle(.roundedBorder)
            }

            LabeledContent("System Image") {
                TextField("star.fill", text: labelImageBinding)
                    .textFieldStyle(.roundedBorder)
            }
        }
    }

    private var labelTitleBinding: Binding<String> {
        Binding(
            get: { block.getConfig("title", default: "") },
            set: { block.setConfig("title", value: $0) }
        )
    }

    private var labelImageBinding: Binding<String> {
        Binding(
            get: { block.getConfig("systemImage", default: "") },
            set: { block.setConfig("systemImage", value: $0) }
        )
    }

    // MARK: - TextField Configuration

    private var textFieldConfiguration: some View {
        VStack(spacing: 8) {
            LabeledContent("Placeholder") {
                TextField("Placeholder", text: placeholderBinding)
                    .textFieldStyle(.roundedBorder)
            }

            LabeledContent("Bound Variable") {
                TextField("variableName", text: boundVariableBinding)
                    .textFieldStyle(.roundedBorder)
            }
        }
    }

    private var placeholderBinding: Binding<String> {
        Binding(
            get: { block.getConfig("placeholder", default: "") },
            set: { block.setConfig("placeholder", value: $0) }
        )
    }

    private var boundVariableBinding: Binding<String> {
        Binding(
            get: { block.getConfig("boundVariable", default: "") },
            set: { block.setConfig("boundVariable", value: $0) }
        )
    }

    // MARK: - Button Configuration

    private var buttonConfiguration: some View {
        VStack(spacing: 8) {
            LabeledContent("Label") {
                TextField("Button", text: buttonLabelBinding)
                    .textFieldStyle(.roundedBorder)
            }

            LabeledContent("Action") {
                TextField("functionName", text: buttonActionBinding)
                    .textFieldStyle(.roundedBorder)
            }

            LabeledContent("Role") {
                Picker("", selection: buttonRoleBinding) {
                    Text("Default").tag("default")
                    Text("Cancel").tag("cancel")
                    Text("Destructive").tag("destructive")
                }
                .labelsHidden()
                .frame(width: 120)
            }
        }
    }

    private var buttonLabelBinding: Binding<String> {
        Binding(
            get: { block.buttonLabel ?? "" },
            set: { block.buttonLabel = $0 }
        )
    }

    private var buttonActionBinding: Binding<String> {
        Binding(
            get: { block.buttonActionFunctionName ?? "" },
            set: { block.buttonActionFunctionName = $0 }
        )
    }

    private var buttonRoleBinding: Binding<String> {
        Binding(
            get: { block.getConfig("role", default: "default") },
            set: { block.setConfig("role", value: $0) }
        )
    }

    // MARK: - Link Configuration

    private var linkConfiguration: some View {
        VStack(spacing: 8) {
            LabeledContent("Title") {
                TextField("Link Title", text: linkTitleBinding)
                    .textFieldStyle(.roundedBorder)
            }

            LabeledContent("URL") {
                TextField("https://...", text: linkURLBinding)
                    .textFieldStyle(.roundedBorder)
            }
        }
    }

    private var linkTitleBinding: Binding<String> {
        Binding(
            get: { block.getConfig("title", default: "") },
            set: { block.setConfig("title", value: $0) }
        )
    }

    private var linkURLBinding: Binding<String> {
        Binding(
            get: { block.getConfig("url", default: "") },
            set: { block.setConfig("url", value: $0) }
        )
    }

    // MARK: - Toggle Configuration

    private var toggleConfiguration: some View {
        VStack(spacing: 8) {
            LabeledContent("Label") {
                TextField("Toggle label", text: toggleLabelBinding)
                    .textFieldStyle(.roundedBorder)
            }

            LabeledContent("Bound Variable") {
                TextField("isOn", text: toggleBoundBinding)
                    .textFieldStyle(.roundedBorder)
            }
        }
    }

    private var toggleLabelBinding: Binding<String> {
        Binding(
            get: { block.getConfig("label", default: "") },
            set: { block.setConfig("label", value: $0) }
        )
    }

    private var toggleBoundBinding: Binding<String> {
        Binding(
            get: { block.getConfig("boundVariable", default: "") },
            set: { block.setConfig("boundVariable", value: $0) }
        )
    }

    // MARK: - Image Configuration

    private var imageConfiguration: some View {
        VStack(spacing: 8) {
            LabeledContent("Source") {
                Picker("", selection: imageSourceBinding) {
                    Text("System").tag("system")
                    Text("Asset").tag("asset")
                }
                .labelsHidden()
                .pickerStyle(.segmented)
            }

            LabeledContent("Name") {
                TextField("star.fill", text: imageNameBinding)
                    .textFieldStyle(.roundedBorder)
            }

            LabeledContent("Resizable") {
                Toggle("", isOn: imageResizableBinding)
                    .labelsHidden()
            }
        }
    }

    private var imageSourceBinding: Binding<String> {
        Binding(
            get: { block.getConfig("source", default: "system") },
            set: { block.setConfig("source", value: $0) }
        )
    }

    private var imageNameBinding: Binding<String> {
        Binding(
            get: { block.getConfig("name", default: "") },
            set: { block.setConfig("name", value: $0) }
        )
    }

    private var imageResizableBinding: Binding<Bool> {
        Binding(
            get: { block.getConfig("resizable", default: false) },
            set: { block.setConfig("resizable", value: $0) }
        )
    }

    // MARK: - Shape Configuration

    private var shapeConfiguration: some View {
        VStack(spacing: 8) {
            if block.blockType == .roundedRectangle {
                LabeledContent("Corner Radius") {
                    TextField("", value: cornerRadiusBinding, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 60)
                }
            }

            LabeledContent("Fill Color") {
                TextField("blue", text: fillColorBinding)
                    .textFieldStyle(.roundedBorder)
            }

            LabeledContent("Stroke Color") {
                TextField("clear", text: strokeColorBinding)
                    .textFieldStyle(.roundedBorder)
            }

            LabeledContent("Stroke Width") {
                TextField("", value: strokeWidthBinding, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 60)
            }
        }
    }

    private var cornerRadiusBinding: Binding<Int> {
        Binding(
            get: { block.getConfig("cornerRadius", default: 8) },
            set: { block.setConfig("cornerRadius", value: $0) }
        )
    }

    private var fillColorBinding: Binding<String> {
        Binding(
            get: { block.getConfig("fillColor", default: "blue") },
            set: { block.setConfig("fillColor", value: $0) }
        )
    }

    private var strokeColorBinding: Binding<String> {
        Binding(
            get: { block.getConfig("strokeColor", default: "clear") },
            set: { block.setConfig("strokeColor", value: $0) }
        )
    }

    private var strokeWidthBinding: Binding<Int> {
        Binding(
            get: { block.getConfig("strokeWidth", default: 0) },
            set: { block.setConfig("strokeWidth", value: $0) }
        )
    }

    // MARK: - ForEach Configuration

    private var forEachConfiguration: some View {
        VStack(spacing: 8) {
            LabeledContent("Data Source") {
                TextField("items", text: dataSourceBinding)
                    .textFieldStyle(.roundedBorder)
            }

            LabeledContent("Item Name") {
                TextField("item", text: itemNameBinding)
                    .textFieldStyle(.roundedBorder)
            }
        }
    }

    private var dataSourceBinding: Binding<String> {
        Binding(
            get: { block.getConfig("dataSource", default: "") },
            set: { block.setConfig("dataSource", value: $0) }
        )
    }

    private var itemNameBinding: Binding<String> {
        Binding(
            get: { block.forEachItemName ?? "item" },
            set: { block.forEachItemName = $0 }
        )
    }

    // MARK: - If Block Configuration

    private var ifBlockConfiguration: some View {
        VStack(spacing: 8) {
            LabeledContent("Condition") {
                TextField("condition", text: conditionBinding)
                    .textFieldStyle(.roundedBorder)
            }

            Text("Add child blocks for the 'then' branch")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
    }

    private var conditionBinding: Binding<String> {
        Binding(
            get: { block.getConfig("condition", default: "") },
            set: { block.setConfig("condition", value: $0) }
        )
    }

    // MARK: - NavigationStack Configuration

    private var navigationStackConfiguration: some View {
        VStack(spacing: 8) {
            LabeledContent("Path Variable") {
                TextField("path", text: pathVariableBinding)
                    .textFieldStyle(.roundedBorder)
            }
        }
    }

    private var pathVariableBinding: Binding<String> {
        Binding(
            get: { block.getConfig("pathVariable", default: "") },
            set: { block.setConfig("pathVariable", value: $0) }
        )
    }

    // MARK: - NavigationLink Configuration

    private var navigationLinkConfiguration: some View {
        VStack(spacing: 8) {
            LabeledContent("Destination") {
                TextField("DestinationView", text: destinationBinding)
                    .textFieldStyle(.roundedBorder)
            }

            LabeledContent("Value") {
                TextField("value", text: valueBinding)
                    .textFieldStyle(.roundedBorder)
            }
        }
    }

    private var destinationBinding: Binding<String> {
        Binding(
            get: { block.getConfig("destination", default: "") },
            set: { block.setConfig("destination", value: $0) }
        )
    }

    private var valueBinding: Binding<String> {
        Binding(
            get: { block.getConfig("value", default: "") },
            set: { block.setConfig("value", value: $0) }
        )
    }

    // MARK: - Presentation Configuration

    private var presentationConfiguration: some View {
        VStack(spacing: 8) {
            LabeledContent("Is Presented") {
                TextField("showSheet", text: isPresentedBinding)
                    .textFieldStyle(.roundedBorder)
            }

            if block.blockType == .sheet {
                LabeledContent("Detents") {
                    Picker("", selection: detentsBinding) {
                        Text("Medium").tag("medium")
                        Text("Large").tag("large")
                        Text("Custom").tag("custom")
                    }
                    .labelsHidden()
                    .frame(width: 120)
                }
            }
        }
    }

    private var isPresentedBinding: Binding<String> {
        Binding(
            get: { block.getConfig("isPresented", default: "") },
            set: { block.setConfig("isPresented", value: $0) }
        )
    }

    private var detentsBinding: Binding<String> {
        Binding(
            get: { block.getConfig("detents", default: "large") },
            set: { block.setConfig("detents", value: $0) }
        )
    }

    // MARK: - Default Configuration

    private var defaultConfiguration: some View {
        Text("No additional configuration")
            .font(.caption)
            .foregroundStyle(.tertiary)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 8)
    }
}

// MARK: - Stack Alignment Enum

enum StackAlignment: String, CaseIterable, Identifiable {
    case leading
    case center
    case trailing
    case top
    case bottom

    var id: String { rawValue }

    var displayName: String {
        rawValue.capitalized
    }
}

#Preview {
    BlockConfigurationEditor(block: ViewBlock(blockType: .vStack))
        .frame(width: 280)
}
