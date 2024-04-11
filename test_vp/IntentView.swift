//
//  IntentView.swift
//  test_vp
//
//  Created by Bryce Li on 4/11/24.
//

import SwiftUI

struct IntentView: View {
    @Binding var range: Double
    var body: some View {
        VStack (alignment: .center, spacing: 12) {
            VStack(alignment: .center, spacing: 2) {
                Text("What do you want to do?")
                    .font(.title)
                Text("Select the intent of the session").opacity(0.6)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            
            Divider().tint(Color.white)
            Slider(
                value: $range,
                in: 0...100,
                step: 25
            )
            HStack{
                Text("Challenge")
                    .frame(maxWidth: .infinity, alignment: .leading).opacity(0.6)
                Text("Think")
                    .frame(maxWidth: .infinity, alignment: .center).opacity(0.6)
                Text("Inspire")
                    .frame(maxWidth: .infinity, alignment: .trailing).opacity(0.6)
            }
            Spacer()
            
        }.frame(width: 512, height: 180)
            .padding(20)
            .glassBackgroundEffect()
//
    }
}

