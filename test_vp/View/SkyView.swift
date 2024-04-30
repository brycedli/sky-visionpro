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
    @ObservedObject var gestureModel: GestureModel
    
    @State var viewModel: ViewModel
    @State private var cat = try! Entity.load(named: "cat", in: realityKitContentBundle)
    
    @State private var portal: Entity = Entity()
    let basePortals = Entity()
//    let portal = Entity()
    @State private var rainbow = try! Entity.load(named: "Scene", in: realityKitContentBundle)
    @State private var cloudEntity = try! Entity.load(named: "CloudTest", in: realityKitContentBundle)
    @State private var hasFinishedSetup = false
    @State private var player: AVQueuePlayer = AVQueuePlayer()
    
    @State private var playerLooper : AVPlayerLooper?
    
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    hasFinishedSetup = true
                }
                
            }
        }
        
        
    }
    var body: some View {
        Button {
            playCat()
        } label: {
            Text("Pick up cat")
        }

        RealityView {
            content in
            
            content.entities.removeAll()
            
            let world = Entity()
            world.components[WorldComponent.self] = .init()
            
            let urlMain = Bundle.main.url(forResource: "cloud_0_6", withExtension: "mp4")!
            let defaultAsset = AVURLAsset(url: urlMain)
            let defaultItem = AVPlayerItem(asset: defaultAsset)
            
            
            
            let skyVideoMaterial = VideoMaterial(avPlayer: player)
            let skySphere = Entity()
            skySphere.components.set(ModelComponent(mesh: .generateSphere(radius: 1E3), materials: [skyVideoMaterial]))
            skySphere.scale = .init(x: 1, y: 1, z: -1)
            let rotationAngle = Float(Angle(degrees: -90).radians)
            skySphere.transform.rotation = .init(angle: rotationAngle, axis: .init(0.0, 1.0, 0.0))
            let rotationAngle2 = Float(Angle(degrees: -45).radians)
            skySphere.transform.rotation *= .init(angle: rotationAngle2, axis: .init(0.0, 0.0, 1.0))
            world.addChild(skySphere)
            playerLooper = AVPlayerLooper(player: player, templateItem: defaultItem)
//            player.replaceCurrentItem(with: defaultItem)
            player.play()
            
//            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: nil) { notif in
//                player.seek(to: .zero)
//                player.play()
//            }
            
            portal = Entity()
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
            
//            box = ModelEntity(mesh: MeshResource.generateBox(size:0.3), materials: [SimpleMaterial(color: .red, isMetallic: false)])
//            box.components.set(InputTargetComponent(allowedInputTypes: .indirect))
//            box.generateCollisionShapes(recursive: true)
            content.add(cat)
            Task {
                expand (size: getScale())
            }
        }
        update: {content in
            if (hasFinishedSetup){
                portal.setScale(SIMD3(repeating: getScale()), relativeTo: nil)
            }
            let handsCenterTransform = gestureModel.computeTransformOfUserPerformedHeartGesture()
            if (handsCenterTransform != nil){
                if let handsCenter = handsCenterTransform {
                    let position = Pose3D(handsCenter)!.position
                    cat.transform.translation = SIMD3<Float>(position.vector)
                }
            }
//            let imageTracking = gestureModel.imagePosition()
//            if (imageTracking != nil){
//                box.transform.translation = imageTracking!
//            }
        }
//        .gesture(
//            DragGesture()
//                .targetedToEntity(box)
//                .onChanged({value in
//                    box.position = value.convert(value.location3D, from: .local, to: box.parent!)
//                })
//        )
        .onDisappear {
            hasFinishedSetup = false
            viewModel.spaceVisible = false
        }.task {
            await gestureModel.start()
        }
        .task {
            await gestureModel.publishHandTrackingUpdates()
        }
        .task {
            await gestureModel.monitorSessionEvents()
        }
        
    }
    
    func getScale() -> Float {
        return 0.5 + 2 * pow(viewModel.sliderValue, 2)
    }
    
    func playCat () {
        let urlCat = Bundle.main.url(forResource: "cloud_cat", withExtension: "mp4")!
        let catAsset = AVURLAsset(url: urlCat)
        let catItem = AVPlayerItem(asset: catAsset)
        player.replaceCurrentItem(with: catItem)
        player.play()
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: nil) { notif in
            let urlMain = Bundle.main.url(forResource: "cloud_0_6", withExtension: "mp4")!
            let defaultAsset = AVURLAsset(url: urlMain)
            let defaultItem = AVPlayerItem(asset: defaultAsset)
            player.replaceCurrentItem(with: defaultItem)
            player.play()
        }
    }
}

