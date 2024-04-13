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
    let portal = Entity()
    
    func expand (size: Float) {
        var tTo = Transform(scale:SIMD3(repeating: size), rotation: portal.orientation, translation: portal.position)
        portal.move(to:tTo, relativeTo: nil, duration: 3, timingFunction: .default)
    }
    var body: some View {
        
        RealityView {
            content in
//            let portal = Entity()
            let world = Entity()
            world.components[WorldComponent.self] = .init()
            let skyBlue = UIColor(red: 53/255, green: 137/255, blue: 215/255, alpha: 1)
            let skyMaterial = UnlitMaterial(color: skyBlue)
            let skySphere = Entity()
            skySphere.components.set(ModelComponent(mesh: .generateSphere(radius: 1E3), materials: [skyMaterial]))
            skySphere.scale = .init(x: 1, y: 1, z: -1)
            world.addChild(skySphere)
            portal.components[ModelComponent.self] = .init(mesh: .generatePlane(width: 1.4, height: 1.5, cornerRadius: 1), materials: [PortalMaterial()])
            portal.components[PortalComponent.self] = .init(target: world)
            portal.transform = Transform(pitch: .pi/2, yaw: 0, roll: 0)
            portal.position.y += 2.5
            portal.position.z -= 1
            portal.setScale(SIMD3(repeating: 0.001), relativeTo: nil)
            content.add(world)
            content.add(portal)
            Task {
                expand (size: 1.2)
            }
        }
    }
}

#Preview (immersionStyle: .mixed) {
    SkyView()
    
}
