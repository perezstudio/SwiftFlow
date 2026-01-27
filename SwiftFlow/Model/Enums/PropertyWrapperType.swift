//
//  PropertyWrapperType.swift
//  SwiftFlow
//
//  Created on 1/26/26.
//

import Foundation

/// Property wrapper types available in SwiftUI views
enum PropertyWrapperType: String, Codable, CaseIterable, Identifiable, Sendable {
    var id: String { rawValue }

    // MARK: - State Management
    case state           // @State
    case binding         // @Binding
    case bindable        // @Bindable (for @Observable objects)

    // MARK: - Observation
    case stateObject     // @StateObject
    case observedObject  // @ObservedObject
    case environmentObject // @EnvironmentObject

    // MARK: - SwiftData
    case query           // @Query

    // MARK: - Environment
    case environment     // @Environment

    // MARK: - Focus
    case focusState      // @FocusState

    // MARK: - App Storage
    case appStorage      // @AppStorage
    case sceneStorage    // @SceneStorage

    // MARK: - Gesture
    case gestureState    // @GestureState

    // MARK: - Namespace
    case namespace       // @Namespace

    // MARK: - Plain (no wrapper)
    case plain           // Regular property (let/var)

    // MARK: - Display Properties

    var displayName: String {
        switch self {
        case .state: return "@State"
        case .binding: return "@Binding"
        case .bindable: return "@Bindable"
        case .stateObject: return "@StateObject"
        case .observedObject: return "@ObservedObject"
        case .environmentObject: return "@EnvironmentObject"
        case .query: return "@Query"
        case .environment: return "@Environment"
        case .focusState: return "@FocusState"
        case .appStorage: return "@AppStorage"
        case .sceneStorage: return "@SceneStorage"
        case .gestureState: return "@GestureState"
        case .namespace: return "@Namespace"
        case .plain: return "Property"
        }
    }

    var description: String {
        switch self {
        case .state:
            return "A value that SwiftUI manages and automatically persists across view updates."
        case .binding:
            return "A two-way connection to a value owned by a parent view."
        case .bindable:
            return "Creates bindings to properties of an @Observable object."
        case .stateObject:
            return "An ObservableObject that the view owns and manages its lifecycle."
        case .observedObject:
            return "An ObservableObject passed from a parent view."
        case .environmentObject:
            return "An ObservableObject supplied by an ancestor view."
        case .query:
            return "Fetches data from SwiftData based on a predicate and sort descriptors."
        case .environment:
            return "Reads a value from the view's environment."
        case .focusState:
            return "A property wrapper that controls focus state."
        case .appStorage:
            return "A value stored in UserDefaults that persists across app launches."
        case .sceneStorage:
            return "A value stored for the lifetime of the current scene."
        case .gestureState:
            return "A value that changes during a gesture and resets when the gesture ends."
        case .namespace:
            return "Creates a unique namespace for matched geometry effects."
        case .plain:
            return "A regular property without any wrapper."
        }
    }

    var swiftCode: String {
        switch self {
        case .state: return "@State"
        case .binding: return "@Binding"
        case .bindable: return "@Bindable"
        case .stateObject: return "@StateObject"
        case .observedObject: return "@ObservedObject"
        case .environmentObject: return "@EnvironmentObject"
        case .query: return "@Query"
        case .environment: return "@Environment"
        case .focusState: return "@FocusState"
        case .appStorage: return "@AppStorage"
        case .sceneStorage: return "@SceneStorage"
        case .gestureState: return "@GestureState"
        case .namespace: return "@Namespace"
        case .plain: return ""
        }
    }

    var requiresInitialValue: Bool {
        switch self {
        case .state, .stateObject, .appStorage, .sceneStorage, .focusState, .gestureState, .namespace, .plain:
            return true
        case .binding, .bindable, .observedObject, .environmentObject, .query, .environment:
            return false
        }
    }

    var isPrivateByDefault: Bool {
        switch self {
        case .state, .stateObject, .focusState, .gestureState, .namespace:
            return true
        default:
            return false
        }
    }

    var category: PropertyWrapperCategory {
        switch self {
        case .state, .binding, .bindable:
            return .stateManagement
        case .stateObject, .observedObject, .environmentObject:
            return .observation
        case .query:
            return .swiftData
        case .environment:
            return .environment
        case .focusState:
            return .focus
        case .appStorage, .sceneStorage:
            return .storage
        case .gestureState:
            return .gesture
        case .namespace:
            return .animation
        case .plain:
            return .plain
        }
    }
}

enum PropertyWrapperCategory: String, CaseIterable, Identifiable, Sendable {
    var id: String { rawValue }

    case stateManagement
    case observation
    case swiftData
    case environment
    case focus
    case storage
    case gesture
    case animation
    case plain

    var displayName: String {
        switch self {
        case .stateManagement: return "State Management"
        case .observation: return "Observation"
        case .swiftData: return "SwiftData"
        case .environment: return "Environment"
        case .focus: return "Focus"
        case .storage: return "Storage"
        case .gesture: return "Gesture"
        case .animation: return "Animation"
        case .plain: return "Plain"
        }
    }

    var wrappers: [PropertyWrapperType] {
        PropertyWrapperType.allCases.filter { $0.category == self }
    }
}
