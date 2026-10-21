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
                    pieces[position] = Piece(position)
                }
            }
        }
    }
    
    func color(of facelet: Facelet) -> NSColor {
        face(of: facelet).color
    }
    
    func face(of facelet: Facelet) -> Face {
        guard let piece = pieces[facelet.cubie] else { return .D }
        return piece.cubie.faces[(piece.orientation + facelet.faceIndex) % piece.cubie.faces.count]
    }
    
    func exec(_ move: Move) {
        guard let shift = moveShifts[move.simplify] else { return }
        var newPieces = pieces
        
        for (position, piece) in shift {
            newPieces[position] = pieces[piece.cubie]! + piece.orientation
        }
        
        pieces = newPieces
    }
}

struct Cubie: Hashable {
    let x: Int
    let y: Int
    let z: Int
    let faces: [Face]
    
    init(_ x: Int, _ y: Int, _ z: Int) {
        self.x = x
        self.y = y
        self.z = z
        
        var faceList: [Face] = []
        
        if y == 1 { faceList.append(.U) }
        else if y == -1 { faceList.append(.D) }
        
        if z == 1 { faceList.append(.F) }
        else if z == -1 { faceList.append(.B) }
        
        if x == 1 { faceList.append(.R) }
        else if x == -1 { faceList.append(.L) }
        
        if faceList.count == 3 && (x + y + z)&2 == 2 {
            faceList.insert(faceList.removeLast(), at: 1)
        }
        
        faces = faceList
    }
    
    var facelets: [Facelet] {
        (0..<faces.count).map { Facelet(self, facing: $0) }
    }
    
    var corner: Bool {
        faces.count == 3
    }
    
    var edge: Bool {
        faces.count == 2
    }
    
    var center: Bool {
        faces.count == 1
    }
    
    static func == (lhs: Cubie, rhs: Cubie) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
        hasher.combine(z)
    }
    
    static let UFR: Cubie = Cubie(1, 1, 1)
    static let UF: Cubie = Cubie(0, 1, 1)
    static let UFL: Cubie = Cubie(-1, 1, 1)
    static let UR: Cubie = Cubie(1, 1, 0)
    static let U: Cubie = Cubie(0, 1, 0)
    static let UL: Cubie = Cubie(-1, 1, 0)
    static let UBR: Cubie = Cubie(1, 1, -1)
    static let UB: Cubie = Cubie(0, 1, -1)
    static let UBL: Cubie = Cubie(-1, 1, -1)
    
    static let FR: Cubie = Cubie(1, 0, 1)
    static let F: Cubie = Cubie(0, 0, 1)
    static let FL: Cubie = Cubie(-1, 0, 1)
    static let R: Cubie = Cubie(1, 0, 0)
    static let L: Cubie = Cubie(-1, 0, 0)
    static let BR: Cubie = Cubie(1, 0, -1)
    static let B: Cubie = Cubie(0, 0, -1)
    static let BL: Cubie = Cubie(-1, 0, -1)
    
    static let DFR: Cubie = Cubie(1, -1, 1)
    static let DF: Cubie = Cubie(0, -1, 1)
    static let DFL: Cubie = Cubie(-1, -1, 1)
    static let DR: Cubie = Cubie(1, -1, 0)
    static let D: Cubie = Cubie(0, -1, 0)
    static let DL: Cubie = Cubie(-1, -1, 0)
    static let DBR: Cubie = Cubie(1, -1, -1)
    static let DB: Cubie = Cubie(0, -1, -1)
    static let DBL: Cubie = Cubie(-1, -1, -1)
}

enum Face: Comparable {
    case U, D, F, B, R, L
    
    var color: NSColor {
        switch self {
        case .U: return .yellow
        case .D: return .white
        case .F: return .blue
        case .B: return .green
        case .R: return .red
        case .L: return .orange
        }
    }
}

struct Facelet {
    let cubie: Cubie
    let faceIndex: Int
    let face: Face
    
    init(_ cubie: Cubie, facing faceIndex: Int) {
        self.cubie = cubie
        self.faceIndex = faceIndex
        self.face = cubie.faces[faceIndex]
    }
}

struct Piece {
    let cubie: Cubie
    var orientation: Int {
        get {
            return _orientation
        }
    }
    
    @State private var _orientation: Int
    
    init(_ cubie: Cubie) {
        self.cubie = cubie
        _orientation = 0
    }
    
    static func +(lhs: inout Piece, rhs: Int) -> Piece {
        lhs._orientation = (lhs._orientation + rhs) % lhs.cubie.faces.count
        return lhs
    }
    
    func c() {
        _orientation = (_orientation + 1) % 3
    }
    
    func p() {
        _orientation = (_orientation + 2) % 3
    }
    
    func f() {
        _orientation ^= 1
    }
    
    static let UFR: Piece = Piece(.UFR)
    static let UF: Piece = Piece(.UF)
    static let UFL: Piece = Piece(.UFL)
    static let UR: Piece = Piece(.UR)
    static let U: Piece = Piece(.U)
    static let UL: Piece = Piece(.UL)
    static let UBR: Piece = Piece(.UBR)
    static let UB: Piece = Piece(.UB)
    static let UBL: Piece = Piece(.UBL)
    
    static let FR: Piece = Piece(.FR)
    static let F: Piece = Piece(.F)
    static let FL: Piece = Piece(.FL)
    static let R: Piece = Piece(.R)
    static let L: Piece = Piece(.L)
    static let BR: Piece = Piece(.BR)
    static let B: Piece = Piece(.B)
    static let BL: Piece = Piece(.BL)
    
    static let DFR: Piece = Piece(.DFR)
    static let DF: Piece = Piece(.DF)
    static let DFL: Piece = Piece(.DFL)
    static let DR: Piece = Piece(.DR)
    static let D: Piece = Piece(.D)
    static let DL: Piece = Piece(.DL)
    static let DBR: Piece = Piece(.DBR)
    static let DB: Piece = Piece(.DB)
    static let DBL: Piece = Piece(.DBL)
}
