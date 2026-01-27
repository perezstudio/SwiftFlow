//
//  ModifierType.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import Foundation

/// All available SwiftUI modifier types
enum ModifierType: String, Codable, CaseIterable, Identifiable, Sendable {
    var id: String { rawValue }

    // MARK: - Layout
    case frame
    case fixedSize
    case padding
    case offset
    case position
    case aspectRatio
    case scaledToFit
    case scaledToFill
    case layoutPriority
    case alignmentGuide

    // MARK: - Sizing
    case containerRelativeFrame

    // MARK: - Appearance
    case foregroundStyle
    case foregroundColor
    case tint
    case background
    case overlay
    case opacity
    case hidden
    case clipShape
    case cornerRadius
    case mask
    case blur
    case shadow
    case border
    case brightness
    case contrast
    case saturation
    case grayscale

    // MARK: - Typography
    case font
    case fontWeight
    case fontDesign
    case fontWidth
    case bold
    case italic
    case underline
    case strikethrough
    case monospaced
    case monospacedDigit
    case kerning
    case tracking
    case baselineOffset
    case lineLimit
    case lineSpacing
    case multilineTextAlignment
    case truncationMode
    case minimumScaleFactor
    case textCase
    case textSelection

    // MARK: - Interaction
    case disabled
    case allowsHitTesting
    case contentShape
    case onTapGesture
    case onLongPressGesture
    case simultaneousGesture
    case highPriorityGesture
    case focusable
    case focused
    case submitLabel
    case onSubmit

    // MARK: - Animation
    case animation
    case transition
    case matchedGeometryEffect

    // MARK: - Environment
    case environment
    case environmentObject
    case transformEnvironment

    // MARK: - Accessibility
    case accessibilityLabel
    case accessibilityHint
    case accessibilityValue
    case accessibilityHidden
    case accessibilityIdentifier
    case accessibilityAddTraits
    case accessibilityRemoveTraits

    // MARK: - List & Navigation
    case listRowBackground
    case listRowSeparator
    case listRowInsets
    case listItemTint
    case swipeActions
    case navigationTitle
    case navigationBarTitleDisplayMode
    case toolbar
    case toolbarBackground
    case toolbarColorScheme
    case searchable
    case refreshable

    // MARK: - Sheet & Presentation
    case presentationDetents
    case presentationDragIndicator
    case interactiveDismissDisabled
    case presentationBackground
    case presentationCornerRadius
    case presentationContentInteraction

    // MARK: - Safe Area
    case ignoresSafeArea
    case safeAreaInset
    case safeAreaPadding

    // MARK: - Other
    case id
    case tag
    case zIndex
    case drawingGroup
    case compositingGroup
    case allowsTightening
    case flipsForRightToLeftLayoutDirection
    case labelsHidden
    case buttonStyle
    case toggleStyle
    case pickerStyle
    case textFieldStyle
    case listStyle
    case menuStyle
    case progressViewStyle
    case scrollIndicators
    case scrollDisabled
    case scrollContentBackground
    case scrollClipDisabled
    case defaultScrollAnchor
    case scrollTargetBehavior
    case contentMargins
    case containerBackground
    case help

    // MARK: - Display Properties

