//
//  AppProjectCardView.swift
//  SwiftFlow
//
//  Created by Kevin Perez on 4/27/23.
//

import SwiftUI

struct AppProjectCardView: View {
    
    @State var appName: String
    @State var appColor: Color
    @State var appIcon: String
    
    var body: some View {
        VStack (alignment: .center, spacing: 6) {
            HStack(alignment: .center) {
                Image(appIcon)
                    .resizable()
                    .frame(maxWidth: 100, maxHeight: 100)
                    .cornerRadius(12)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(28)
            .background(appColor.opacity(0.40))
            .cornerRadius(12)
            Text(appName)
                .font(.title3)
            HStack {
                Image(systemName: "macstudio.fill")
                Image(systemName: "ipad.landscape")
            }
        }
    }
}

struct AppProjectCardView_Previews: PreviewProvider {
    static var previews: some View {
        AppProjectCardView(appName: "SwiftFlow", appColor: Color.orange, appIcon: "swiftflow")
    }
}
