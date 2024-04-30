//
//  test_vpApp.swift
//  test_vp
//
//  Created by Bryce Li on 1/24/24.
//

import SwiftUI

@main
struct test_vpApp: App {
    @Environment(\.openWindow) private var openWindow
    @State var viewModel = ViewModel()
    
    var body: some Scene {
        
        WindowGroup(id: "Menu") {
            ContentView(viewModel: viewModel)
            
        }.windowStyle(.plain)

        ImmersiveSpace(id: "Sky") {
            SkyView(gestureModel: GestureModelContainer.gestureModel, viewModel: viewModel)
            /*.environmentObject(skyState)*/
            
        }.immersiveContentBrightness(.bright)
        
        
//        WindowGroup(id: "Drawing") {
//            DrawingView()
//        }.windowStyle(.volumetric).defaultSize(width: 0.2, height: 0.2, depth: 0.2, in: .meters)
        
    }
}


@MainActor
enum GestureModelContainer {
    private(set) static var gestureModel = GestureModel()
}
