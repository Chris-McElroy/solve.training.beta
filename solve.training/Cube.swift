//
//  Cube.swift
//  solve.training
//
//  Created by chris on '26.10.18.
//

import SwiftUI
import Combine

class Cube: ObservableObject {
    static var main: Cube = Cube()
    
    @Published var update: Bool = true
    var pieces: [Cubie: Piece]
    
    init() {
        pieces = [:]
        
        for x in -1...1 {
            for y in -1...1 {
                for z in -1...1 {
                    if x == 0 && y == 0 && z == 0 { continue }
                    let position = Cubie(x, y, z)
                    let orientation = position.faces.max()!
                    pieces[position] = Piece(position: position, orientation: orientation)
                }
            }
        }
    }
}

struct Cubie: Hashable {
    let x: Int
    let y: Int
    let z: Int
    
    init(_ x: Int, _ y: Int, _ z: Int) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    var facelets: [Facelet] {
        faces.map { Facelet(cubie: self, face: $0) }
    }
    
    var faces: [Face] {
        var faceList: [Face] = []
        
        if x == 1 { faceList.append(.R) }
        else if x == -1 { faceList.append(.L) }
        
        if y == 1 { faceList.append(.U) }
        else if y == -1 { faceList.append(.D) }
        
        if z == 1 { faceList.append(.F) }
        else if z == -1 { faceList.append(.B) }
        
        return faceList
    }
    
    var corner: Bool {
        x != 0 && y != 0 && z != 0
    }
    
    var edge: Bool {
        (x + y + z) & 1 == 0 // also includes base
    }
    
    var center: Bool {
        (x + y + z) & 1 == 1 && (x == 0 || y == 0 || z == 0)
    }
}

enum Face: Comparable {
    case U, D, F, B, R, L
}

struct Facelet {
    let cubie: Cubie
    let face: Face
}

struct Piece {
    let position: Cubie
    let orientation: Face
}
