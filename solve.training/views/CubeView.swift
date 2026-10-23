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
    let center: CubieView
    let cubies: [CubieView]
    
    var body: some View {
        RealityView { content in
            // try changing perspective depth https://stackoverflow.com/questions/78487437/how-can-i-add-a-perspectivecamera-in-realityview-on-visionos-using-realitykit
            
            // have transparency toggle when hitting space
            
            content.add(center.entity)
//            content.camera = .virtual
        } update: { content in
            // laterDO this is updating too much?
            let material = SimpleMaterial(color: cube.transparent ? .clear : .black, roughness: 1.0, isMetallic: true)
                
            for cubie in cubies {
                cubie.update(material: material)
            }
            
            if !cube.transparent {
                let highlight = SimpleMaterial(color: .systemPink, roughness: 1.0, isMetallic: true)
                for cubie in cube.highlights {
                    cubies[cubie.rawValue].entity.model?.materials = [highlight]
                }
            }
        }
        .background(.black)
    }
    
    init() {
        center = CubieView(.C)
        
        center.entity.transform = Transform(pitch: Float(Angle(degrees: 27).radians), yaw: Float(Angle(degrees: -25).radians), roll: Float(Angle(degrees: -10).radians))
        center.entity.transform.scale = SIMD3<Float>(0.2, 0.2, 0.2)
        
        var cubies: [CubieView] = []
        
        for position in 0..<27 {
            if position == 13 {
                cubies.append(center)
                continue
            }
            let newCubie = CubieView(Cubie.all[position])
            cubies.append(newCubie)
            center.entity.addChild(newCubie.entity)
        }
        
        self.cubies = cubies
    }
}

class CubieView {
    static let mesh = MeshResource.generateBox(size: 1, cornerRadius: 0.1)
    
    let entity: ModelEntity
    let facelets: [FaceletView]
    
    init(_ cubie: Cubie) {
        let material = SimpleMaterial(color: Cube.main.transparent ? .clear : .black, roughness: 1.0, isMetallic: true)
        entity = ModelEntity(mesh: Self.mesh, materials: [material])
        
        var facelets: [FaceletView] = []
        
        for facelet in cubie.facelets {
            let newFacelet = FaceletView(facelet)
            facelets.append(newFacelet)
            entity.addChild(newFacelet.entity)
        }
        
        self.facelets = facelets
        
        // place cubie relative to base
        entity.transform = Transform(translation: SIMD3<Float>(Float(cubie.x), Float(cubie.y), Float(cubie.z)))
    }
    
    func update(material: SimpleMaterial) {
        entity.model?.materials = [material]
        
        for facelet in facelets {
            facelet.update()
        }
    }
}

class FaceletView {
    var entity: ModelEntity
    var back: ModelEntity?
    var material: SimpleMaterial
    let facelet: Facelet
    let face: Face
    
    static let mesh = MeshResource.generatePlane(width: 0.8, height: 0.8, cornerRadius: 0.15)
    
    init(_ facelet: Facelet) {
        self.facelet = facelet
        face = Cubie.at(facelet.position).faces[facelet.faceIndex]
        
        material = SimpleMaterial(color: Self.color(of: facelet, face: face), roughness: 1.0, isMetallic: true)
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
    }
    
    func update() {
        let color = Self.color(of: facelet, face: face)
        material = SimpleMaterial(color: color, roughness: 1.0, isMetallic: true)
        entity.model?.materials = [material]
        back?.model?.materials = [material]
    }
    
    static func color(of facelet: Facelet, face: Face) -> NSColor {
        let faceColor = Cube.main.face(of: facelet)
        let dim: Bool = face == .D || face == .B || face == (Cube.main.right ? .L : .R)
        
        switch faceColor {
        case .U: return .yellow.withAlphaComponent(dim ? 0.85 : 1)
        case .D: return .white.withAlphaComponent(dim ? 0.85 : 1)
        case .F: return .blue.withAlphaComponent(dim ? 0.85 : 1)
        case .B: return .green.withAlphaComponent(dim ? 0.85 : 1)
        case .R: return .red.withAlphaComponent(dim ? 0.85 : 1)
        case .L: return .orange.withAlphaComponent(dim ? 0.85 : 1)
        }
    }
}

extension ModelEntity {
    var piece: Int {
        Int(self.transform.translation.x)
    }
}
