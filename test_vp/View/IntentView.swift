//
//  IntentView.swift
//  test_vp
//
//  Created by Bryce Li on 4/11/24.
//

import SwiftUI

struct IntentView: View {
    //    @Binding var range: Double
    @State var viewModel: ViewModel
    
    var body: some View {
        VStack (alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Sky size")
                    .font(.title)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            
            Divider().tint(Color.white)
            Slider(
                value: $viewModel.sliderValue,
                in: 0...1
                //                step: 0.25
            ) {} minimumValueLabel: {
                Image(systemName: "smallcircle.filled.circle")
            } maximumValueLabel: {
                Image(systemName: "circle.inset.filled")
            }
        }.padding(.bottom, 40).frame(width: 512)
            .padding(20)
            .glassBackgroundEffect()
    }
}


#Preview(windowStyle: .plain) {
    IntentView(viewModel: ViewModel())
}
