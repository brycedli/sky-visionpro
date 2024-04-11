//
//  MenuView.swift
//  test_vp
//
//  Created by Bryce Li on 4/11/24.
//

import SwiftUI

struct MenuView: View {
    @Binding  var selectedButton: SelectedButton?
    var body: some View {
        HStack (alignment: .center, spacing: 12) {
            Button("Idea", systemImage: "lightbulb.2") {
                withAnimation{
                    selectedButton = .idea
                }
            }.buttonStyle(.borderless)
                .padding(0)
                .background(selectedButton == .idea ? Color.secondary.opacity(0.5) : Color.clear)
                .clipShape(Circle())
            Button("Draw", systemImage: "hand.draw") {
                withAnimation{
                    selectedButton = .draw
                }
            }.buttonStyle(.borderless)
                .padding(0)
                .background(selectedButton == .draw ? Color.secondary.opacity(0.5) : Color.clear)
                .clipShape(Circle())
            
            Button ("People", systemImage: "person.2") {
                withAnimation{
                    selectedButton = .people
                }
            }.buttonStyle(.borderless)
                .padding(0)
                .background(selectedButton == .people ? Color.secondary.opacity(0.5) : Color.clear)
                .clipShape(Circle())
            if selectedButton != .none {
                Button(action: {
                    withAnimation{
                        selectedButton = .none
                    }
                }, label: {
                    Text("Done")
                }).transition(.asymmetric(insertion: .push(from: .trailing), removal: .opacity))
            }
            
            
            
        }
        
        .labelStyle(.iconOnly)
        .padding()
        .glassBackgroundEffect()
    }
}

