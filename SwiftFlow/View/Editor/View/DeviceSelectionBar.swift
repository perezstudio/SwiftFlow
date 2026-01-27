//
//  DeviceSelectionBar.swift
//  SwiftFlow
//
//  Created on 1/27/26.
//

import SwiftUI

/// Compact device selector for the toolbar
struct DeviceSelectionBar: View {
    @Binding var selectedDevice: DeviceType

    var body: some View {
        Menu {
            // iPhone section
            Section("iPhone") {
                ForEach(DeviceType.devices(for: .iPhone)) { device in
                    Button(action: { selectedDevice = device }) {
                        HStack {
                            Text(device.displayName)
                            if selectedDevice == device {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            }

            // iPad section
            Section("iPad") {
                ForEach(DeviceType.devices(for: .iPad)) { device in
                    Button(action: { selectedDevice = device }) {
                        HStack {
                            Text(device.displayName)
                            if selectedDevice == device {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            }

            // Mac section
            Section("Mac") {
                ForEach(DeviceType.devices(for: .mac)) { device in
                    Button(action: { selectedDevice = device }) {
                        HStack {
                            Text(device.displayName)
                            if selectedDevice == device {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            }
        } label: {
            HStack(spacing: 4) {
                Image(systemName: selectedDevice.category.iconName)
                    .font(.system(size: 12))
                Text(selectedDevice.displayName)
                    .font(.system(size: 11))
                Image(systemName: "chevron.down")
                    .font(.system(size: 8))
            }
            .foregroundStyle(.secondary)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color(nsColor: .controlBackgroundColor))
            .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .menuStyle(.borderlessButton)
        .menuIndicator(.hidden)
    }
}

/// Segmented device category picker (alternative style)
struct DeviceCategoryPicker: View {
    @Binding var selectedDevice: DeviceType

    @State private var selectedCategory: DeviceCategory

    init(selectedDevice: Binding<DeviceType>) {
        self._selectedDevice = selectedDevice
        self._selectedCategory = State(initialValue: selectedDevice.wrappedValue.category)
    }

    var body: some View {
        HStack(spacing: 8) {
            // Category picker
            Picker("", selection: $selectedCategory) {
                ForEach(DeviceCategory.allCases) { category in
                    Image(systemName: category.iconName)
                        .tag(category)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 120)
            .onChange(of: selectedCategory) { _, newCategory in
                // Switch to first device in category
                if let firstDevice = DeviceType.devices(for: newCategory).first {
                    selectedDevice = firstDevice
                }
            }

            // Device picker within category
            Picker("", selection: $selectedDevice) {
                ForEach(DeviceType.devices(for: selectedCategory)) { device in
                    Text(device.displayName)
                        .tag(device)
                }
            }
            .frame(width: 140)
        }
    }
}

#Preview("Device Selection Bar") {
    DeviceSelectionBar(selectedDevice: .constant(.iPhone15Pro))
        .padding()
}

#Preview("Device Category Picker") {
    DeviceCategoryPicker(selectedDevice: .constant(.iPhone15Pro))
        .padding()
}
