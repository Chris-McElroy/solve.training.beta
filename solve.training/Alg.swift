//
//  Alg.swift
//  solve.training
//
//  Created by chris on '26.10.16.
//

import Foundation

struct Alg {
    let moves: [Move]
    
    init(_ moves: [Move]) {
        self.moves = moves
    }
    
    init?(_ string: String) {
        var moves: [Move] = []
        let moveStrings = string.split(separator: " ")
        for moveString in moveStrings {
            guard let move = Move(String(moveString)) else { return nil }
            moves.append(move)
        }
        self.moves = moves
    }
    
    var string: String {
        moves.map { $0.string }.joined(separator: " ")
    }
    
    var inverse: Alg {
        Alg(moves.map { $0.inverse }.reversed())
    }
}

struct Move: Hashable {
    let slice: Slice
    let turn: Turn
    
    init(_ slice: Slice, _ turn: Turn) {
        self.slice = slice
        self.turn = turn
    }
    
    init?(_ string: String) {
        guard let sliceChr = string.first else { return nil }
        guard let slice = Slice(rawValue: String(sliceChr)) else { return nil }
        guard let turn = Turn(rawValue: String(string.dropFirst())) else { return nil }
        
        self.slice = slice
        self.turn = turn
    }
    
    var simplify: Move {
        Move(slice, turn.simplify)
    }

    var string: String {
        return slice.rawValue.appending(turn.rawValue)
    }

    var inverse: Move {
        return Move(slice, turn.inverse)
    }
    
    var input: [MoveInput] {
        return turn.input.map { MoveInput(slice, $0) }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(slice)
        hasher.combine(turn)
    }
}

enum Slice: String {
    case U = "U", D = "D", F = "F", B = "B", R = "R", L = "L"
    case u = "u", d = "d", f = "f", b = "b", r = "r", l = "l"
    
    case M = "M", S = "S", E = "E"
    case x = "x", y = "y", z = "z"
    
    var UDsym: Bool {
        switch self {
        case .U, .D, .u, .d, .M, .S, .x, .z: return false
        default: return true
        }
    }
    
    var LRsym: Bool {
        switch self {
        case .R, .L, .r, .l, .S, .E, .y, .z: return false
        default: return true
        }
    }
    
    var FBsym: Bool {
        switch self {
        case .F, .B, .f, .b, .M, .E, .x, .y: return false
        default: return true
        }
    }
    
    var opp: Slice {
        switch self {
        case .U: return .D
        case .D: return .U
        case .F: return .B
        case .B: return .F
        case .R: return .L
        case .L: return .R
            
        case .u: return .d
        case .d: return .u
        case .f: return .b
        case .b: return .f
        case .r: return .l
        case .l: return .r
        
        default: return self
        }
    }
}

enum Turn: String {
    case c1 = "", c2 = "2", c3 = "3"
    case p1 = "'", p2 = "2'", p3 = "3'"
    
    var inverse: Turn {
        switch self {
        case .c1: return .p1
        case .c2: return .p2
        case .c3: return .p3
        case .p1: return .c1
        case .p2: return .c2
        case .p3: return .c3
        }
    }
    
    var simplify: Turn {
        switch self {
        case .c1: return .c1
        case .c2: return .c2
        case .c3: return .p1
        case .p1: return .p1
        case .p2: return .c2
        case .p3: return .c1
        }
    }
    
    var input: [TurnInput] {
        switch self {
        case .c1: return [.c1]
        case .c2: return [.c2i1, .c2i2]
        case .c3: return [.c3i1, .c3i2, .c3i3]
        case .p1: return [.p1]
        case .p2: return [.p2i1, .p2i2]
        case .p3: return [.p3i1, .p3i2, .p3i3]
        }
    }
}

let moveShifts: [Move: [Cubie: Piece]] = [
    Move(.U, .c1): [.UFR: .UBR, .UF: .UR, .UFL: .UFR, .UR: .UB, .UL: .UF, .UBR: .UBL, .UB: .UL, .UBL: .UFL]
]
