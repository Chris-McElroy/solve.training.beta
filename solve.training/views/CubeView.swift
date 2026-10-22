//
//  CubeView.swift
//  solve.training
//
//  Created by chris on '26.10.17.
//

import SwiftUI
import RealityKit

struct CubeView: View {
    @ObservedObject var cube = Cube.main
    
    @State var center: CubieView
    
    var body: some View {
        RealityView { content in
            // try changing perspective depth
            
            // have transparency toggle when hitting space
            
            content.add(center.entity)
        } update: { content in
            // laterDO this is updating too much?
            for facelet in FaceletView.facelets {
                facelet.update()
            }
        }
        .background(.black)
    }
    
    init() {
        center = CubieView(.C)
        
        center.entity.transform = Transform(pitch: Float(Angle(degrees: 27).radians), yaw: Float(Angle(degrees: -25).radians), roll: Float(Angle(degrees: -10).radians))
        center.entity.transform.scale = SIMD3<Float>(0.2, 0.2, 0.2)
        
        for position in 0..<27 {
            if position == 13 { continue }
            center.entity.addChild(CubieView(Cubie.allCubies[position]).entity)
        }
    }
}

class CubieView {
    static var cubies: [CubieView] = []
    
    static let mesh = MeshResource.generateBox(size: 1, cornerRadius: 0.1)
    static var material: SimpleMaterial = SimpleMaterial(color: .black, roughness: 1.0, isMetallic: true)
    static var clear: Bool = false
    
    var entity: ModelEntity
    
    init(_ cubie: Cubie) {
        entity = ModelEntity(mesh: Self.mesh, materials: [Self.material])
        
        for facelet in cubie.facelets {
            entity.addChild(FaceletView(facelet).entity)
        }
        
        // place cubie relative to base
        entity.transform = Transform(translation: SIMD3<Float>(Float(cubie.x), Float(cubie.y), Float(cubie.z)))
        
        Self.cubies.append(self)
    }
    
    static func toggle() {
        material = SimpleMaterial(color: clear ? .clear : .black, roughness: 1.0, isMetallic: true)
        clear.toggle()
        
        for cubie in cubies {
            cubie.entity.model?.materials = [material]
        }
    }
}

class FaceletView {
    static var facelets: [FaceletView] = []
    var entity: ModelEntity
    var back: ModelEntity?
    var material: SimpleMaterial
    let facelet: Facelet
    let face: Face
    
    static let mesh = MeshResource.generatePlane(width: 0.8, height: 0.8, cornerRadius: 0.15)
    
    init(_ facelet: Facelet) {
        self.facelet = facelet
        face = Cubie.allCubies[facelet.position.rawValue].faces[facelet.faceIndex]
        
        material = SimpleMaterial(color: Self.color(of: facelet), roughness: 1.0, isMetallic: true)
        entity = ModelEntity(mesh: Self.mesh, materials: [material])
        
        if face == .L || face == .R {
            let back = ModelEntity(mesh: Self.mesh, materials: [material])
            back.transform.rotation = simd_quatf(angle: .pi, axis: [0,1,0])
            self.back = back
            entity.addChild(back)
        }
        
        switch face {
        case .U:
            entity.transform.translation = SIMD3<Float>(x: 0, y: 0.501, z: 0)
            entity.transform.rotation = simd_quatf(angle: -.pi/2, axis: [1,0,0])
        case .D:
            entity.transform.translation = SIMD3<Float>(x: 0, y: -0.501, z: 0)
            entity.transform.rotation = simd_quatf(angle: .pi/2, axis: [1,0,0])
        case .F:
            entity.transform.translation = SIMD3<Float>(x: 0, y: 0, z: 0.501)
        case .B:
            entity.transform.translation = SIMD3<Float>(x: 0, y: 0, z: -0.501)
        case .R:
            entity.transform.translation = SIMD3<Float>(x: 0.501, y: 0, z: 0)
            entity.transform.rotation = simd_quatf(angle: .pi/2, axis: [0,1,0])
        default:
            entity.transform.translation = SIMD3<Float>(x: -0.501, y: 0, z: 0)
            entity.transform.rotation = simd_quatf(angle: -.pi/2, axis: [0,1,0])
        }
        
        Self.facelets.append(self)
    }
    
    func update() {
        material = SimpleMaterial(color: Self.color(of: facelet), roughness: 1.0, isMetallic: true)
        entity.model?.materials = [material]
        back?.model?.materials = [material]
    }
    
    static func color(of facelet: Facelet) -> NSColor {
        let face = Cube.main.face(of: facelet)
        
        switch face {
        case .U: return .yellow
        case .D: return .white
        case .F: return .blue
        case .B: return .green
        case .R: return .red
        case .L: return .orange
        }
    }
}

extension ModelEntity {
    var piece: Int {
        Int(self.transform.translation.x)
    }
}
