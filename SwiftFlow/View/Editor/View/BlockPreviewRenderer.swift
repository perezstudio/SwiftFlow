//
//  BlockPreviewRenderer.swift
//  SwiftFlow
//
//  Created on 1/27/26.
//

import SwiftUI

/// Renders ViewBlock hierarchy as actual SwiftUI views for device preview
struct BlockPreviewRenderer: View {
    let block: ViewBlock
    let selectedBlockId: UUID?
    let onBlockTapped: (ViewBlock) -> Void

    var body: some View {
        renderBlock(block)
    }

    // MARK: - Block Rendering

    @ViewBuilder
    private func renderBlock(_ block: ViewBlock) -> some View {
        let baseView = renderBaseBlock(block)
        let modifiedView = applyModifiers(to: baseView, from: block)

        modifiedView
            .contentShape(Rectangle())
            .overlay(selectionOverlay(for: block))
            .onTapGesture {
                onBlockTapped(block)
            }
    }

    @ViewBuilder
    private func renderBaseBlock(_ block: ViewBlock) -> some View {
        switch block.blockType {
        // MARK: Layout Containers
        case .vStack:
            let alignment = parseHorizontalAlignment(block.stackAlignment)
            let spacing = block.stackSpacing ?? 8
            VStack(alignment: alignment, spacing: spacing) {
                renderChildren(of: block)
            }

        case .hStack:
            let alignment = parseVerticalAlignment(block.stackAlignment)
            let spacing = block.stackSpacing ?? 8
            HStack(alignment: alignment, spacing: spacing) {
                renderChildren(of: block)
            }

        case .zStack:
            ZStack {
                renderChildren(of: block)
            }

        case .lazyVStack:
            let alignment = parseHorizontalAlignment(block.stackAlignment)
            let spacing = block.stackSpacing ?? 8
            LazyVStack(alignment: alignment, spacing: spacing) {
                renderChildren(of: block)
            }

        case .lazyHStack:
            let alignment = parseVerticalAlignment(block.stackAlignment)
            let spacing = block.stackSpacing ?? 8
            LazyHStack(alignment: alignment, spacing: spacing) {
                renderChildren(of: block)
            }

        case .lazyVGrid:
            let columns = [GridItem(.flexible())]
            LazyVGrid(columns: columns) {
                renderChildren(of: block)
            }

        case .lazyHGrid:
            let rows = [GridItem(.flexible())]
            LazyHGrid(rows: rows) {
                renderChildren(of: block)
            }

        case .grid:
            Grid {
                renderChildren(of: block)
            }

        case .scrollView:
            ScrollView {
                renderChildren(of: block)
            }

        case .group:
            Group {
                renderChildren(of: block)
            }

        case .form:
            Form {
                renderChildren(of: block)
            }

        case .section:
            Section {
                renderChildren(of: block)
            }

        // MARK: Spacing & Dividers
        case .spacer:
            Spacer()

        case .divider:
            Divider()

        // MARK: Text & Labels
        case .text:
            Text(block.textContent ?? "Text")

        case .label:
            Label(
                block.getConfig("title", default: "Label"),
                systemImage: block.getConfig("systemImage", default: "star")
            )

        case .textField:
            TextField(
                block.textFieldPlaceholder ?? "Placeholder",
                text: .constant(block.getConfig("previewText", default: ""))
            )
            .textFieldStyle(.roundedBorder)

        case .secureField:
            SecureField(
                block.textFieldPlaceholder ?? "Password",
                text: .constant("")
            )
            .textFieldStyle(.roundedBorder)

        case .textEditor:
            TextEditor(text: .constant(block.getConfig("previewText", default: "Enter text...")))
                .frame(minHeight: 100)

        // MARK: Buttons & Controls
        case .button:
            Button(block.buttonLabel ?? "Button") {
                // Preview only - no action
            }

        case .link:
            Link(
                block.getConfig("title", default: "Link"),
                destination: URL(string: block.getConfig("url", default: "https://example.com"))!
            )

        case .menu:
            Menu(block.getConfig("title", default: "Menu")) {
                Text("Option 1")
                Text("Option 2")
            }

        case .toggle:
            Toggle(
                block.getConfig("label", default: "Toggle"),
                isOn: .constant(block.getConfig("previewValue", default: true))
            )

        case .slider:
            Slider(value: .constant(0.5))

        case .stepper:
            Stepper(
                block.getConfig("label", default: "Value"),
                value: .constant(block.getConfig("previewValue", default: 0))
            )

        case .picker:
            Picker(
                block.getConfig("label", default: "Picker"),
                selection: .constant(0)
            ) {
                Text("Option 1").tag(0)
                Text("Option 2").tag(1)
            }

        case .datePicker:
            DatePicker(
                block.getConfig("label", default: "Date"),
                selection: .constant(Date())
            )

        case .colorPicker:
            ColorPicker(
                block.getConfig("label", default: "Color"),
                selection: .constant(.blue)
            )

        // MARK: Images & Media
        case .image:
            if block.imageIsSystemName {
                Image(systemName: block.imageName ?? "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                // Show placeholder for asset images
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.secondary)
            }

        case .asyncImage:
            // Show placeholder for async images
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.secondary.opacity(0.2))
                .overlay {
                    Image(systemName: "photo.badge.arrow.down")
                        .foregroundStyle(.secondary)
                }
                .frame(width: 100, height: 100)

        // MARK: Shapes
        case .rectangle:
            Rectangle()

        case .roundedRectangle:
            let radius: Double = block.getConfig("cornerRadius", default: 10)
            RoundedRectangle(cornerRadius: radius)

        case .circle:
            Circle()

        case .ellipse:
            Ellipse()

        case .capsule:
            Capsule()

        // MARK: Control Flow
        case .forEach:
            // Show sample items
            VStack(spacing: 8) {
                ForEach(0..<3, id: \.self) { index in
                    HStack {
                        Text("Item \(index + 1)")
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                    .padding(8)
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(4)
                }
            }

        case .ifBlock:
            // Show conditional placeholder
            VStack {
                HStack {
                    Image(systemName: "questionmark.diamond")
                        .foregroundStyle(.blue)
                    Text("Conditional")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .padding(8)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(4)

                renderChildren(of: block)
            }

        case .switchBlock:
            // Show switch placeholder
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image(systemName: "arrow.triangle.branch")
                        .foregroundStyle(.purple)
                    Text("Switch")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(8)
                .background(Color.purple.opacity(0.1))
                .cornerRadius(4)

                renderChildren(of: block)
            }

        // MARK: Navigation
        case .navigationStack:
            NavigationStack {
                VStack {
                    renderChildren(of: block)
                }
            }

        case .navigationLink:
            NavigationLink(destination: Text("Destination")) {
                HStack {
                    renderChildren(of: block)
                }
            }

        case .navigationDestination:
            renderChildren(of: block)

        case .sheet:
            // Show sheet indicator with children
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image(systemName: "rectangle.bottomhalf.inset.filled")
                        .foregroundStyle(.orange)
                    Text("Sheet Content")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(8)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(4)

                renderChildren(of: block)
            }

        case .fullScreenCover:
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image(systemName: "rectangle.inset.filled")
                        .foregroundStyle(.orange)
                    Text("Full Screen Cover Content")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(8)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(4)

                renderChildren(of: block)
            }

