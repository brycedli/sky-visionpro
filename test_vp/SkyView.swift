//
//  SkyView.swift
//  test_vp
//
//  Created by Bryce Li on 4/11/24.
//

import SwiftUI
import RealityKit
import RealityKitContent
import AVFoundation
import AVKit
import GameKit

struct SkyView: View {
    @State var viewModel: ViewModel
    
    let basePortals = Entity()
    let portal = Entity()
    let rainbow = try! Entity.load(named: "Scene", in: realityKitContentBundle)
    let cloudEntity = try! Entity.load(named: "CloudTest", in: realityKitContentBundle)
    @State private var hasFinishedSetup = false
    
    func expand (size: Float) {
        portal.setScale(SIMD3(repeating: 0.001), relativeTo: nil)
        portal.position = SIMD3(0, 1, -1.5)
        let r = Transform(pitch: .pi, yaw: .pi, roll: 0)
        let to0 = Transform(scale:SIMD3(repeating: 0.05), rotation: r.rotation, translation: portal.position)
        portal.transform.rotation = r.rotation
        portal.move(to:to0, relativeTo: nil, duration: 1, timingFunction: .default)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Adjust delay as needed
            let r2 = Transform(pitch: .pi/2 * 1, yaw: .pi, roll: 0)
            
            let to1 = Transform(scale: SIMD3(repeating: 0.05), rotation: r2.rotation, translation: SIMD3(0, 1.5, -1.5))
            
            portal.move(to: to1, relativeTo: nil, duration: 1, timingFunction: .easeIn)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Adjust delay as needed
                
                let to2 = Transform(scale: SIMD3(repeating: size), rotation: r2.rotation, translation: SIMD3(0, 2.5, -1.5))
                portal.move(to: to2, relativeTo: nil, duration: 4, timingFunction: .easeOut)
                hasFinishedSetup = true
            }
        }
        
        
    }
    var body: some View {
        
        Button(action: {
            //            testSize = Double.random(in: 0...1)
            //            expand(size: 1.3)
        }, label: {
            //            Text(String(testSize))
        }
        )
        RealityView {
            content in
            
            
            
            let world = Entity()
            world.components[WorldComponent.self] = .init()
            
            let url = Bundle.main.url(forResource: "cloud_0_5", withExtension: "mp4")!
            let asset = AVURLAsset(url: url)
            let playerItem = AVPlayerItem(asset: asset)
            let player = AVPlayer()
            
            let skyVideoMaterial = VideoMaterial(avPlayer: player)
            let skySphere = Entity()
            skySphere.components.set(ModelComponent(mesh: .generateSphere(radius: 1E3), materials: [skyVideoMaterial]))
            skySphere.scale = .init(x: 1, y: 1, z: -1)
            let rotationAngle = Float(Angle(degrees: -90).radians)
            skySphere.transform.rotation = .init(angle: rotationAngle, axis: .init(0.0, 1.0, 0.0))
            let rotationAngle2 = Float(Angle(degrees: -45).radians)
            skySphere.transform.rotation *= .init(angle: rotationAngle2, axis: .init(0.0, 0.0, 1.0))
            world.addChild(skySphere)
            
            
            player.replaceCurrentItem(with: playerItem)
            player.play()
            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: nil) { notif in
                player.seek(to: .zero)
                player.play()
            }
            
            portal.components[ModelComponent.self] = .init(mesh: .generatePlane(width: 1.5, height: 1.5, cornerRadius: 1), materials: [PortalMaterial()])
            portal.components[PortalComponent.self] = .init(target: world)
            portal.transform = Transform(pitch: .pi/2, yaw: 0, roll: 0)
            portal.position = SIMD3(0, 2.5, -2)
            portal.setScale(SIMD3(repeating: 0.001), relativeTo: nil)
            content.add(world)
            basePortals.addChild(portal)
            content.add(basePortals)
            
            rainbow.transform = Transform(pitch: .pi/2 * 1, yaw: .pi, roll: 0)
            
            rainbow.setScale(SIMD3(repeating: 7.5), relativeTo: nil)
            portal.addChild(rainbow)
            
            rainbow.position.z -= 0.01
            
            Task {
                expand (size: getScale())
            }
        }
        
    update: {scene in
        if (hasFinishedSetup){
            portal.setScale(SIMD3(repeating: getScale()), relativeTo: nil)
        }
        
        
    }
        
    }
    
    func getScale() -> Float {
        return 1 + pow(viewModel.sliderValue, 3)
    }
}

