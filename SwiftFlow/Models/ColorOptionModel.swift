//
//  ColorOptionModel.swift
//  SwiftFlow
//
//  Created by Kevin Perez on 6/28/24.
//

import Foundation
import SwiftUI

struct ColorOption: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let color: Color
}

let colorOptions: [ColorOption] = [
    ColorOption(name: "Blue", color: .blue),
    ColorOption(name: "Brown", color: .brown),
    ColorOption(name: "Purple", color: .purple),
    ColorOption(name: "Red", color: .red),
    ColorOption(name: "Yellow", color: .yellow),
    ColorOption(name: "Green", color: .green),
    ColorOption(name: "Teal", color: .teal),
    ColorOption(name: "Cyan", color: .cyan),
    ColorOption(name: "Gray", color: .gray),
    ColorOption(name: "Indigo", color: .indigo),
    ColorOption(name: "Mint", color: .mint),
    ColorOption(name: "Orange", color: .orange),
    ColorOption(name: "Pink", color: .pink)
]

func colorFromString(_ colorString: String) -> Color {
    switch colorString.lowercased() {
        case "blue":
            return Color.blue
        case "brown":
            return Color.brown
        case "purple":
            return Color.purple
        case "red":
            return Color.red
        case "yellow":
            return Color.yellow
        case "green":
            return Color.green
        case "teal":
            return Color.teal
        case "cyan":
            return Color.cyan
        case "gray":
            return Color.gray
        case "indigo":
            return Color.indigo
        case "mint":
            return Color.mint
        case "orange":
            return Color.orange
        case "pink":
            return Color.pink
        default:
            return Color.clear
    }
}