    var displayName: String {
        switch self {
        case .frame: return "Frame"
        case .fixedSize: return "Fixed Size"
        case .padding: return "Padding"
        case .offset: return "Offset"
        case .position: return "Position"
        case .aspectRatio: return "Aspect Ratio"
        case .scaledToFit: return "Scaled to Fit"
        case .scaledToFill: return "Scaled to Fill"
        case .layoutPriority: return "Layout Priority"
        case .alignmentGuide: return "Alignment Guide"
        case .containerRelativeFrame: return "Container Relative Frame"
        case .foregroundStyle: return "Foreground Style"
        case .foregroundColor: return "Foreground Color"
        case .tint: return "Tint"
        case .background: return "Background"
        case .overlay: return "Overlay"
        case .opacity: return "Opacity"
        case .hidden: return "Hidden"
        case .clipShape: return "Clip Shape"
        case .cornerRadius: return "Corner Radius"
        case .mask: return "Mask"
        case .blur: return "Blur"
        case .shadow: return "Shadow"
        case .border: return "Border"
        case .brightness: return "Brightness"
        case .contrast: return "Contrast"
        case .saturation: return "Saturation"
        case .grayscale: return "Grayscale"
        case .font: return "Font"
        case .fontWeight: return "Font Weight"
        case .fontDesign: return "Font Design"
        case .fontWidth: return "Font Width"
        case .bold: return "Bold"
        case .italic: return "Italic"
        case .underline: return "Underline"
        case .strikethrough: return "Strikethrough"
        case .monospaced: return "Monospaced"
        case .monospacedDigit: return "Monospaced Digit"
        case .kerning: return "Kerning"
        case .tracking: return "Tracking"
        case .baselineOffset: return "Baseline Offset"
        case .lineLimit: return "Line Limit"
        case .lineSpacing: return "Line Spacing"
        case .multilineTextAlignment: return "Multiline Text Alignment"
        case .truncationMode: return "Truncation Mode"
        case .minimumScaleFactor: return "Minimum Scale Factor"
        case .textCase: return "Text Case"
        case .textSelection: return "Text Selection"
        case .disabled: return "Disabled"
        case .allowsHitTesting: return "Allows Hit Testing"
        case .contentShape: return "Content Shape"
        case .onTapGesture: return "On Tap Gesture"
        case .onLongPressGesture: return "On Long Press Gesture"
        case .simultaneousGesture: return "Simultaneous Gesture"
        case .highPriorityGesture: return "High Priority Gesture"
        case .focusable: return "Focusable"
        case .focused: return "Focused"
        case .submitLabel: return "Submit Label"
        case .onSubmit: return "On Submit"
        case .animation: return "Animation"
        case .transition: return "Transition"
        case .matchedGeometryEffect: return "Matched Geometry Effect"
        case .environment: return "Environment"
        case .environmentObject: return "Environment Object"
        case .transformEnvironment: return "Transform Environment"
        case .accessibilityLabel: return "Accessibility Label"
        case .accessibilityHint: return "Accessibility Hint"
        case .accessibilityValue: return "Accessibility Value"
        case .accessibilityHidden: return "Accessibility Hidden"
        case .accessibilityIdentifier: return "Accessibility Identifier"
        case .accessibilityAddTraits: return "Accessibility Add Traits"
        case .accessibilityRemoveTraits: return "Accessibility Remove Traits"
        case .listRowBackground: return "List Row Background"
        case .listRowSeparator: return "List Row Separator"
        case .listRowInsets: return "List Row Insets"
        case .listItemTint: return "List Item Tint"
        case .swipeActions: return "Swipe Actions"
        case .navigationTitle: return "Navigation Title"
        case .navigationBarTitleDisplayMode: return "Navigation Bar Title Display Mode"
        case .toolbar: return "Toolbar"
        case .toolbarBackground: return "Toolbar Background"
        case .toolbarColorScheme: return "Toolbar Color Scheme"
        case .searchable: return "Searchable"
        case .refreshable: return "Refreshable"
        case .presentationDetents: return "Presentation Detents"
        case .presentationDragIndicator: return "Presentation Drag Indicator"
        case .interactiveDismissDisabled: return "Interactive Dismiss Disabled"
        case .presentationBackground: return "Presentation Background"
        case .presentationCornerRadius: return "Presentation Corner Radius"
        case .presentationContentInteraction: return "Presentation Content Interaction"
        case .ignoresSafeArea: return "Ignores Safe Area"
        case .safeAreaInset: return "Safe Area Inset"
        case .safeAreaPadding: return "Safe Area Padding"
        case .id: return "ID"
        case .tag: return "Tag"
        case .zIndex: return "Z Index"
        case .drawingGroup: return "Drawing Group"
        case .compositingGroup: return "Compositing Group"
        case .allowsTightening: return "Allows Tightening"
        case .flipsForRightToLeftLayoutDirection: return "Flips for RTL"
        case .labelsHidden: return "Labels Hidden"
        case .buttonStyle: return "Button Style"
        case .toggleStyle: return "Toggle Style"
        case .pickerStyle: return "Picker Style"
        case .textFieldStyle: return "Text Field Style"
        case .listStyle: return "List Style"
        case .menuStyle: return "Menu Style"
        case .progressViewStyle: return "Progress View Style"
        case .scrollIndicators: return "Scroll Indicators"
        case .scrollDisabled: return "Scroll Disabled"
        case .scrollContentBackground: return "Scroll Content Background"
        case .scrollClipDisabled: return "Scroll Clip Disabled"
        case .defaultScrollAnchor: return "Default Scroll Anchor"
        case .scrollTargetBehavior: return "Scroll Target Behavior"
        case .contentMargins: return "Content Margins"
        case .containerBackground: return "Container Background"
        case .help: return "Help"
        }
    }

