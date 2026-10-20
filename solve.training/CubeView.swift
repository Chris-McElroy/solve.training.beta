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
    
    @State var cubies: [CubieView] = generateFacelet(.U)
    @State var facelets: [FaceletView] = generateFacelet(.U)
    
    var body: some View {
        RealityView { content in
            // figure out how to have facelet colors update dynamically (maybe with names???)
            
            // try changing perspective depth
            
            // have transparency toggle when hitting space
            
            let cubeView = generateCube()
            
            content.add(cubeView)
        } update: { content in
            content.entities.first!.children.forEach {
                ($0 as! ModelEntity).model?.materials.first!
            }
        }
        .background(.black)
    }
    
    func generateCube() -> some Entity {
        let base = generateBase()
        
        for x in -1...1 {
            for y in -1...1 {
                for z in -1...1 {
                    if (x, y, z) == (0, 0, 0) { continue }
                    base.addChild(generateCubie(x, y, z))
                }
            }
        }
        
        return base
    }
    
    func generateBase() -> some Entity {
        let mesh = MeshResource.generateBox(size: 1, cornerRadius: 0.04)
        let base = ModelEntity(mesh: mesh, materials: [SimpleMaterial(color: .clear, roughness: 1.0, isMetallic: true)])
        
        base.transform = Transform(pitch: Float(Angle(degrees: 27).radians), yaw: Float(Angle(degrees: -25).radians), roll: Float(Angle(degrees: -10).radians))
//        base.transform.rotation = simd_quatf(angle: Float(Angle(degrees: 45).radians), axis: [0,1,0])
//        base.transform.rotation *= simd_quatf(angle: Float(Angle(degrees: 25).radians), axis: normalize(SIMD3<Float>(1.0, 0.0, 1.0)))
        
        base.transform.scale = SIMD3<Float>(0.2, 0.2, 0.2)
        
        return base
    }
    
    func generateCubie(_ x: Int, _ y: Int, _ z: Int) -> some Entity {
        let mesh = MeshResource.generateBox(size: 1, cornerRadius: 0.1)
        let cubie = ModelEntity(mesh: mesh, materials: [SimpleMaterial(color: .black, roughness: 1.0, isMetallic: true)])
        
        // add relevant facelets
        if x ==  1 { cubie.addChild(generateFacelet(.R)) }
        else if x == -1 { cubie.addChild(generateFacelet(.L)) }
        
        if y ==  1  { cubie.addChild(generateFacelet(.U)) }
        else if y == -1 { cubie.addChild(generateFacelet(.D)) }
        
        if z ==  1 { cubie.addChild(generateFacelet(.F)) }
        else if z == -1 { cubie.addChild(generateFacelet(.B)) }
        
        // place cubie relative to base
        cubie.transform = Transform(translation: SIMD3<Float>(Float(x), Float(y), Float(z)))
        
        return cubie
    }
    
    func generateFacelet(_ face: Face) -> some Entity {
        let mesh: MeshResource = .generatePlane(width: 0.8, height: 0.8, cornerRadius: 0.15)
        let materials: [SimpleMaterial] = [SimpleMaterial(color: cube.update ? faceColor(face) : .brown, roughness: 1.0, isMetallic: true)] // for transparent mode: .withAlphaComponent(0.85)
        
        let facelet = ModelEntity(mesh: mesh, materials: materials)
        
        let faceletBack = ModelEntity(mesh: mesh, materials: materials)
        faceletBack.transform.rotation = simd_quatf(angle: .pi, axis: [0,1,0])
        
        facelet.addChild(faceletBack)
        
        
        switch face {
        case .U:
            facelet.transform.translation = SIMD3<Float>(x: 0, y: 0.501, z: 0)
            facelet.transform.rotation = simd_quatf(angle: -.pi/2, axis: [1,0,0])
        case .D:
            facelet.transform.translation = SIMD3<Float>(x: 0, y: -0.501, z: 0)
            facelet.transform.rotation = simd_quatf(angle: .pi/2, axis: [1,0,0])
        case .F:
            facelet.transform.translation = SIMD3<Float>(x: 0, y: 0, z: 0.501)
        case .B:
            facelet.transform.translation = SIMD3<Float>(x: 0, y: 0, z: -0.501)
        case .R:
            facelet.transform.translation = SIMD3<Float>(x: 0.501, y: 0, z: 0)
            facelet.transform.rotation = simd_quatf(angle: .pi/2, axis: [0,1,0])
        default:
            facelet.transform.translation = SIMD3<Float>(x: -0.501, y: 0, z: 0)
            facelet.transform.rotation = simd_quatf(angle: -.pi/2, axis: [0,1,0])
        }

        return facelet
    }
    
    func faceColor(_ face: Face) -> NSColor {
        switch face {
        case .U: return .yellow
        case .D: return .white
        case .F: return .blue
        case .B: return .green
        case .R: return .red
        default: return .orange
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
        entity.transform = CubieView.getTransform(for: cubie)
        
        Self.cubies.append(self)
    }
    
    static func toggle() {
        material = SimpleMaterial(color: clear ? .clear : .black, roughness: 1.0, isMetallic: true)
        clear.toggle()
        
        for cubie in cubies {
            cubie.entity.model?.materials = [material]
        }
    }
    
    static func getTransform(for cubie: Cubie) -> Transform {
        let value = cubie.rawValue > 12 ? cubie.rawValue : cubie.rawValue + 1
        
        let x = (value % 3) - 1
        let y = (value/3 % 3) - 1
        let z = (value/9) - 1
        
        return Transform(translation: SIMD3<Float>(Float(x), Float(y), Float(z)))
    }
}

class FaceletView {
    static var facelets: [FaceletView] = []
    
    var entity: ModelEntity
    var back: ModelEntity?
    var material: SimpleMaterial
    var facelet: Facelet
    
    static let mesh = MeshResource.generatePlane(width: 0.8, height: 0.8, cornerRadius: 0.15)
    
    init(_ facelet: Facelet) {
        self.facelet = facelet
        
        material = SimpleMaterial(color: Cube.main.color(of: facelet), roughness: 1.0, isMetallic: true)
        entity = ModelEntity(mesh: Self.mesh, materials: [material])
        
        if facelet.leftOrRight {
            let back = ModelEntity(mesh: Self.mesh, materials: [material])
            back.transform.rotation = simd_quatf(angle: .pi, axis: [0,1,0])
            self.back = back
            entity.addChild(back)
        }
        
        switch facelet.face {
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
}

extension ModelEntity {
    var piece: Int {
        Int(self.transform.translation.x)
    }
}
