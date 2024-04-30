//
//  ShareView.swift
//  test_vp
//
//  Created by Bryce Li on 4/29/24.
//

import SwiftUI

struct ShareView: View {
    var body: some View {
        VStack (alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Sync the sky with")
                    .font(.title)
                //                Text("Select the intent of the session").opacity(0.6)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            Divider().tint(Color.white)
            HStack(alignment: .top, spacing: 16){
                ProfileView()
                ProfileView()
                ProfileView()
                ProfileView()
                ProfileView()
                
            }.padding(0).frame(alignment: .topLeading)
        }.padding(.bottom, 40).frame(width: 512)
            .padding(20)
            .glassBackgroundEffect()
    }
    
    
}
struct ProfileView: View {
    var body : some View {
        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
            VStack(alignment: .center, spacing: 8) {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 52, height: 52)
                    .background(
                        Image(uiImage: UIImage(named: "emily")!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 52, height: 52)
                            .clipped()
                    )
                    .cornerRadius(100)
                Text("Emily Liu")
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .top)
                    .font(.footnote)
            }
            .padding(8)
        })
        .buttonStyle(PlainButtonStyle())
        .buttonBorderShape(.roundedRectangle(radius: 16))
        .frame(width: 84, alignment: .top)
        

//        .cornerRadius(16)
    }
}
#Preview {
    ShareView()
}
