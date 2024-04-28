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
    let basePortals = Entity()
    let portal = Entity()
    let rainbow = try! Entity.load(named: "Scene", in: realityKitContentBundle)
    let cloudEntity = try! Entity.load(named: "CloudTest", in: realityKitContentBundle)
    
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
            }
        }
        
        
    }
    var body: some View {
        
        Button(action: {
            
            expand(size: 1.3)
        }, label: {
            Text("hello")}
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
//            let skyRect = Entity()
//            skyRect.components.set(ModelComponent(mesh: .generatePlane(width: 1E3, depth: 1E3), materials: [skyVideoMaterial]))
//            skyRect.transform.translation = .init(x: 0, y: 1E3, z: -1E3)
//            world.addChild(skyRect)
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
            
//            let textMesh = textGen(textString: "hello world")
//            world.addChild(textMesh)
////            content.add(textMesh)
//            textMesh.position = portal.position + 150 * SIMD3(0, 1, -1.5)
//            textMesh.scale = SIMD3(repeating: 200)
//            textMesh.look(at: SIMD3.zero, from: textMesh.position, relativeTo: nil)
            Task {
                expand (size: 1.3)
            }
        }
    }
    
    func textGen(textString: String) -> Entity {
        
        let depthVar: Float = 0.001
        //          let fontVar = UIFont.systemFont(ofSize: 0.1)
        let fontVar = UIFont(name: "CirrusCumulus", size: 0.1)!
        let containerFrameVar = CGRect.zero
        let alignmentVar: CTTextAlignment = .center
        let lineBreakModeVar : CTLineBreakMode = .byWordWrapping
        
        let textMeshResource : MeshResource = .generateText(textString,
                                                            extrusionDepth: depthVar,
                                                            font: fontVar,
                                                            containerFrame: containerFrameVar,
                                                            alignment: alignmentVar,
                                                            lineBreakMode: lineBreakModeVar)
        let textEntity = Entity()
        let textChildren = Entity()
        textEntity.addChild(textChildren)
        //          let textEntity = ModelEntity(mesh: textMeshResource, materials: [materialVar])
        var positions: Array<SIMD3<Float>> = Array()
        let cubeMeshResource : MeshResource = .generatePlane(width: 0.060, height: 0.060)
        //        let cubeMeshResource : MeshResource = .generateSphere(radius: 0.04)(width:
        
        debugPrint(textMeshResource.contents.models.count)
        var pointAverage:SIMD3<Float> = SIMD3.zero
        
        var material = PhysicallyBasedMaterial()
        material.baseColor = try! .init(tint: UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1), texture: .init(.load(named: "whitecloud.png", in: nil)))
        material.opacityThreshold = 0.0 // IMPORTANT
        
        material.faceCulling = .none
        material.emissiveColor = try! .init(color: UIColor.white, texture: .init(.load(named: "whitecloud.png", in: nil)))
        material.emissiveIntensity = 10
        textMeshResource.contents.models.forEach {model in
            model.parts.forEach {part in
                positions = Array(part.positions)
                var buckets = [SIMD3<Int>: [SIMD3<Float>]]()
                let gridSize: Float = 0.01 // Change this based on your spatial density requirements
                
                for point in positions {
                    let bucketKey = SIMD3<Int>(
                        Int(floor(point.x / gridSize)),
                        Int(floor(point.y / gridSize)),
                        Int(floor(point.z / gridSize))
                    )
                    buckets[bucketKey, default: []].append(point)
                }
                
                let maxPointsPerBucket =  2 // Adjust this threshold
                var thinnedPoints: [SIMD3<Float>] = []
                
                
                for (_, bucketPoints) in buckets {
                    if bucketPoints.count > maxPointsPerBucket {
                        // Here we choose the first point, you could also choose a random point or calculate the centroid
                        thinnedPoints.append(bucketPoints[0])
                    } else {
                        thinnedPoints.append(contentsOf: bucketPoints)
                    }
                }
                
                
                
                for point in thinnedPoints {
                    pointAverage = pointAverage + point
                    let cloud = ModelEntity(mesh: cubeMeshResource, materials: [material])
                    cloud.position = point
                    cloud.position = SIMD3(cloud.position.x, cloud.position.y, Float.random(in: 0.0 ..< 0.01))
                    cloud.transform.rotation = .init(angle: Float.random(in: 0.0 ..< .pi * 2), axis: .init(0.0, 0.0, 1.0))
                    cloud.scale = SIMD3(repeating: Float.random(in: 0.2 ..< 1))
                    cloud.components[OpacityComponent.self] = .init(opacity: 0.03)
                    textChildren.addChild(cloud)
                }
                pointAverage = pointAverage/Float(thinnedPoints.count)
                textChildren.position += pointAverage
                textChildren.transform.rotation = .init(angle: .pi, axis: .init(0.0, 1.0, 0.0))
            }
            debugPrint(model.parts.count)
        }
        
        
        return textEntity
    }
}

#Preview (immersionStyle: .mixed) {
    SkyView()
    
}
