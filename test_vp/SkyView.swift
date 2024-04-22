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
            
            let url = Bundle.main.url(forResource: "sky", withExtension: "MOV")!
            let asset = AVURLAsset(url: url)
            let playerItem = AVPlayerItem(asset: asset)
            let player = AVPlayer()
            
            let skyVideoMaterial = VideoMaterial(avPlayer: player)
            
            let skySphere = Entity()
            skySphere.components.set(ModelComponent(mesh: .generateSphere(radius: 1E3), materials: [skyVideoMaterial]))
            skySphere.scale = .init(x: 1, y: 1, z: -1)
            let rotationAngle = Float(Angle(degrees: -130).radians)
            
            skySphere.transform.rotation = .init(angle: rotationAngle, axis: .init(1.0, 0.0, 0.0))
            
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
//            portal.position.y += 2.5
//            portal.position.z -= 1.5
            portal.position = SIMD3(0, 2.5, -1.5)
            portal.setScale(SIMD3(repeating: 0.001), relativeTo: nil)
            content.add(world)
            basePortals.addChild(portal)
            content.add(basePortals)
            
            rainbow.transform = Transform(pitch: .pi/2 * 1, yaw: .pi, roll: 0)
            
            rainbow.setScale(SIMD3(repeating: 7.5), relativeTo: nil)
            portal.addChild(rainbow)
            
            rainbow.position.z -= 0.01
            
            let textMesh = textGen(textString: "hello world")
            world.addChild(textMesh)
            textMesh.position = portal.position + 150 * SIMD3(0, 1, -1)
            textMesh.scale = SIMD3(repeating: 200)
            textMesh.look(at: SIMD3.zero, from: textMesh.position, relativeTo: nil)
            Task {
                expand (size: 1.3)
            }
        }
    }
    
    func textGen(textString: String) -> Entity {
          
          let materialVar = SimpleMaterial(color: .white, roughness: 0, isMetallic: false)
          
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
        let cubeMeshResource : MeshResource = .generatePlane(width: 0.020, height: 0.020)
//        let cubeMeshResource : MeshResource = .generateSphere(radius: 0.04)(width:

        debugPrint(textMeshResource.contents.models.count)
        var pointAverage:SIMD3<Float> = SIMD3.zero
        textMeshResource.contents.models.forEach {model in
            model.parts.forEach {part in
                positions = Array(part.positions)
//                positions = stride(from: 0, to: positions.count, by: 5).map { positions[$0] }
                
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
                
                
                for (key, bucketPoints) in buckets {
                    if bucketPoints.count > maxPointsPerBucket {
                        // Here we choose the first point, you could also choose a random point or calculate the centroid
                        thinnedPoints.append(bucketPoints[0])
                    } else {
                        thinnedPoints.append(contentsOf: bucketPoints)
                    }
                }
                

//                var material = SimpleMaterial()
//
//                material.color = try! .init(tint: .white.withAlphaComponent(0.9999),
//                                         texture: .init(.load(named: "cloud-lighter.png", in: nil)))
                
                var material = PhysicallyBasedMaterial()
                material.baseColor = try! .init(texture: .init(.load(named: "cloud-lighter.png", in: nil)))
//                material.blending = .init(blending: .transparent(opacity: 0.9999))
                material.opacityThreshold = 0.0 // IMPORTANT
                
                material.faceCulling = .none
//                material.emissiveColor.color = UIColor.white
                material.emissiveIntensity = 1
                
                for point in thinnedPoints {
                    pointAverage = pointAverage + point
                    let cloud = ModelEntity(mesh: cubeMeshResource, materials: [material])
//                    let cloud = rainbow.clone(recursive: true)
                   
//                    cloud.transform = Transform(pitch: .pi/2 * 1, yaw: .pi, roll: 0)
                    cloud.position = point
                    cloud.position = SIMD3(cloud.position.x, cloud.position.y, Float.random(in: 0.0 ..< 0.01))
                    cloud.transform.rotation = .init(angle: Float.random(in: 0.0 ..< .pi * 2), axis: .init(0.0, 0.0, 1.0))
                    cloud.scale = SIMD3(repeating: Float.random(in: 0.5 ..< 2))
                    
                    textChildren.addChild(cloud)
                }
                pointAverage = pointAverage/Float(thinnedPoints.count)
                textChildren.position += pointAverage
                textChildren.transform.rotation = .init(angle: .pi, axis: .init(0.0, 1.0, 0.0))
//                positions.forEach { position in
//                    let val = i
//                    let cubeMaterial = UnlitMaterial(color: UIColor(red: val, green: val, blue: val, alpha: 1))
//                    let thingy = ModelEntity(mesh: cubeMeshResource, materials: [cubeMaterial])
//                    thingy.position = position
//                    textEntity.addChild(thingy)
//                    i += 1.0/CGFloat(positions.count)
//                }
            }
            debugPrint(model.parts.count)
        }
        
        
          return textEntity
      }
}

#Preview (immersionStyle: .mixed) {
    SkyView()
    
}
