//
//  ContentView.swift
//  test_vp
//
//  Created by Bryce Li on 1/24/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

public enum SelectedButton {
    case idea, draw, people, start
}

struct ContentView: View {
    
    @State private var selectedButton: SelectedButton? = .start
    @State private var range = 25.0;
    
    var body: some View {
        Spacer()
        
        HStack (alignment: .bottom){
            switch selectedButton {
            case .idea:
                IntentView(range: $range)
            case .draw:
                IntentView(range: $range).hidden()
            case .start:
                StartView(selectedButton: $selectedButton)
            default:
                EmptyView()
            }
        }
        .ornament(
            visibility: .visible,
            attachmentAnchor: .scene(.bottom)
        ) {
            MenuView(selectedButton: $selectedButton)
        }
            
        
    }
    
}
#Preview (windowStyle: .volumetric) {
    
    ContentView()
    
}


