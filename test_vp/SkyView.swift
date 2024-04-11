//
//  SkyView.swift
//  test_vp
//
//  Created by Bryce Li on 4/11/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct SkyView: View {
    var body: some View {
        Model3D(named: "Scene", bundle: realityKitContentBundle)
            .padding(.bottom, 50)
    }
}

#Preview {
    SkyView()
}
