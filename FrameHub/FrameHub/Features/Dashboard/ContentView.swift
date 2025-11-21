//
//  ContentView.swift
//  FrameHub
//
//  Created by Peter Conijn on 21/11/2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var homeKitManager: HomeKitManager
    @EnvironmentObject var musicManager: MusicManager

    var body: some View {
        // Show Dashboard directly
        DashboardView(homeKitManager: homeKitManager, musicManager: musicManager)
    }
}

struct InfoRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 30)
            Text(text)
                .font(.body)
        }
    }
}

#Preview {
    ContentView()
}