    var category: ModifierCategory {
        switch self {
        case .frame, .fixedSize, .padding, .offset, .position, .aspectRatio, .scaledToFit, .scaledToFill, .layoutPriority, .alignmentGuide, .containerRelativeFrame:
            return .layout
        case .foregroundStyle, .foregroundColor, .tint, .background, .overlay, .opacity, .hidden, .clipShape, .cornerRadius, .mask, .blur, .shadow, .border, .brightness, .contrast, .saturation, .grayscale:
            return .appearance
        case .font, .fontWeight, .fontDesign, .fontWidth, .bold, .italic, .underline, .strikethrough, .monospaced, .monospacedDigit, .kerning, .tracking, .baselineOffset, .lineLimit, .lineSpacing, .multilineTextAlignment, .truncationMode, .minimumScaleFactor, .textCase, .textSelection, .allowsTightening:
            return .typography
        case .disabled, .allowsHitTesting, .contentShape, .onTapGesture, .onLongPressGesture, .simultaneousGesture, .highPriorityGesture, .focusable, .focused, .submitLabel, .onSubmit:
            return .interaction
        case .animation, .transition, .matchedGeometryEffect:
            return .animation
        case .environment, .environmentObject, .transformEnvironment:
            return .environment
        case .accessibilityLabel, .accessibilityHint, .accessibilityValue, .accessibilityHidden, .accessibilityIdentifier, .accessibilityAddTraits, .accessibilityRemoveTraits:
            return .accessibility
        case .listRowBackground, .listRowSeparator, .listRowInsets, .listItemTint, .swipeActions, .navigationTitle, .navigationBarTitleDisplayMode, .toolbar, .toolbarBackground, .toolbarColorScheme, .searchable, .refreshable:
            return .listNavigation
        case .presentationDetents, .presentationDragIndicator, .interactiveDismissDisabled, .presentationBackground, .presentationCornerRadius, .presentationContentInteraction:
            return .presentation
        case .ignoresSafeArea, .safeAreaInset, .safeAreaPadding:
            return .safeArea
        default:
            return .other
        }
    }
}

enum ModifierCategory: String, CaseIterable, Identifiable, Sendable {
    var id: String { rawValue }

    case layout
    case appearance
    case typography
    case interaction
    case animation
    case environment
    case accessibility
    case listNavigation
    case presentation
    case safeArea
    case other

    var displayName: String {
        switch self {
        case .layout: return "Layout"
        case .appearance: return "Appearance"
        case .typography: return "Typography"
        case .interaction: return "Interaction"
        case .animation: return "Animation"
        case .environment: return "Environment"
        case .accessibility: return "Accessibility"
        case .listNavigation: return "List & Navigation"
        case .presentation: return "Presentation"
        case .safeArea: return "Safe Area"
        case .other: return "Other"
        }
    }

    var modifiers: [ModifierType] {
        ModifierType.allCases.filter { $0.category == self }
    }
}
