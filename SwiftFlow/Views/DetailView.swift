//
//  DetailView.swift
//  SwiftFlow
//
//  Created by Kevin Perez on 6/25/24.
//

import SwiftUI

enum DeviceFrame {
    case none, iPhone, iPad, mac, appleWatch
}

struct DetailView: View {
    @Bindable var project: AppProject
    @Binding var selectedFile: Files?
    @State private var selectedDeviceFrame: DeviceFrame = .none
    @State private var isDarkMode: Bool = false
    @Binding var draggedComponent: Component?

    var body: some View {
        NavigationView {
                HStack {
                    if let selectedFileBinding = optionalBinding($selectedFile) {
                        VStack(spacing: 16) {
                            FrameSelectorView(selectedDeviceFrame: $selectedDeviceFrame, isDarkMode: $isDarkMode)
                            PreviewArea(selectedDeviceFrame: $selectedDeviceFrame, isDarkMode: $isDarkMode, file: selectedFileBinding, draggedComponent: $draggedComponent)
                        }
                        .padding()
                    } else {
                        Text("No file selected")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }


private func optionalBinding<T>(_ binding: Binding<T?>) -> Binding<T>? {
    guard let value = binding.wrappedValue else {
        return nil
    }
    return Binding(
        get: { value },
        set: { newValue in
            binding.wrappedValue = newValue
        }
    )
}
