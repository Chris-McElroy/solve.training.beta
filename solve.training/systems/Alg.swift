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
    Move(.U, .c1): [
        .UFR: .UBR, .UBR: .UBL, .UBL: .UFL, .UFL: .UFR,
        .UF: .UR, .UR: .UB, .UB: .UL, .UL: .UF,
    ],
    Move(.U, .c2): [
        .UFR: .UBL, .UBL: .UFR,
        .UFL: .UBR, .UBR: .UFL,
        .UF: .UB, .UB: .UF,
        .UR: .UL, .UL: .UR,
    ],
    Move(.U, .p1): [
        .UFR: .UFL, .UFL: .UBL, .UBL: .UBR, .UBR: .UFR,
        .UF: .UL, .UL: .UB, .UB: .UR, .UR: .UF,
    ],
    
    Move(.D, .c1): [
        .DFR: .DFL, .DFL: .DBL, .DBL: .DBR, .DBR: .DFR,
        .DF: .DL, .DL: .DB, .DB: .DR, .DR: .DF,
    ],
    Move(.D, .c2): [
        .DFR: .DBL, .DBL: .DFR,
        .DFL: .DBR, .DBR: .DFL,
        .DF: .DB, .DB: .DF,
        .DR: .DL, .DL: .DR,
    ],
    Move(.D, .p1): [
        .DFR: .DBR, .DBR: .DBL, .DBL: .DFL, .DFL: .DFR,
        .DF: .DR, .DR: .DB, .DB: .DL, .DL: .DF,
    ],
    
    Move(.F, .c1): [
        .UFR: .UFL, .UFL: .DFL, .DFL: .DFR, .DFR: .UFR,
        .UF: .FL, .FL: .DF, .DF: .FR, .FR: .UF,
    ],
    Move(.F, .c2): [
        .UFR: .DFL, .DFL: .UFR,
        .UFL: .DFR, .DFR: .UFL,
        .UF: .DF, .DF: .UF,
        .FR: .FL, .FL: .FR,
    ],
    Move(.F, .p1): [
        .UFR: .DFR, .DFR: .DFL, .DFL: .UFL, .UFL: .UFR,
        .UF: .FR, .FR: .DF, .DF: .FL, .FL: .UF,
    ],
    
    Move(.B, .c1): [
        .UBR: .DBR, .DBR: .DBL, .DBL: .UBL, .UBL: .UBR,
        .UB: .BR, .BR: .DB, .DB: .BL, .BL: .UB,
    ],
    Move(.B, .c2): [
        .UBR: .DBL, .DBL: .UBR,
        .UBL: .DBR, .DBR: .UBL,
        .UB: .DB, .DB: .UB,
        .BR: .BL, .BL: .BR,
    ],
    Move(.B, .p1): [
        .UBR: .UBL, .UBL: .DBL, .DBL: .DBR, .DBR: .UBR,
        .UB: .BL, .BL: .DB, .DB: .BR, .BR: .UB,
    ],
    
    Move(.R, .c1): [
        .UFR: .DFR, .DFR: .DBR, .DBR: .UBR, .UBR: .UFR,
        .UR: .FR, .FR: .DR, .DR: .BR, .BR: .UR,
    ],
    Move(.R, .c2): [
        .UFR: .DBR, .DBR: .UFR,
        .UBR: .DFR, .DFR: .UBR,
        .UR: .DR, .DR: .UR,
        .FR: .BR, .BR: .FR,
    ],
    Move(.R, .p1): [
        .UFR: .UBR, .UBR: .DBR, .DBR: .DFR, .DFR: .UFR,
        .UR: .BR, .BR: .DR, .DR: .FR, .FR: .UR,
    ],
    
    Move(.L, .c1): [
        .UFL: .UBL, .UBL: .DBL, .DBL: .DFL, .DFL: .UFL,
        .UL: .BL, .BL: .DL, .DL: .FL, .FL: .UL,
    ],
    Move(.L, .c2): [
        .UFL: .DBL, .DBL: .UFL,
        .UBL: .DFL, .DFL: .UBL,
        .UL: .DL, .DL: .UL,
        .FL: .BL, .BL: .FL,
    ],
    Move(.L, .p1): [
        .UFL: .DFL, .DFL: .DBL, .DBL: .UBL, .UBL: .UFL,
        .UL: .FL, .FL: .DL, .DL: .BL, .BL: .UL,
    ],
    
    Move(.u, .c1): [
        .UFR: .UBR, .UBR: .UBL, .UBL: .UFL, .UFL: .UFR,
        .UF: .UR, .UR: .UB, .UB: .UL, .UL: .UF,
        .FR: .BR, .BR: .BL, .BL: .FL, .FL: .FR,
        .F: .R, .R: .B, .B: .L, .L: .F,
    ],
    Move(.u, .c2): [
        .UFR: .UBL, .UBL: .UFR,
        .UFL: .UBR, .UBR: .UFL,
        .UF: .UB, .UB: .UF,
        .UR: .UL, .UL: .UR,
        .FR: .BL, .BL: .FR,
        .FL: .BR, .BR: .FL,
        .F: .B, .B: .F,
        .R: .L, .L: .R,
    ],
    Move(.u, .p1): [
        .UFR: .UFL, .UFL: .UBL, .UBL: .UBR, .UBR: .UFR,
        .UF: .UL, .UL: .UB, .UB: .UR, .UR: .UF,
    ],
]