        case .popover:
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image(systemName: "text.bubble")
                        .foregroundStyle(.blue)
                    Text("Popover Content")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(8)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(4)

                renderChildren(of: block)
            }

        case .alert:
            HStack {
                Image(systemName: "exclamationmark.triangle")
                    .foregroundStyle(.yellow)
                Text("Alert")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(8)
            .background(Color.yellow.opacity(0.1))
            .cornerRadius(4)

        case .confirmationDialog:
            HStack {
                Image(systemName: "questionmark.circle")
                    .foregroundStyle(.blue)
                Text("Confirmation Dialog")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(8)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(4)

        // MARK: Custom
        case .customComponent:
            // Show placeholder for custom components
            HStack {
                Image(systemName: "puzzlepiece")
                    .foregroundStyle(.purple)
                Text(block.customComponentName ?? "Custom Component")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(8)
            .frame(maxWidth: .infinity)
            .background(Color.purple.opacity(0.1))
            .cornerRadius(4)
        }
    }

    // MARK: - Children Rendering

    @ViewBuilder
    private func renderChildren(of block: ViewBlock) -> some View {
        ForEach(block.sortedChildren) { child in
            renderBlock(child)
        }
    }

    // MARK: - Modifier Application

    private func applyModifiers<V: View>(to view: V, from block: ViewBlock) -> AnyView {
        var result: AnyView = AnyView(view)

        for modifier in block.sortedModifiers {
            result = applyModifier(result, modifier: modifier)
        }

        return result
    }

    private func applyModifier(_ view: AnyView, modifier: SwiftFlow.ViewModifier) -> AnyView {
        switch modifier.modifierType {
        case .padding:
            let length = modifier.paddingLength ?? 16
            return AnyView(view.padding(length))

        case .frame:
            let width = modifier.frameWidth.map { CGFloat($0) }
            let height = modifier.frameHeight.map { CGFloat($0) }
            let minWidth = modifier.frameMinWidth.map { CGFloat($0) }
            let maxWidth = modifier.frameMaxWidth.map { CGFloat($0) }
            let minHeight = modifier.frameMinHeight.map { CGFloat($0) }
            let maxHeight = modifier.frameMaxHeight.map { CGFloat($0) }

            return AnyView(view.frame(
                minWidth: minWidth,
                idealWidth: width,
                maxWidth: maxWidth == -1 ? .infinity : maxWidth,
                minHeight: minHeight,
                idealHeight: height,
                maxHeight: maxHeight == -1 ? .infinity : maxHeight
            ))

        case .background:
            if let colorName = modifier.colorValue {
                let color = parseColor(colorName)
                return AnyView(view.background(color))
            }
            return view

        case .foregroundStyle, .foregroundColor:
            if let colorName = modifier.colorValue {
                let color = parseColor(colorName)
                return AnyView(view.foregroundStyle(color))
            }
            return view

        case .opacity:
            return AnyView(view.opacity(modifier.opacityValue))

        case .cornerRadius:
            return AnyView(view.clipShape(RoundedRectangle(cornerRadius: modifier.cornerRadiusValue)))

        case .font:
            if let styleName = modifier.fontStyle {
                let font = parseFont(styleName, size: modifier.fontSize)
                return AnyView(view.font(font))
            }
            return view

        case .fontWeight:
            if let weightName = modifier.fontWeight {
                let weight = parseFontWeight(weightName)
                return AnyView(view.fontWeight(weight))
            }
            return view

        case .bold:
            return AnyView(view.bold())

        case .italic:
            return AnyView(view.italic())

        case .shadow:
            return AnyView(view.shadow(
                color: parseColor(modifier.shadowColor ?? "black").opacity(0.3),
                radius: modifier.shadowRadius,
                x: modifier.shadowX,
                y: modifier.shadowY
            ))

        case .disabled:
            return AnyView(view.disabled(modifier.disabledValue))

        case .hidden:
            return AnyView(view.hidden())

        case .clipShape:
            // Default to rectangle clip
            return AnyView(view.clipShape(Rectangle()))

        case .overlay:
            if let colorName = modifier.colorValue {
                return AnyView(view.overlay(parseColor(colorName)))
            }
            return view

        case .border:
            if let colorName = modifier.colorValue {
                let width: Double = modifier.getParam("width", default: 1.0)
                return AnyView(view.border(parseColor(colorName), width: width))
            }
            return view

        case .lineLimit:
            let limit: Int = modifier.getParam("limit", default: 1)
            return AnyView(view.lineLimit(limit))

        case .multilineTextAlignment:
            let alignment: String = modifier.getParam("alignment", default: "leading")
            return AnyView(view.multilineTextAlignment(parseTextAlignment(alignment)))

        default:
            // Unsupported modifier - pass through unchanged
            return view
        }
    }

    // MARK: - Selection Overlay

    @ViewBuilder
    private func selectionOverlay(for block: ViewBlock) -> some View {
        if selectedBlockId == block.id {
            RoundedRectangle(cornerRadius: 4)
                .strokeBorder(Color.accentColor, lineWidth: 2)
                .background(Color.accentColor.opacity(0.05))
        }
    }

    // MARK: - Parsing Helpers

    private func parseHorizontalAlignment(_ string: String?) -> HorizontalAlignment {
        switch string?.lowercased() {
        case "leading": return .leading
        case "trailing": return .trailing
        case "center": return .center
        default: return .center
        }
    }

    private func parseVerticalAlignment(_ string: String?) -> VerticalAlignment {
        switch string?.lowercased() {
        case "top": return .top
        case "bottom": return .bottom
        case "center": return .center
        case "firsttextbaseline": return .firstTextBaseline
        case "lasttextbaseline": return .lastTextBaseline
        default: return .center
        }
    }

    private func parseColor(_ name: String) -> Color {
        switch name.lowercased() {
        case "red": return .red
        case "orange": return .orange
        case "yellow": return .yellow
        case "green": return .green
        case "mint": return .mint
        case "teal": return .teal
        case "cyan": return .cyan
        case "blue": return .blue
        case "indigo": return .indigo
        case "purple": return .purple
        case "pink": return .pink
        case "brown": return .brown
        case "white": return .white
        case "gray", "grey": return .gray
        case "black": return .black
        case "clear": return .clear
        case "primary": return .primary
        case "secondary": return .secondary
        case "accentcolor", "accent": return .accentColor
        default:
            // Try parsing hex color
            if name.hasPrefix("#") {
                return parseHexColor(name) ?? .clear
            }
            return .primary
        }
    }

    private func parseHexColor(_ hex: String) -> Color? {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
        let g = Double((rgb & 0x00FF00) >> 8) / 255.0
        let b = Double(rgb & 0x0000FF) / 255.0

        return Color(red: r, green: g, blue: b)
    }

    private func parseFont(_ style: String, size: Double?) -> Font {
        if let size = size {
            return .system(size: size)
        }

        switch style.lowercased() {
        case "largetitle": return .largeTitle
        case "title": return .title
        case "title2": return .title2
        case "title3": return .title3
        case "headline": return .headline
        case "subheadline": return .subheadline
        case "body": return .body
        case "callout": return .callout
        case "footnote": return .footnote
        case "caption": return .caption
        case "caption2": return .caption2
        default: return .body
        }
    }

    private func parseFontWeight(_ name: String) -> Font.Weight {
        switch name.lowercased() {
        case "ultralight": return .ultraLight
        case "thin": return .thin
        case "light": return .light
        case "regular": return .regular
        case "medium": return .medium
        case "semibold": return .semibold
        case "bold": return .bold
        case "heavy": return .heavy
        case "black": return .black
        default: return .regular
        }
    }

    private func parseTextAlignment(_ name: String) -> TextAlignment {
        switch name.lowercased() {
        case "leading": return .leading
        case "center": return .center
        case "trailing": return .trailing
        default: return .leading
        }
    }
}

#Preview {
    let root = ViewBlock(id: UUID(), blockType: .vStack, sortOrder: 0)
    let text = ViewBlock(id: UUID(), blockType: .text, sortOrder: 0)
    text.textContent = "Hello, World!"
    let button = ViewBlock(id: UUID(), blockType: .button, sortOrder: 1)
    button.buttonLabel = "Tap Me"

    root.children = [text, button]
    text.parent = root
    button.parent = root

    return BlockPreviewRenderer(
        block: root,
        selectedBlockId: nil,
        onBlockTapped: { _ in }
    )
    .padding()
    .frame(width: 300, height: 400)
}
