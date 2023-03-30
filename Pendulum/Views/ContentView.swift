//
//  ContentView.swift
//  Pendulum
//
//  Created by Ben Cardy on 04/11/2022.
//

import SwiftUI
import ImageViewer

struct ContentView: View {
    
    @State private var selectedTab: Int = Tab.penPalList.rawValue
    @StateObject private var appPreferences = AppPreferences.shared
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @EnvironmentObject var imageViewerController: ImageViewerController
    
    var body: some View {
        Group {
            if DeviceType.isPad() && horizontalSizeClass != .compact {
                PenPalSplitView()
            } else {
                TabView(selection: $selectedTab) {
                    PenPalTab()
                        .tabItem { Label("Pen Pals", systemImage: "pencil.line") }
                        .tag(Tab.penPalList.rawValue)
                    SettingsList()
                        .tabItem { Label("Settings", systemImage: "gear") }
                        .tag(Tab.settings.rawValue)
                }
            }
        }
        .environmentObject(appPreferences)
//        .overlay(ImageViewer(image: $imageViewerController.image, viewerShown: $imageViewerController.show, closeButtonTopRight: true))
        .sheet(isPresented: $imageViewerController.show) {
            ImageGalleryOverlay()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
