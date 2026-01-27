//
//  SplitViewContainer.swift
//  SwiftFlow
//
//  Created by Keviruchis on 1/26/26.
//

import AppKit
import SwiftUI

/// An AppKit-based three-panel split view that avoids the standard SwiftUI NavigationSplitView styling.
/// Panels: Sidebar | Content | Detail
struct SplitViewContainer<Sidebar: View, Content: View, Detail: View>: NSViewRepresentable {
    let sidebar: Sidebar
    let content: Content
    let detail: Detail

    var sidebarMinWidth: CGFloat = 200
    var sidebarMaxWidth: CGFloat = 300
    var contentMinWidth: CGFloat = 300
    var detailMinWidth: CGFloat = 300

    init(
        @ViewBuilder sidebar: () -> Sidebar,
        @ViewBuilder content: () -> Content,
        @ViewBuilder detail: () -> Detail
    ) {
        self.sidebar = sidebar()
        self.content = content()
        self.detail = detail()
    }

    func makeNSView(context: Context) -> NSSplitView {
        let splitView = NSSplitView()
        splitView.isVertical = true
        splitView.dividerStyle = .thin
        splitView.delegate = context.coordinator

        // Create hosting views for each SwiftUI view
        let sidebarHostingView = NSHostingView(rootView: sidebar)
        let contentHostingView = NSHostingView(rootView: content)
        let detailHostingView = NSHostingView(rootView: detail)

        // Set initial widths using constraints
        sidebarHostingView.translatesAutoresizingMaskIntoConstraints = false
        contentHostingView.translatesAutoresizingMaskIntoConstraints = false
        detailHostingView.translatesAutoresizingMaskIntoConstraints = false

        // Add subviews
        splitView.addArrangedSubview(sidebarHostingView)
        splitView.addArrangedSubview(contentHostingView)
        splitView.addArrangedSubview(detailHostingView)

        // Set holding priorities (lower = more likely to resize)
        splitView.setHoldingPriority(.defaultLow, forSubviewAt: 0)
        splitView.setHoldingPriority(.defaultHigh, forSubviewAt: 1)
        splitView.setHoldingPriority(.defaultLow, forSubviewAt: 2)

        // Set initial divider positions after layout
        DispatchQueue.main.async {
            let totalWidth = splitView.bounds.width
            splitView.setPosition(self.sidebarMinWidth, ofDividerAt: 0)
            // Position second divider so detail panel gets its minimum width
            splitView.setPosition(totalWidth - self.detailMinWidth, ofDividerAt: 1)
        }

        return splitView
    }

    func updateNSView(_ splitView: NSSplitView, context: Context) {
        // Update the SwiftUI views when state changes
        guard splitView.arrangedSubviews.count == 3 else { return }

        if let sidebarHosting = splitView.arrangedSubviews[0] as? NSHostingView<Sidebar> {
            sidebarHosting.rootView = sidebar
        }
        if let contentHosting = splitView.arrangedSubviews[1] as? NSHostingView<Content> {
            contentHosting.rootView = content
        }
        if let detailHosting = splitView.arrangedSubviews[2] as? NSHostingView<Detail> {
            detailHosting.rootView = detail
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(
            sidebarMinWidth: sidebarMinWidth,
            sidebarMaxWidth: sidebarMaxWidth,
            contentMinWidth: contentMinWidth,
            detailMinWidth: detailMinWidth
        )
    }

    class Coordinator: NSObject, NSSplitViewDelegate {
        let sidebarMinWidth: CGFloat
        let sidebarMaxWidth: CGFloat
        let contentMinWidth: CGFloat
        let detailMinWidth: CGFloat

        init(
            sidebarMinWidth: CGFloat,
            sidebarMaxWidth: CGFloat,
            contentMinWidth: CGFloat,
            detailMinWidth: CGFloat
        ) {
            self.sidebarMinWidth = sidebarMinWidth
            self.sidebarMaxWidth = sidebarMaxWidth
            self.contentMinWidth = contentMinWidth
            self.detailMinWidth = detailMinWidth
        }

        func splitView(
            _ splitView: NSSplitView,
            constrainMinCoordinate proposedMinimumPosition: CGFloat,
            ofSubviewAt dividerIndex: Int
        ) -> CGFloat {
            switch dividerIndex {
            case 0:
                return sidebarMinWidth
            case 1:
                return sidebarMinWidth + contentMinWidth
            default:
                return proposedMinimumPosition
            }
        }

        func splitView(
            _ splitView: NSSplitView,
            constrainMaxCoordinate proposedMaximumPosition: CGFloat,
            ofSubviewAt dividerIndex: Int
        ) -> CGFloat {
            let totalWidth = splitView.bounds.width
            switch dividerIndex {
            case 0:
                return sidebarMaxWidth
            case 1:
                return totalWidth - detailMinWidth
            default:
                return proposedMaximumPosition
            }
        }

        func splitView(
            _ splitView: NSSplitView,
            canCollapseSubview subview: NSView
        ) -> Bool {
            // Allow sidebar and detail to collapse
            guard let index = splitView.arrangedSubviews.firstIndex(of: subview) else {
                return false
            }
            return index == 0 || index == 2
        }
    }
}

// MARK: - Convenience modifiers

extension SplitViewContainer {
    func sidebarWidth(min: CGFloat, max: CGFloat) -> SplitViewContainer {
        var copy = self
        copy.sidebarMinWidth = min
        copy.sidebarMaxWidth = max
        return copy
    }

    func contentMinWidth(_ width: CGFloat) -> SplitViewContainer {
        var copy = self
        copy.contentMinWidth = width
        return copy
    }

    func detailMinWidth(_ width: CGFloat) -> SplitViewContainer {
        var copy = self
        copy.detailMinWidth = width
        return copy
    }
}
