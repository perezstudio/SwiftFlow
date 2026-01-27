//
//  AddModifierMenu.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import SwiftUI
import SwiftData

/// Menu for adding new modifiers to a block
struct AddModifierMenu: View {
    @Bindable var block: ViewBlock
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        Menu {
            ForEach(ModifierCategory.allCases) { category in
                if !category.modifiers.isEmpty {
                    Menu(category.displayName) {
                        ForEach(category.modifiers, id: \.self) { modifierType in
                            Button(action: { addModifier(modifierType) }) {
                                Label(modifierType.displayName, systemImage: modifierType.iconName)
                            }
                        }
                    }
                }
            }
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 10))
                .foregroundStyle(.secondary)
        }
        .menuStyle(.borderlessButton)
        .menuIndicator(.hidden)
    }

    // MARK: - Add Modifier

    private func addModifier(_ type: ModifierType) {
        let sortOrder = (block.modifiers?.count ?? 0)
        let modifier = ViewModifier(modifierType: type, sortOrder: sortOrder)
        modifier.block = block

        var modifiers = block.modifiers ?? []
        modifiers.append(modifier)
        block.modifiers = modifiers

        try? modelContext.save()
    }
}

// MARK: - ModifierType Extension for Icons

extension ModifierType {
    var iconName: String {
        switch self {
        case .frame: return "rectangle.dashed"
        case .padding: return "arrow.up.left.and.arrow.down.right"
        case .offset: return "arrow.up.and.down.and.arrow.left.and.right"
        case .position: return "scope"
        case .foregroundStyle, .foregroundColor: return "paintpalette"
        case .background: return "rectangle.fill"
        case .overlay: return "square.stack"
        case .border: return "square"
        case .cornerRadius: return "rectangle.roundedtop"
        case .clipShape: return "scissors"
        case .font: return "textformat.size"
        case .fontWeight: return "bold"
        case .opacity: return "circle.lefthalf.filled"
        case .shadow: return "shadow"
        case .blur: return "aqi.medium"
        case .onTapGesture: return "hand.tap"
        case .disabled: return "xmark.circle"
        case .accessibilityLabel: return "accessibility"
        case .hidden: return "eye.slash"
        case .navigationTitle: return "text.badge.star"
        case .listRowBackground: return "list.bullet.rectangle"
        case .animation: return "wand.and.stars"
        default: return "slider.horizontal.3"
        }
    }
}

// MARK: - ModifierCategory Color Extension

extension ModifierCategory {
    var color: Color {
        switch self {
        case .layout: return .blue
        case .appearance: return .purple
        case .typography: return .orange
        case .interaction: return .green
        case .animation: return .pink
        case .environment: return .cyan
        case .accessibility: return .teal
        case .listNavigation: return .indigo
        case .presentation: return .mint
        case .safeArea: return .brown
        case .other: return .gray
        }
    }
}

#Preview {
    AddModifierMenu(block: ViewBlock(blockType: .text))
        .frame(width: 200, height: 40)
}
