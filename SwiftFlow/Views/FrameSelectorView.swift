//
//  FrameSelectorView.swift
//  SwiftFlow
//
//  Created by Kevin Perez on 7/5/24.
//

import SwiftUI

struct FrameSelectorView: View {
    @Binding var selectedDeviceFrame: DeviceFrame
    @Binding var isDarkMode: Bool

    var body: some View {
        HStack {
            Picker("", selection: $selectedDeviceFrame) {
                Image(systemName: "square.dashed").tag(DeviceFrame.none)
                Image(systemName: "iphone").tag(DeviceFrame.iPhone)
                Image(systemName: "ipad.landscape").tag(DeviceFrame.iPad)
                Image(systemName: "macbook").tag(DeviceFrame.mac)
                Image(systemName: "applewatch").tag(DeviceFrame.appleWatch)
            }
            .pickerStyle(SegmentedPickerStyle())
            Spacer()
            Toggle(isOn: $isDarkMode) {
                if(isDarkMode) {
                    Image(systemName: "moon.fill")
                } else {
                    Image(systemName: "sun.max.fill")
                }
            }
            .toggleStyle(.button)
        }
    }
}


