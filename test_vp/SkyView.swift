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
        RealityView {
            content in
            let boxResource = MeshResource.generateSphere(radius: 1000)
            let myMaterial = UnlitMaterial(color: .blue)

            let myEntity = ModelEntity(mesh: boxResource, materials: [myMaterial])
            myEntity.scale *= .init(x: 1, y: 1, z: -1)
            
            let portalMesh = MeshResource.generateBox(size: 1)
            let portalEntity = ModelEntity(mesh: portalMesh, materials: [OcclusionMaterial()])
            content.add(myEntity)
            content.add(portalEntity)
        }
        
        
        Model3D(named: "Scene", bundle: realityKitContentBundle)
            .padding(.bottom, 50)
    }
}

#Preview (windowStyle: .volumetric) {
    SkyView()
}
