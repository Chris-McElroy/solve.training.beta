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
    private static let solvedPieces: [Piece] = (0..<27).map { Piece($0) }
    
    @Published var update: Bool = true
    var pieces: [Piece] = Cube.solvedPieces
    var transparent: Bool = false
    var right: Bool = true
    
    func face(of facelet: Facelet) -> Face {
        pieces[facelet.position.rawValue].face(of: facelet)
    }
    
    func exec(_ move: Move) {
        guard let shifts = moveShifts[move.simplify] else { return }
        var newPieces = pieces
        
        for (position, shift) in shifts {
            newPieces[position.rawValue] = pieces[shift.oldPos.rawValue] + shift.rotation
        }
        
        pieces = newPieces
    }
    
    func exec(_ alg: Alg) {
        for move in alg.moves {
            exec(move)
        }
    }
    
    func undo(_ move: Move) {
        exec(move.inverse)
    }
    
    func scramble(_ alg: Alg) {
        for move in alg.inverse.moves {
            exec(move)
        }
    }
    
    func reset(right: Bool = true) {
        pieces = Cube.solvedPieces
        transparent = false
        self.right = right
    }
}

class Cubie {
    let position: Position
    
    let x: Int
    let y: Int
    let z: Int
    
    let m: Bool
    let e: Bool
    let s: Bool
    
    let corner: Bool
    let edge: Bool
    let center: Bool
    
    let faces: [Face]
    
    let facelets: [Facelet]
    
    private init(_ position: Position) {
        self.position = position
        
        let n = position.rawValue
        
        x = 1 - (n % 3)
        y = 1 - (n/9)
        z = 1 - ((n/3) % 3)
        
        m = x == 0
        e = y == 0
        s = z == 0
        
        var faceList: [Face] = []
        
        if y == 1 { faceList.append(.U) }
        else if y == -1 { faceList.append(.D) }
        
        if z == 1 { faceList.append(.F) }
        else if z == -1 { faceList.append(.B) }
        
        if x == 1 { faceList.append(.R) }
        else if x == -1 { faceList.append(.L) }
        
        if faceList.count == 3 && (x + y + z)&2 != 2 {
            faceList.insert(faceList.removeLast(), at: 1)
        }
        
        faces = faceList
        
        corner = faces.count == 3
        edge = faces.count == 2
        center = faces.count == 1
        
        facelets = (0..<faces.count).map { Facelet(position, facing: $0) }
    }
    
    static let UFR: Cubie = Cubie(.UFR)
    static let UF: Cubie = Cubie(.UF)
    static let UFL: Cubie = Cubie(.UFL)
    static let UR: Cubie = Cubie(.UR)
    static let U: Cubie = Cubie(.U)
    static let UL: Cubie = Cubie(.UL)
    static let UBR: Cubie = Cubie(.UBR)
    static let UB: Cubie = Cubie(.UB)
    static let UBL: Cubie = Cubie(.UBL)
    
    static let FR: Cubie = Cubie(.FR)
    static let F: Cubie = Cubie(.F)
    static let FL: Cubie = Cubie(.FL)
    static let R: Cubie = Cubie(.R)
    static let C: Cubie = Cubie(.C)
    static let L: Cubie = Cubie(.L)
    static let BR: Cubie = Cubie(.BR)
    static let B: Cubie = Cubie(.B)
    static let BL: Cubie = Cubie(.BL)
    
    static let DFR: Cubie = Cubie(.DFR)
    static let DF: Cubie = Cubie(.DF)
    static let DFL: Cubie = Cubie(.DFL)
    static let DR: Cubie = Cubie(.DR)
    static let D: Cubie = Cubie(.D)
    static let DL: Cubie = Cubie(.DL)
    static let DBR: Cubie = Cubie(.DBR)
    static let DB: Cubie = Cubie(.DB)
    static let DBL: Cubie = Cubie(.DBL)
    
    static let all: [Cubie] = [
        .UFR, .UF, .UFL, .UR, .U, .UL, .UBR, .UB, .UBL,
        .FR, .F, .FL, .R, .C, .L, .BR, .B, .BL,
        .DFR, .DF, .DFL, .DR, .D, .DL, .DBR, .DB, .DBL
    ]
    
    static func at(_ position: Position) -> Cubie {
        all[position.rawValue]
    }
}

enum Position: Int {
    case UFR = 0, UF = 1, UFL = 2, UR = 3, U = 4, UL = 5, UBR = 6, UB = 7, UBL = 8
    case FR = 9, F = 10, FL = 11, R = 12, C = 13, L = 14, BR = 15, B = 16, BL = 17
    case DFR = 18, DF = 19, DFL = 20, DR = 21, D = 22, DL = 23, DBR = 24, DB = 25, DBL = 26
}

