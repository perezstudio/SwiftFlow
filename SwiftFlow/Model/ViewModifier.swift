//
//  ViewModifier.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import Foundation
import SwiftData

/// Represents a SwiftUI modifier applied to a view block
@Model
final class ViewModifier {
    @Attribute(.unique) var id: UUID
    var modifierType: ModifierType
    var sortOrder: Int

    // Modifier-specific parameters stored as JSON
    var parametersData: Data?

    // Relationship to parent block
    var block: ViewBlock?

    init(
        id: UUID = UUID(),
        modifierType: ModifierType,
        sortOrder: Int = 0
    ) {
        self.id = id
        self.modifierType = modifierType
        self.sortOrder = sortOrder
    }

    // MARK: - Parameters

    var parameters: [String: Any] {
        get {
            guard let data = parametersData,
                  let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                return [:]
            }
            return dict
        }
        set {
            parametersData = try? JSONSerialization.data(withJSONObject: newValue)
        }
    }

    func setParam(_ key: String, value: Any) {
        var params = parameters
        params[key] = value
        parameters = params
    }

    func getParam<T>(_ key: String, default defaultValue: T) -> T {
        (parameters[key] as? T) ?? defaultValue
    }

    func getParam<T>(_ key: String) -> T? {
        parameters[key] as? T
    }

    // MARK: - Common Parameter Accessors

    // Frame modifier
    var frameWidth: Double? {
        get { getParam("width") }
        set { if let v = newValue { setParam("width", value: v) } }
    }

    var frameHeight: Double? {
        get { getParam("height") }
        set { if let v = newValue { setParam("height", value: v) } }
    }

    var frameMinWidth: Double? {
        get { getParam("minWidth") }
        set { if let v = newValue { setParam("minWidth", value: v) } }
    }

    var frameMaxWidth: Double? {
        get { getParam("maxWidth") }
        set { if let v = newValue { setParam("maxWidth", value: v) } }
    }

    var frameMinHeight: Double? {
        get { getParam("minHeight") }
        set { if let v = newValue { setParam("minHeight", value: v) } }
    }

    var frameMaxHeight: Double? {
        get { getParam("maxHeight") }
        set { if let v = newValue { setParam("maxHeight", value: v) } }
    }

    var frameAlignment: String? {
        get { getParam("alignment") }
        set { setParam("alignment", value: newValue ?? "") }
    }

    // Padding modifier
    var paddingEdges: String {
        get { getParam("edges", default: "all") }
        set { setParam("edges", value: newValue) }
    }

    var paddingLength: Double? {
        get { getParam("length") }
        set { if let v = newValue { setParam("length", value: v) } }
    }

    // Background/Foreground color
    var colorValue: String? {
        get { getParam("color") }
        set { setParam("color", value: newValue ?? "") }
    }

    // Opacity
    var opacityValue: Double {
        get { getParam("opacity", default: 1.0) }
        set { setParam("opacity", value: newValue) }
    }

    // Corner radius
    var cornerRadiusValue: Double {
        get { getParam("radius", default: 0.0) }
        set { setParam("radius", value: newValue) }
    }

    // Font
    var fontStyle: String? {
        get { getParam("fontStyle") }
        set { setParam("fontStyle", value: newValue ?? "") }
    }

    var fontSize: Double? {
        get { getParam("fontSize") }
        set { if let v = newValue { setParam("fontSize", value: v) } }
    }

    var fontWeight: String? {
        get { getParam("fontWeight") }
        set { setParam("fontWeight", value: newValue ?? "") }
    }

    // Shadow
    var shadowColor: String? {
        get { getParam("shadowColor") }
        set { setParam("shadowColor", value: newValue ?? "") }
    }

    var shadowRadius: Double {
        get { getParam("shadowRadius", default: 0.0) }
        set { setParam("shadowRadius", value: newValue) }
    }

    var shadowX: Double {
        get { getParam("shadowX", default: 0.0) }
        set { setParam("shadowX", value: newValue) }
    }

    var shadowY: Double {
        get { getParam("shadowY", default: 0.0) }
        set { setParam("shadowY", value: newValue) }
    }

    // Navigation title
    var navigationTitleValue: String? {
        get { getParam("title") }
        set { setParam("title", value: newValue ?? "") }
    }

    // Disabled
    var disabledValue: Bool {
        get { getParam("disabled", default: false) }
        set { setParam("disabled", value: newValue) }
    }

    // MARK: - Display

    var displayName: String {
        modifierType.displayName
    }

    var summary: String {
        switch modifierType {
        case .frame:
            var parts: [String] = []
            if let w = frameWidth { parts.append("w: \(Int(w))") }
            if let h = frameHeight { parts.append("h: \(Int(h))") }
            return parts.isEmpty ? "Frame" : "Frame(\(parts.joined(separator: ", ")))"

        case .padding:
            if let length = paddingLength {
                return "Padding(\(Int(length)))"
            }
            return "Padding"

        case .foregroundColor, .foregroundStyle:
            if let color = colorValue {
                return "Foreground(\(color))"
            }
            return "Foreground"

        case .background:
            if let color = colorValue {
                return "Background(\(color))"
            }
            return "Background"

        case .opacity:
            return "Opacity(\(String(format: "%.1f", opacityValue)))"

        case .cornerRadius:
            return "Corner Radius(\(Int(cornerRadiusValue)))"

        case .font:
            if let style = fontStyle {
                return "Font(.\(style))"
            }
            if let size = fontSize {
                return "Font(size: \(Int(size)))"
            }
            return "Font"

        case .navigationTitle:
            if let title = navigationTitleValue {
                return "Nav Title(\"\(title)\")"
            }
            return "Navigation Title"

        default:
            return modifierType.displayName
        }
    }
}
