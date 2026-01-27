//
//  CustomList.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import SwiftUI

/// A custom list using ScrollView + LazyVStack instead of List
/// Provides more control over styling and avoids system List behavior
struct CustomList<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable {
    let data: Data
    let spacing: CGFloat
    let content: (Data.Element) -> Content

    init(
        _ data: Data,
        spacing: CGFloat = 0,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.spacing = spacing
        self.content = content
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: spacing) {
                ForEach(data) { item in
                    content(item)
                }
            }
        }
    }
}

/// A custom list with section support
struct CustomSectionedList<SectionData: RandomAccessCollection, ItemData: RandomAccessCollection, SectionContent: View, ItemContent: View>: View
    where SectionData.Element: Identifiable, ItemData.Element: Identifiable {

    let sections: SectionData
    let items: (SectionData.Element) -> ItemData
    let sectionHeader: (SectionData.Element) -> SectionContent
    let itemContent: (ItemData.Element) -> ItemContent

    init(
        sections: SectionData,
        items: @escaping (SectionData.Element) -> ItemData,
        @ViewBuilder sectionHeader: @escaping (SectionData.Element) -> SectionContent,
        @ViewBuilder itemContent: @escaping (ItemData.Element) -> ItemContent
    ) {
        self.sections = sections
        self.items = items
        self.sectionHeader = sectionHeader
        self.itemContent = itemContent
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(sections) { section in
                    VStack(spacing: 0) {
                        sectionHeader(section)

                        ForEach(items(section)) { item in
                            itemContent(item)
                        }
                    }
                }
            }
        }
    }
}

/// A simple selectable list
struct SelectableList<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable, Data.Element.ID == UUID {
    let data: Data
    @Binding var selection: UUID?
    let content: (Data.Element, Bool) -> Content

    init(
        _ data: Data,
        selection: Binding<UUID?>,
        @ViewBuilder content: @escaping (Data.Element, Bool) -> Content
    ) {
        self.data = data
        self._selection = selection
        self.content = content
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(data) { item in
                    let isSelected = selection == item.id
                    content(item, isSelected)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selection = item.id
                        }
                }
            }
        }
    }
}

/// A multi-selectable list
struct MultiSelectableList<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable, Data.Element.ID == UUID {
    let data: Data
    @Binding var selection: Set<UUID>
    let content: (Data.Element, Bool) -> Content

    init(
        _ data: Data,
        selection: Binding<Set<UUID>>,
        @ViewBuilder content: @escaping (Data.Element, Bool) -> Content
    ) {
        self.data = data
        self._selection = selection
        self.content = content
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(data) { item in
                    let isSelected = selection.contains(item.id)
                    content(item, isSelected)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if isSelected {
                                selection.remove(item.id)
                            } else {
                                selection.insert(item.id)
                            }
                        }
                }
            }
        }
    }
}

// MARK: - Preview Helpers

private struct PreviewItem: Identifiable {
    let id = UUID()
    let name: String
}

#Preview {
    let items = [
        PreviewItem(name: "ContentView"),
        PreviewItem(name: "DetailView"),
        PreviewItem(name: "SettingsView")
    ]

    return VStack {
        CustomList(items, spacing: 1) { item in
            HStack {
                Image(systemName: "doc")
                Text(item.name)
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(nsColor: .controlBackgroundColor))
        }
    }
    .frame(width: 200, height: 200)
}
