//
//  DeviceFrameView.swift
//  SwiftFlow
//
//  Created on 1/27/26.
//

import SwiftUI

/// Renders a device frame (bezel, notch, etc.) around content
struct DeviceFrameView<Content: View>: View {
    let device: DeviceType
    @ViewBuilder let content: () -> Content

    var body: some View {
        switch device.category {
        case .iPhone:
            iPhoneFrame
        case .iPad:
            iPadFrame
        case .mac:
            macFrame
        }
    }

    // MARK: - iPhone Frame

    private var iPhoneFrame: some View {
        ZStack {
            // Device body
            RoundedRectangle(cornerRadius: device.cornerRadius + device.bezelWidth)
                .fill(device.frameColor)
                .frame(
                    width: device.screenSize.width + device.bezelWidth * 2,
                    height: device.screenSize.height + device.bezelWidth * 2
                )

            // Screen
            ZStack(alignment: .top) {
                // Screen background
                RoundedRectangle(cornerRadius: device.cornerRadius)
                    .fill(Color(nsColor: .windowBackgroundColor))

                // Content
                content()
                    .frame(width: device.screenSize.width, height: device.screenSize.height)
                    .clipShape(RoundedRectangle(cornerRadius: device.cornerRadius))

                // Status bar overlay
                VStack(spacing: 0) {
                    if device.hasDynamicIsland {
                        dynamicIsland
                    }
                    Spacer()
                    if device.hasHomeIndicator {
                        homeIndicator
                    }
                }
                .frame(width: device.screenSize.width, height: device.screenSize.height)
            }
            .frame(width: device.screenSize.width, height: device.screenSize.height)
            .clipShape(RoundedRectangle(cornerRadius: device.cornerRadius))

            // Side buttons (volume, power)
            iPhoneSideButtons
        }
        .shadow(color: .black.opacity(0.3), radius: 20, y: 10)
    }

    private var dynamicIsland: some View {
        Capsule()
            .fill(Color.black)
            .frame(width: 126, height: 37)
            .padding(.top, 11)
    }

    private var homeIndicator: some View {
        Capsule()
            .fill(Color(white: 0.3))
            .frame(width: 134, height: 5)
            .padding(.bottom, 8)
    }

    private var iPhoneSideButtons: some View {
        ZStack {
            // Power button (right side)
            RoundedRectangle(cornerRadius: 2)
                .fill(device.frameColor)
                .frame(width: 3, height: 80)
                .offset(x: device.screenSize.width / 2 + device.bezelWidth + 1, y: -80)

            // Volume buttons (left side)
            VStack(spacing: 12) {
                // Silent switch
                RoundedRectangle(cornerRadius: 2)
                    .fill(device.frameColor)
                    .frame(width: 3, height: 30)

                // Volume up
                RoundedRectangle(cornerRadius: 2)
                    .fill(device.frameColor)
                    .frame(width: 3, height: 55)

                // Volume down
                RoundedRectangle(cornerRadius: 2)
                    .fill(device.frameColor)
                    .frame(width: 3, height: 55)
            }
            .offset(x: -(device.screenSize.width / 2 + device.bezelWidth + 1), y: -100)
        }
    }

    // MARK: - iPad Frame

    private var iPadFrame: some View {
        ZStack {
            // Device body
            RoundedRectangle(cornerRadius: device.cornerRadius + device.bezelWidth)
                .fill(device.frameColor)
                .frame(
                    width: device.screenSize.width + device.bezelWidth * 2,
                    height: device.screenSize.height + device.bezelWidth * 2
                )

            // Screen
            ZStack(alignment: .top) {
                // Screen background
                RoundedRectangle(cornerRadius: device.cornerRadius)
                    .fill(Color(nsColor: .windowBackgroundColor))

                // Content
                content()
                    .frame(width: device.screenSize.width, height: device.screenSize.height)
                    .clipShape(RoundedRectangle(cornerRadius: device.cornerRadius))

                // Home indicator
                if device.hasHomeIndicator {
                    VStack {
                        Spacer()
                        Capsule()
                            .fill(Color(white: 0.3))
                            .frame(width: 134, height: 5)
                            .padding(.bottom, 8)
                    }
                    .frame(width: device.screenSize.width, height: device.screenSize.height)
                }
            }
            .frame(width: device.screenSize.width, height: device.screenSize.height)
            .clipShape(RoundedRectangle(cornerRadius: device.cornerRadius))

            // Camera
            Circle()
                .fill(Color(white: 0.1))
                .frame(width: 8, height: 8)
                .offset(y: -(device.screenSize.height / 2 + device.bezelWidth - 8))
        }
        .shadow(color: .black.opacity(0.3), radius: 20, y: 10)
    }

    // MARK: - Mac Frame

    private var macFrame: some View {
        VStack(spacing: 0) {
            // Title bar
            HStack(spacing: 8) {
                // Traffic lights
                HStack(spacing: 6) {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 12, height: 12)
                    Circle()
                        .fill(Color.yellow)
                        .frame(width: 12, height: 12)
                    Circle()
                        .fill(Color.green)
                        .frame(width: 12, height: 12)
                }
                .padding(.leading, 12)

                Spacer()

                Text("Preview")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.secondary)

                Spacer()

                // Balance spacing
                HStack(spacing: 6) {
                    Circle().fill(Color.clear).frame(width: 12, height: 12)
                    Circle().fill(Color.clear).frame(width: 12, height: 12)
                    Circle().fill(Color.clear).frame(width: 12, height: 12)
                }
                .padding(.trailing, 12)
            }
            .frame(height: 28)
            .background(Color(nsColor: .windowBackgroundColor))

            Divider()

            // Content area
            content()
                .frame(width: device.screenSize.width, height: device.screenSize.height - 28)
                .background(Color(nsColor: .windowBackgroundColor))
        }
        .frame(width: device.screenSize.width, height: device.screenSize.height)
        .clipShape(RoundedRectangle(cornerRadius: device.cornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: device.cornerRadius)
                .strokeBorder(Color(nsColor: .separatorColor), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.3), radius: 20, y: 10)
    }
}

#Preview("iPhone 15 Pro") {
    DeviceFrameView(device: .iPhone15Pro) {
        VStack {
            Text("Hello, World!")
                .font(.largeTitle)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
    .padding(50)
}

#Preview("iPad Pro") {
    DeviceFrameView(device: .iPadPro11) {
        VStack {
            Text("Hello, iPad!")
                .font(.largeTitle)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
    .padding(50)
    .scaleEffect(0.5)
}

#Preview("Mac Window") {
    DeviceFrameView(device: .macWindow) {
        VStack {
            Text("Hello, Mac!")
                .font(.largeTitle)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
    .padding(50)
}
