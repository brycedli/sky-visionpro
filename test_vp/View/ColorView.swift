//
//  ColorView.swift
//  test_vp
//
//  Created by Bryce Li on 2/12/24.
//

import SwiftUI

struct ColorView: View {
    var viewModel: ColorStringsViewModel
    @Binding var colorStringId: UUID?
    var body: some View{
        if let colorStringId = colorStringId, let colorString = viewModel.colorStrings.first(where: {$0.id == colorStringId} ) {
            VStack {
                Text (colorString.string)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity )
                    .background(colorString.color)
            }
        }
    }
}
 
