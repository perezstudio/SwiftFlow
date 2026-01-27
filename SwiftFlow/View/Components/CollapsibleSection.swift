//
//  CollapsibleSection.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import SwiftUI

/// A collapsible section with header and expandable content
struct CollapsibleSection<Header: View, Content: View>: View {
    let header: Header
    let content: Content
    @Binding var isExpanded: Bool

    init(
        isExpanded: Binding<Bool>,
        @ViewBuilder header: () -> Header,
        @ViewBuilder content: () -> Content
    ) {
        self._isExpanded = isExpanded
        self.header = header()
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header with disclosure indicator
            Button(action: { withAnimation(.easeInOut(duration: 0.2)) { isExpanded.toggle() } }) {
                HStack(spacing: 6) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))

                    header

                    Spacer()
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .padding(.vertical, 6)
            .padding(.horizontal, 8)

            // Content
            if isExpanded {
                content
                    .padding(.leading, 16)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}

/// Convenience initializer with string title
extension CollapsibleSection where Header == Text {
    init(
        _ title: String,
        isExpanded: Binding<Bool>,
        @ViewBuilder content: () -> Content
    ) {
        self._isExpanded = isExpanded
        self.header = Text(title)
            .font(.headline)
            .foregroundStyle(.primary)
        self.content = content()
    }
}

/// A collapsible section with local state (for when binding isn't needed externally)
struct CollapsibleSectionLocal<Header: View, Content: View>: View {
    let header: Header
    let content: Content
    @State private var isExpanded: Bool

    init(
        initiallyExpanded: Bool = true,
        @ViewBuilder header: () -> Header,
        @ViewBuilder content: () -> Content
    ) {
        self._isExpanded = State(initialValue: initiallyExpanded)
        self.header = header()
        self.content = content()
    }

    var body: some View {
        CollapsibleSection(
            isExpanded: $isExpanded,
            header: { header },
            content: { content }
        )
    }
}

extension CollapsibleSectionLocal where Header == Text {
    init(
        _ title: String,
        initiallyExpanded: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self._isExpanded = State(initialValue: initiallyExpanded)
        self.header = Text(title)
            .font(.headline)
            .foregroundStyle(.primary)
        self.content = content()
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 16) {
        CollapsibleSectionLocal("Properties", initiallyExpanded: true) {
            VStack(alignment: .leading, spacing: 4) {
                Text("@State count: Int")
                Text("@Binding isPresented: Bool")
            }
            .font(.system(.body, design: .monospaced))
        }

        CollapsibleSectionLocal("Functions", initiallyExpanded: false) {
            VStack(alignment: .leading, spacing: 4) {
                Text("func increment()")
                Text("func reset()")
            }
            .font(.system(.body, design: .monospaced))
        }
    }
    .padding()
    .frame(width: 300)
}
