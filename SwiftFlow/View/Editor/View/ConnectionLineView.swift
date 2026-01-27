//
//  ConnectionLineView.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import SwiftUI

/// Visual connection lines between parent and child blocks
struct ConnectionLineView: View {
    let type: ConnectionType

    enum ConnectionType {
        case vertical
        case horizontal
        case corner       // L-shaped corner
        case branch       // T-shaped branch point
    }

    var body: some View {
        GeometryReader { geometry in
            Path { path in
                switch type {
                case .vertical:
                    path.move(to: CGPoint(x: geometry.size.width / 2, y: 0))
                    path.addLine(to: CGPoint(x: geometry.size.width / 2, y: geometry.size.height))

                case .horizontal:
                    path.move(to: CGPoint(x: 0, y: geometry.size.height / 2))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height / 2))

                case .corner:
                    // L-shaped: down then right
                    path.move(to: CGPoint(x: geometry.size.width / 2, y: 0))
                    path.addLine(to: CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height / 2))

                case .branch:
                    // T-shaped: vertical with horizontal branch
                    path.move(to: CGPoint(x: geometry.size.width / 2, y: 0))
                    path.addLine(to: CGPoint(x: geometry.size.width / 2, y: geometry.size.height))
                    path.move(to: CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height / 2))
                }
            }
            .stroke(Color(nsColor: .separatorColor), style: StrokeStyle(lineWidth: 2, lineCap: .round))
        }
    }
}

// MARK: - Curved Connection Line

/// Alternative curved connection line style
struct CurvedConnectionLineView: View {
    let startPoint: CGPoint
    let endPoint: CGPoint

    var body: some View {
        Path { path in
            path.move(to: startPoint)

            // Calculate control points for bezier curve
            let midY = (startPoint.y + endPoint.y) / 2

            path.addCurve(
                to: endPoint,
                control1: CGPoint(x: startPoint.x, y: midY),
                control2: CGPoint(x: endPoint.x, y: midY)
            )
        }
        .stroke(Color(nsColor: .separatorColor), style: StrokeStyle(lineWidth: 2, lineCap: .round))
    }
}

// MARK: - Dashed Connection Line

/// Dashed connection line for potential drop targets
struct DashedConnectionLineView: View {
    let type: ConnectionLineView.ConnectionType

    var body: some View {
        GeometryReader { geometry in
            Path { path in
                switch type {
                case .vertical:
                    path.move(to: CGPoint(x: geometry.size.width / 2, y: 0))
                    path.addLine(to: CGPoint(x: geometry.size.width / 2, y: geometry.size.height))

                case .horizontal:
                    path.move(to: CGPoint(x: 0, y: geometry.size.height / 2))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height / 2))

                case .corner:
                    path.move(to: CGPoint(x: geometry.size.width / 2, y: 0))
                    path.addLine(to: CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height / 2))

                case .branch:
                    path.move(to: CGPoint(x: geometry.size.width / 2, y: 0))
                    path.addLine(to: CGPoint(x: geometry.size.width / 2, y: geometry.size.height))
                    path.move(to: CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height / 2))
                }
            }
            .stroke(
                Color.accentColor.opacity(0.5),
                style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [6, 4])
            )
        }
    }
}

// MARK: - Animated Connection Line

/// Animated connection line for active drag operations
struct AnimatedConnectionLineView: View {
    let type: ConnectionLineView.ConnectionType

    @State private var dashPhase: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            Path { path in
                switch type {
                case .vertical:
                    path.move(to: CGPoint(x: geometry.size.width / 2, y: 0))
                    path.addLine(to: CGPoint(x: geometry.size.width / 2, y: geometry.size.height))

                case .horizontal:
                    path.move(to: CGPoint(x: 0, y: geometry.size.height / 2))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height / 2))

                case .corner:
                    path.move(to: CGPoint(x: geometry.size.width / 2, y: 0))
                    path.addLine(to: CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height / 2))

                case .branch:
                    path.move(to: CGPoint(x: geometry.size.width / 2, y: 0))
                    path.addLine(to: CGPoint(x: geometry.size.width / 2, y: geometry.size.height))
                    path.move(to: CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height / 2))
                }
            }
            .stroke(
                Color.accentColor,
                style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [6, 4], dashPhase: dashPhase)
            )
        }
        .onAppear {
            withAnimation(.linear(duration: 0.5).repeatForever(autoreverses: false)) {
                dashPhase = 10
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        HStack(spacing: 20) {
            VStack {
                Text("Vertical")
                    .font(.caption)
                ConnectionLineView(type: .vertical)
                    .frame(width: 20, height: 60)
            }

            VStack {
                Text("Horizontal")
                    .font(.caption)
                ConnectionLineView(type: .horizontal)
                    .frame(width: 60, height: 20)
            }

            VStack {
                Text("Corner")
                    .font(.caption)
                ConnectionLineView(type: .corner)
                    .frame(width: 40, height: 40)
            }

            VStack {
                Text("Branch")
                    .font(.caption)
                ConnectionLineView(type: .branch)
                    .frame(width: 40, height: 60)
            }
        }

        Divider()

        HStack(spacing: 20) {
            VStack {
                Text("Dashed")
                    .font(.caption)
                DashedConnectionLineView(type: .vertical)
                    .frame(width: 20, height: 60)
            }

            VStack {
                Text("Animated")
                    .font(.caption)
                AnimatedConnectionLineView(type: .vertical)
                    .frame(width: 20, height: 60)
            }
        }
    }
    .padding()
}
