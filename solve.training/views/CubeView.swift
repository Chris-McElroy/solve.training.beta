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
            // if i wanted to change perspective depth
            // https://stackoverflow.com/questions/78487437/how-can-i-add-a-perspectivecamera-in-realityview-on-visionos-using-realitykit
            
            content.add(center.entity)
        } update: { content in
            // laterDO this is updating too much?
            let material = SimpleMaterial(color: cube.transparent ? .clear : .black, roughness: 1.0, isMetallic: true)
                
            for cubie in cubies {
                cubie.update(material: material)
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
    static let mesh = MeshResource.generateBox(size: 1, cornerRadius: 0.08)
    
    let entity: ModelEntity
    let position: Position
    let facelets: [FaceletView]
    
    init(_ cubie: Cubie) {
        self.position = cubie.position
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
        let highlight = Cube.main.pieces[position.rawValue].highlights
        if highlight.isEmpty || Cube.main.transparent {
            entity.model?.materials = [material]
        } else {
            let highlightMaterial = SimpleMaterial(color: .lightGray, roughness: 1.0, isMetallic: true)
            entity.model?.materials = [highlightMaterial]
        }
        
        for facelet in facelets {
            facelet.highlight = highlight.contains(facelet.facelet.faceIndex)
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
    var highlight: Bool = false
    
    static let mesh = MeshResource.generatePlane(width: 0.8, height: 0.8, cornerRadius: 0.15)
    
    init(_ facelet: Facelet) {
        self.facelet = facelet
        face = Cubie.at(facelet.position).faces[facelet.faceIndex]
        
        material = SimpleMaterial(color: Self.color(of: facelet, face: face, highlight: false), roughness: 1.0, isMetallic: false)
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
            entity.transform.rotation = simd_quatf(angle: -.pi/2, axis: [1,0,0])
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
        let color = Self.color(of: facelet, face: face, highlight: highlight)
        material = SimpleMaterial(color: color, roughness: 1.0, isMetallic: false)
        entity.model?.materials = [material]
        back?.model?.materials = [material]
    }
    
    static func color(of facelet: Facelet, face: Face, highlight: Bool) -> NSColor {
        let faceColor = Cube.main.face(of: facelet)
        var alpha: CGFloat = 1
        if face == .D || face == .B || face == (Cube.main.right ? .L : .R) {
            alpha = 0.85
        }
        if Cube.main.transparent {
            if !highlight {
                alpha = 0
            }
        }
        
        switch faceColor {
        case .U: return .yellow.withAlphaComponent(alpha)
        case .D: return .white.withAlphaComponent(alpha)
        case .F: return .blue.withAlphaComponent(alpha)
        case .B: return .green.withAlphaComponent(alpha)
        case .R: return .red.withAlphaComponent(alpha)
        case .L: return .orange.withAlphaComponent(alpha)
        }
    }
}

extension ModelEntity {
    var piece: Int {
        Int(self.transform.translation.x)
    }
}
