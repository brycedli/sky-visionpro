//
//  ColorListView.swift
//  test_vp
//
//  Created by Bryce Li on 2/12/24.
//

import Foundation
import SwiftUI

struct ColorListView: View {
    @Environment(\.openWindow) private var openWindow
    var viewModel: ColorStringsViewModel
    var body: some View {
        ForEach(viewModel.colorStrings) {
            colorString in Button {
                openWindow(value: colorString.id)
            } label: {
                Text(colorString.string)
            }
            .background(colorString.color)
            .glassBackgroundEffect()
        }
    }
}

#Preview {
    ColorListView(viewModel: ColorStringsViewModel())
}

