//
//  ContentView.swift
//  FrameHub
//
//  Created by Peter Conijn on 21/11/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "house.fill")
                .imageScale(.large)
                .foregroundStyle(.tint)
                .font(.system(size: 60))

            Text("FrameHub")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Smart Home Control Center")
                .font(.title3)
                .foregroundColor(.secondary)

            Spacer()
                .frame(height: 40)

            VStack(alignment: .leading, spacing: 12) {
                InfoRow(icon: "lightbulb.fill", text: "HomeKit Integration")
                InfoRow(icon: "music.note", text: "Music Streaming")
                InfoRow(icon: "photo.fill", text: "Screensaver")
                InfoRow(icon: "cloud.sun.fill", text: "Weather Display")
                InfoRow(icon: "video.fill", text: "Camera Feeds")
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 5)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
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
