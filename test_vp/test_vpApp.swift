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

//openWindow(id: "SecondWindow")
    
    var body: some Scene {
        
        WindowGroup(id: "Menu") {
            ContentView()
            
        }.windowStyle(.plain)
//        ImmersiveSpace(id: "Sky") {
//            SkyView()
//        }.windowStyle(.volumetric).defaultSize(width: 1, height: 1, depth: 0.1, in: .meters).immersionStyle(selection: $portalImmersionStyle, in: .progressive)
        ImmersiveSpace(id: "Sky") {
            SkyView()
            
        }.immersiveContentBrightness(.bright)

         
 
    }
    
}


