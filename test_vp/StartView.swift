//
//  StartView.swift
//  test_vp
//
//  Created by Bryce Li on 4/11/24.
//

import SwiftUI

struct StartView: View {
    @Binding  var selectedButton: SelectedButton?

    @Environment(\.openImmersiveSpace) private var openImmersiveSpace

    //
    
    var body: some View {
        VStack {
            VStack (alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 2){
                Text("The skies call for you...").font(.headline)
                Text("Start session").font(.caption).opacity(0.8).multilineTextAlignment(.center)

            }.padding(.horizontal, 16)
                .padding(.vertical, 8)
                .frame(width: 270, alignment: .top)
            Button(action: {
                Task {
                    await openImmersiveSpace(id: "Sky")
                }
                
                withAnimation{
                    selectedButton = .none
                }
            }, label: {
                Text("Open the sky").frame(maxWidth: .infinity)
            }).buttonStyle(.borderedProminent)
            Spacer()
        }.frame(width: 280, height: 140, alignment: .center)
            .padding(20)
            .glassBackgroundEffect()
    }
}


