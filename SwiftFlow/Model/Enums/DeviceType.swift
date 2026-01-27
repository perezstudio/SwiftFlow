//
//  DeviceType.swift
//  SwiftFlow
//
//  Created on 1/27/26.
//

import SwiftUI

/// Device categories for preview selection
enum DeviceCategory: String, CaseIterable, Identifiable {
    case iPhone
    case iPad
    case mac

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .iPhone: return "iPhone"
        case .iPad: return "iPad"
        case .mac: return "Mac"
        }
    }

    var iconName: String {
        switch self {
        case .iPhone: return "iphone"
        case .iPad: return "ipad"
        case .mac: return "macbook"
        }
    }
}

/// Available device types for preview
enum DeviceType: String, CaseIterable, Identifiable, Codable {
    // iPhone models
    case iPhoneSE
    case iPhone15
    case iPhone15Plus
    case iPhone15Pro
    case iPhone15ProMax

    // iPad models
    case iPadMini
    case iPad
    case iPadAir
    case iPadPro11
    case iPadPro13

    // Mac
    case macWindow

    var id: String { rawValue }

    // MARK: - Display Properties

    var displayName: String {
        switch self {
        case .iPhoneSE: return "iPhone SE"
        case .iPhone15: return "iPhone 15"
        case .iPhone15Plus: return "iPhone 15 Plus"
        case .iPhone15Pro: return "iPhone 15 Pro"
        case .iPhone15ProMax: return "iPhone 15 Pro Max"
        case .iPadMini: return "iPad mini"
        case .iPad: return "iPad"
        case .iPadAir: return "iPad Air"
        case .iPadPro11: return "iPad Pro 11\""
        case .iPadPro13: return "iPad Pro 13\""
        case .macWindow: return "Mac Window"
        }
    }

    var category: DeviceCategory {
        switch self {
        case .iPhoneSE, .iPhone15, .iPhone15Plus, .iPhone15Pro, .iPhone15ProMax:
            return .iPhone
        case .iPadMini, .iPad, .iPadAir, .iPadPro11, .iPadPro13:
            return .iPad
        case .macWindow:
            return .mac
        }
    }

    // MARK: - Screen Specifications (in points)

    var screenSize: CGSize {
        switch self {
        case .iPhoneSE: return CGSize(width: 375, height: 667)
        case .iPhone15: return CGSize(width: 393, height: 852)
        case .iPhone15Plus: return CGSize(width: 430, height: 932)
        case .iPhone15Pro: return CGSize(width: 393, height: 852)
        case .iPhone15ProMax: return CGSize(width: 430, height: 932)
        case .iPadMini: return CGSize(width: 744, height: 1133)
        case .iPad: return CGSize(width: 820, height: 1180)
        case .iPadAir: return CGSize(width: 820, height: 1180)
        case .iPadPro11: return CGSize(width: 834, height: 1194)
        case .iPadPro13: return CGSize(width: 1024, height: 1366)
        case .macWindow: return CGSize(width: 800, height: 600)
        }
    }

    var cornerRadius: CGFloat {
        switch self {
        case .iPhoneSE: return 0 // Flat edges
        case .iPhone15, .iPhone15Plus: return 50
        case .iPhone15Pro, .iPhone15ProMax: return 55
        case .iPadMini: return 20
        case .iPad, .iPadAir: return 20
        case .iPadPro11, .iPadPro13: return 18
        case .macWindow: return 10
        }
    }

    // MARK: - Notch/Island Properties

    var hasNotch: Bool {
        switch self {
        case .iPhoneSE, .macWindow:
            return false
        case .iPadMini, .iPad, .iPadAir, .iPadPro11, .iPadPro13:
            return false
        default:
            return false // All modern iPhones have Dynamic Island
        }
    }

    var hasDynamicIsland: Bool {
        switch self {
        case .iPhone15, .iPhone15Plus, .iPhone15Pro, .iPhone15ProMax:
            return true
        default:
            return false
        }
    }

    var hasHomeIndicator: Bool {
        switch self {
        case .iPhoneSE:
            return false // Has home button
        case .macWindow:
            return false
        default:
            return true
        }
    }

    var hasHomeButton: Bool {
        switch self {
        case .iPhoneSE:
            return true
        default:
            return false
        }
    }

    // MARK: - Safe Area Insets

    var safeAreaInsets: EdgeInsets {
        switch self {
        case .iPhoneSE:
            return EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0)
        case .iPhone15, .iPhone15Plus:
            return EdgeInsets(top: 59, leading: 0, bottom: 34, trailing: 0)
        case .iPhone15Pro, .iPhone15ProMax:
            return EdgeInsets(top: 59, leading: 0, bottom: 34, trailing: 0)
        case .iPadMini, .iPad, .iPadAir:
            return EdgeInsets(top: 24, leading: 0, bottom: 20, trailing: 0)
        case .iPadPro11, .iPadPro13:
            return EdgeInsets(top: 24, leading: 0, bottom: 20, trailing: 0)
        case .macWindow:
            return EdgeInsets(top: 28, leading: 0, bottom: 0, trailing: 0) // Title bar
        }
    }

    // MARK: - Device Frame Properties

    var bezelWidth: CGFloat {
        switch self {
        case .iPhoneSE:
            return 3
        case .iPhone15, .iPhone15Plus, .iPhone15Pro, .iPhone15ProMax:
            return 3
        case .iPadMini, .iPad, .iPadAir, .iPadPro11, .iPadPro13:
            return 4
        case .macWindow:
            return 0
        }
    }

    var frameColor: Color {
        switch self {
        case .iPhone15Pro, .iPhone15ProMax:
            return Color(white: 0.3) // Titanium-ish
        default:
            return Color(white: 0.15) // Black
        }
    }

    // MARK: - Status Bar

    var statusBarHeight: CGFloat {
        switch self {
        case .iPhoneSE:
            return 20
        case .iPhone15, .iPhone15Plus, .iPhone15Pro, .iPhone15ProMax:
            return 54
        case .iPadMini, .iPad, .iPadAir, .iPadPro11, .iPadPro13:
            return 24
        case .macWindow:
            return 0
        }
    }

    // MARK: - Helper

    static func devices(for category: DeviceCategory) -> [DeviceType] {
        allCases.filter { $0.category == category }
    }
}