enum Face {
    case U, D, F, B, R, L
}

struct Facelet: Hashable {
    let position: Position
    let faceIndex: Int
    
    init(_ position: Position, facing faceIndex: Int) {
        self.position = position
        self.faceIndex = faceIndex
    }
}

struct Piece {
    let position: Position
    var orientation: Int {
        get {
            return _orientation
        }
    }
    
    private var _orientation: Int

    var highlights: [Int]
    
    init(_ position: Position, highlights: [Int] = []) {
        self.position = position
        _orientation = 0
        self.highlights = highlights
    }
    
    init(_ position: Int, highlights: [Int] = []) {
        self.position = Position(rawValue: position)!
        _orientation = 0
        self.highlights = highlights
    }
    
    init(_ position: Position, o: Int, highlights: [Int] = []) {
        self.position = position
        _orientation = o
        self.highlights = highlights
    }
    
    static func +(lhs: Piece, rhs: Int) -> Piece {
        return Piece(lhs.position, o: (lhs._orientation + rhs) % Cubie.at(lhs.position).faces.count, highlights: lhs.highlights)
    }
    
    mutating func c() {
        _orientation = (_orientation + 1) % 3
    }
    
    mutating func p() {
        _orientation = (_orientation + 2) % 3
    }
    
    mutating func f() {
        _orientation ^= 1
    }
    
    func face(of facelet: Facelet) -> Face {
        let cubie = Cubie.at(position)
        return cubie.faces[(orientation + facelet.faceIndex) % cubie.faces.count]
    }
    
    static let UFR: Piece = Piece(.UFR)
    static let UFR_c: Piece = Piece(.UFR, o: 1)
    static let UFR_p: Piece = Piece(.UFR, o: 2)
    static let UF: Piece = Piece(.UF)
    static let UF_f: Piece = Piece(.UF, o: 1)
    static let UFL: Piece = Piece(.UFL)
    static let UFL_c: Piece = Piece(.UFL, o: 1)
    static let UFL_p: Piece = Piece(.UFL, o: 2)
    static let UR: Piece = Piece(.UR)
    static let UR_f: Piece = Piece(.UR, o: 1)
    static let U: Piece = Piece(.U)
    static let UL: Piece = Piece(.UL)
    static let UL_f: Piece = Piece(.UL, o: 1)
    static let UBR: Piece = Piece(.UBR)
    static let UBR_c: Piece = Piece(.UBR, o: 1)
    static let UBR_p: Piece = Piece(.UBR, o: 2)
    static let UB: Piece = Piece(.UB)
    static let UB_f: Piece = Piece(.UB, o: 1)
    static let UBL: Piece = Piece(.UBL)
    static let UBL_c: Piece = Piece(.UBL, o: 1)
    static let UBL_p: Piece = Piece(.UBL, o: 2)
    
    static let FR: Piece = Piece(.FR)
    static let FR_f: Piece = Piece(.FR, o: 1)
    static let F: Piece = Piece(.F)
    static let FL: Piece = Piece(.FL)
    static let FL_f: Piece = Piece(.FL, o: 1)
    static let R: Piece = Piece(.R)
    static let L: Piece = Piece(.L)
    static let BR: Piece = Piece(.BR)
    static let BR_f: Piece = Piece(.BR, o: 1)
    static let B: Piece = Piece(.B)
    static let BL: Piece = Piece(.BL)
    static let BL_f: Piece = Piece(.BL, o: 1)
    
    static let DFR: Piece = Piece(.DFR)
    static let DFR_c: Piece = Piece(.DFR, o: 1)
    static let DFR_p: Piece = Piece(.DFR, o: 2)
    static let DF: Piece = Piece(.DF)
    static let DF_f: Piece = Piece(.DF, o: 1)
    static let DFL: Piece = Piece(.DFL)
    static let DFL_c: Piece = Piece(.DFL, o: 1)
    static let DFL_p: Piece = Piece(.DFL, o: 2)
    static let DR: Piece = Piece(.DR)
    static let DR_f: Piece = Piece(.DR, o: 1)
    static let D: Piece = Piece(.D)
    static let DL: Piece = Piece(.DL)
    static let DL_f: Piece = Piece(.DL, o: 1)
    static let DBR: Piece = Piece(.DBR)
    static let DBR_c: Piece = Piece(.DBR, o: 1)
    static let DBR_p: Piece = Piece(.DBR, o: 2)
    static let DB: Piece = Piece(.DB)
    static let DB_f: Piece = Piece(.DB, o: 1)
    static let DBL: Piece = Piece(.DBL)
    static let DBL_c: Piece = Piece(.DBL, o: 1)
    static let DBL_p: Piece = Piece(.DBL, o: 2)
}
