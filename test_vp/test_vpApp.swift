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
            SkyView(viewModel: viewModel)
            /*.environmentObject(skyState)*/
            
        }.immersiveContentBrightness(.bright)
    }
}


