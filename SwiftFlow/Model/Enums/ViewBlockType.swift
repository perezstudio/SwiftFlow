//
//  ViewBlockType.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import Foundation

/// All available view block types that can be used in the visual editor
enum ViewBlockType: String, Codable, CaseIterable, Identifiable, Sendable {
    var id: String { rawValue }

    // MARK: - Layout Containers
    case vStack
    case hStack
    case zStack
    case lazyVStack
    case lazyHStack
    case lazyVGrid
    case lazyHGrid
    case grid
    case scrollView
    case group
    case form
    case section

    // MARK: - Spacing & Dividers
    case spacer
    case divider

    // MARK: - Text & Labels
    case text
    case label
    case textField
    case secureField
    case textEditor

    // MARK: - Buttons & Controls
    case button
    case link
    case menu
    case toggle
    case slider
    case stepper
    case picker
    case datePicker
    case colorPicker

    // MARK: - Images & Media
    case image
    case asyncImage

    // MARK: - Shapes
    case rectangle
    case roundedRectangle
    case circle
    case ellipse
    case capsule

    // MARK: - Control Flow
    case forEach
    case ifBlock
    case switchBlock

    // MARK: - Navigation
    case navigationStack
    case navigationLink
    case navigationDestination
    case sheet
    case fullScreenCover
    case popover
    case alert
    case confirmationDialog

    // MARK: - Custom
    case customComponent  // References another ViewFile

    // MARK: - Display Properties

    var displayName: String {
        switch self {
        case .vStack: return "VStack"
        case .hStack: return "HStack"
        case .zStack: return "ZStack"
        case .lazyVStack: return "Lazy VStack"
        case .lazyHStack: return "Lazy HStack"
        case .lazyVGrid: return "Lazy VGrid"
        case .lazyHGrid: return "Lazy HGrid"
        case .grid: return "Grid"
        case .scrollView: return "Scroll View"
        case .group: return "Group"
        case .form: return "Form"
        case .section: return "Section"
        case .spacer: return "Spacer"
        case .divider: return "Divider"
        case .text: return "Text"
        case .label: return "Label"
        case .textField: return "Text Field"
        case .secureField: return "Secure Field"
        case .textEditor: return "Text Editor"
        case .button: return "Button"
        case .link: return "Link"
        case .menu: return "Menu"
        case .toggle: return "Toggle"
        case .slider: return "Slider"
        case .stepper: return "Stepper"
        case .picker: return "Picker"
        case .datePicker: return "Date Picker"
        case .colorPicker: return "Color Picker"
        case .image: return "Image"
        case .asyncImage: return "Async Image"
        case .rectangle: return "Rectangle"
        case .roundedRectangle: return "Rounded Rectangle"
        case .circle: return "Circle"
        case .ellipse: return "Ellipse"
        case .capsule: return "Capsule"
        case .forEach: return "ForEach"
        case .ifBlock: return "If"
        case .switchBlock: return "Switch"
        case .navigationStack: return "Navigation Stack"
        case .navigationLink: return "Navigation Link"
        case .navigationDestination: return "Navigation Destination"
        case .sheet: return "Sheet"
        case .fullScreenCover: return "Full Screen Cover"
        case .popover: return "Popover"
        case .alert: return "Alert"
        case .confirmationDialog: return "Confirmation Dialog"
        case .customComponent: return "Custom Component"
        }
    }

    var category: ViewBlockCategory {
        switch self {
        case .vStack, .hStack, .zStack, .lazyVStack, .lazyHStack, .lazyVGrid, .lazyHGrid, .grid, .scrollView, .group, .form, .section:
            return .layout
        case .spacer, .divider:
            return .spacing
        case .text, .label, .textField, .secureField, .textEditor:
            return .text
        case .button, .link, .menu, .toggle, .slider, .stepper, .picker, .datePicker, .colorPicker:
            return .controls
        case .image, .asyncImage:
            return .media
        case .rectangle, .roundedRectangle, .circle, .ellipse, .capsule:
            return .shapes
        case .forEach, .ifBlock, .switchBlock:
            return .controlFlow
        case .navigationStack, .navigationLink, .navigationDestination, .sheet, .fullScreenCover, .popover, .alert, .confirmationDialog:
            return .navigation
        case .customComponent:
            return .custom
        }
    }

    var canHaveChildren: Bool {
        switch self {
        case .vStack, .hStack, .zStack, .lazyVStack, .lazyHStack, .lazyVGrid, .lazyHGrid, .grid,
             .scrollView, .group, .form, .section, .button, .navigationStack, .navigationLink,
             .forEach, .ifBlock, .switchBlock, .sheet, .fullScreenCover, .popover, .menu:
            return true
        default:
            return false
        }
    }

    var iconName: String {
        switch self {
        case .vStack: return "arrow.up.and.down.square"
        case .hStack: return "arrow.left.and.right.square"
        case .zStack: return "square.stack"
        case .lazyVStack: return "arrow.up.and.down.square.fill"
        case .lazyHStack: return "arrow.left.and.right.square.fill"
        case .lazyVGrid: return "square.grid.2x2"
        case .lazyHGrid: return "square.grid.2x2"
        case .grid: return "square.grid.3x3"
        case .scrollView: return "scroll"
        case .group: return "rectangle.3.group"
        case .form: return "doc.plaintext"
        case .section: return "rectangle.split.3x1"
        case .spacer: return "arrow.up.and.down.and.arrow.left.and.right"
        case .divider: return "minus"
        case .text: return "textformat"
        case .label: return "tag"
        case .textField: return "character.cursor.ibeam"
        case .secureField: return "lock.rectangle"
        case .textEditor: return "doc.text"
        case .button: return "button.horizontal"
        case .link: return "link"
        case .menu: return "filemenu.and.selection"
        case .toggle: return "switch.2"
        case .slider: return "slider.horizontal.3"
        case .stepper: return "plusminus"
        case .picker: return "list.bullet"
        case .datePicker: return "calendar"
        case .colorPicker: return "paintpalette"
        case .image: return "photo"
        case .asyncImage: return "photo.badge.arrow.down"
        case .rectangle: return "rectangle"
        case .roundedRectangle: return "rectangle.roundedtop"
        case .circle: return "circle"
        case .ellipse: return "oval"
        case .capsule: return "capsule"
        case .forEach: return "repeat"
        case .ifBlock: return "questionmark.diamond"
        case .switchBlock: return "arrow.triangle.branch"
        case .navigationStack: return "square.stack.3d.up"
        case .navigationLink: return "arrow.right.square"
        case .navigationDestination: return "arrow.right.circle"
        case .sheet: return "rectangle.bottomhalf.inset.filled"
        case .fullScreenCover: return "rectangle.inset.filled"
        case .popover: return "text.bubble"
        case .alert: return "exclamationmark.triangle"
        case .confirmationDialog: return "questionmark.circle"
        case .customComponent: return "puzzlepiece"
        }
    }
}

enum ViewBlockCategory: String, CaseIterable, Identifiable, Sendable {
    var id: String { rawValue }

    case layout
    case spacing
    case text
    case controls
    case media
    case shapes
    case controlFlow
    case navigation
    case custom

    var displayName: String {
        switch self {
        case .layout: return "Layout"
        case .spacing: return "Spacing"
        case .text: return "Text"
        case .controls: return "Controls"
        case .media: return "Media"
        case .shapes: return "Shapes"
        case .controlFlow: return "Control Flow"
        case .navigation: return "Navigation"
        case .custom: return "Custom"
        }
    }

    var blocks: [ViewBlockType] {
        ViewBlockType.allCases.filter { $0.category == self }
    }
}
