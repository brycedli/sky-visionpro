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
    
    @State var viewModel: ViewModel
    
    var body: some View {
        Spacer()
        
        HStack (alignment: .bottom){
            if (viewModel.spaceVisible){
                switch selectedButton {
                case .idea:
                    IntentView(viewModel: viewModel)
                case .draw:
                    EmptyView()
                case .people:
                    ShareView()
//                case .start:
//                    StartView(selectedButton: $selectedButton)
                default:
                    EmptyView()
                }
            }
            else{
                
                StartView(selectedButton: $selectedButton, viewModel: viewModel).animation(.default, value: viewModel.spaceVisible)
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



