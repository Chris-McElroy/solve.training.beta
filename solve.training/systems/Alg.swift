//
//  Alg.swift
//  solve.training
//
//  Created by chris on '26.10.16.
//

import Foundation

struct Alg: Equatable {
    var moves: [Move]
    
    init(_ moves: [Move] = []) {
        self.moves = moves
    }
    
    init?(_ string: String) {
//        var premoves: [Move] = []
        let moveStrings = string.split(separator: " ")
//        if string.starts(with: "(") {
//            guard let prestring = string.dropFirst().split(separator: ")").first else { return nil }
//            for moveString in prestring {
//                guard let move = Move(String(moveString)) else { return nil }
//                premoves.append(move)
//            }
//            self.premoves = premoves
//        } else {
//            self.premoves = []
//        }
        moves = []
        for moveString in moveStrings {
            guard let move = Move(String(moveString)) else { return nil }
            moves.append(move)
        }
    }
    
    var string: String {
        moves.map { $0.string }.joined(separator: " ")
    }
    
    var inverse: Alg {
        Alg(moves.map { $0.inverse }.reversed())
    }
    
    static let AUFs: [Alg] = [Alg(), Alg([Move(.U, .c1)]), Alg([Move(.U, .c2)]), Alg([Move(.U, .p1)])]
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
    
    static let myOrientations: [[Move?]] = [
//        [Move(.x, .c1)], // for Tim
        [nil, Move(.y, .c1), Move(.y, .c2), Move(.y, .p1)],
        [nil, Move(.x, .c2)],
    ]
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

struct MoveInput {
    let slice: Slice
    let turn: TurnInput
    let move: Move
    
    init(_ slice: Slice, _ turn: TurnInput) {
        self.slice = slice
        self.turn = turn
        self.move = Move(slice, turn.turn)
    }
    
    var string: String {
        if turn == .c1 {
            return slice.rawValue + " "
        } else if turn == .p1 {
            return slice.rawValue + "' "
        } else if turn == .c2i2 {
            return "2 "
        } else if turn == .p2i2 {
            return "2' "
        } else if turn == .c3i2 || turn == .p3i2 {
            return ""
        } else if turn == .c3i3 {
            return "3 "
        } else if turn == .p3i3 {
            return "3' "
        } else {
            return slice.rawValue
        }
    }
    
    var inputChr: String {
        switch slice {
        case .U: return turn.c ? "j" : "f"
        case .D: return turn.c ? "so" : "lw"
        case .F: return turn.c ? "h" : "g"
        case .B: return turn.c ? "y" : "u"
        case .R: return turn.c ? "i" : "k"
        case .L: return turn.c ? "d" : "e"
            
        case .u: return turn.c ? "J" : "F"
        case .d: return turn.c ? "SO" : "LW"
        case .r: return turn.c ? "I" : "K"
        case .l: return turn.c ? "D" : "E"
        case .f: return turn.c ? "H" : "G"
        case .b: return turn.c ? "Y" : "U"
            
        case .M: return turn.c ? "z." : "x'"
        case .S: return turn.c ? "n" : "b"
        case .E: return turn.c ? "c" : ","
            
        case .x: return turn.c ? "r" : "v"
        case .y: return turn.c ? ";p" : "aq"
        case .z: return turn.c ? "m" : "t"
        }
    }
    
    static let inputDict: [Character: Move] = [
        "j": Move(.U, .c1),
        "f": Move(.U, .p1),
        
        "s": Move(.D, .c1),
        "o": Move(.D, .c1),
        "l": Move(.D, .p1),
        "w": Move(.D, .p1),
        
        "h": Move(.F, .c1),
        "g": Move(.F, .p1),
        
        "y": Move(.B, .c1),
        "u": Move(.B, .p1),
        
        "i": Move(.R, .c1),
        "k": Move(.R, .p1),
        
        "d": Move(.L, .c1),
        "e": Move(.L, .p1),
        
        
        
        "J": Move(.u, .c1),
        "F": Move(.u, .p1),
        
        "S": Move(.d, .c1),
        "O": Move(.d, .c1),
        "L": Move(.d, .p1),
        "W": Move(.d, .p1),
        
        "H": Move(.f, .c1),
        "G": Move(.f, .p1),
        
        "Y": Move(.b, .c1),
        "U": Move(.b, .p1),
        
        "I": Move(.r, .c1),
        "K": Move(.r, .p1),
        
        "D": Move(.l, .c1),
        "E": Move(.l, .p1),
        
        
        
        "z": Move(.M, .c1),
        ".": Move(.M, .c1),
        "x": Move(.M, .p1),
        "'": Move(.M, .p1),
        
        "n": Move(.S, .c1),
        "b": Move(.S, .p1),
        
        "c": Move(.E, .c1),
        ",": Move(.E, .p1),
        
        
        
        "r": Move(.x, .c1),
        "v": Move(.x, .p1),
        
        ";": Move(.y, .c1),
        "p": Move(.y, .c1),
        "a": Move(.y, .p1),
        "q": Move(.y, .p1),
        
        "m": Move(.z, .c1),
        "t": Move(.z, .p1),
    ]
}

enum TurnInput {
    case c1, c2i1, c2i2, c3i1, c3i2, c3i3
    case p1, p2i1, p2i2, p3i1, p3i2, p3i3
    
    var c: Bool {
        return self == .c1 || self == .c2i1 || self == .c2i2 || self == .c3i1 || self == .c3i2 || self == .c3i3
    }
    
    var turn: Turn {
        return c ? .c1 : .p1
    }
}


struct Shift: Equatable {
    let oldPos: Position
    let rotation: Int
    
    init(oldPos: Position, rotation: Int = 0) {
        self.oldPos = oldPos
        self.rotation = rotation
    }
    
    static let UFR: Shift = Shift(oldPos: .UFR)
    static let UFR_c: Shift = Shift(oldPos: .UFR, rotation: 1)
    static let UFR_p: Shift = Shift(oldPos: .UFR, rotation: 2)
    static let UF: Shift = Shift(oldPos: .UF)
    static let UF_f: Shift = Shift(oldPos: .UF, rotation: 1)
    static let UFL: Shift = Shift(oldPos: .UFL)
    static let UFL_c: Shift = Shift(oldPos: .UFL, rotation: 1)
    static let UFL_p: Shift = Shift(oldPos: .UFL, rotation: 2)
    static let UR: Shift = Shift(oldPos: .UR)
    static let UR_f: Shift = Shift(oldPos: .UR, rotation: 1)
    static let U: Shift = Shift(oldPos: .U)
    static let UL: Shift = Shift(oldPos: .UL)
    static let UL_f: Shift = Shift(oldPos: .UL, rotation: 1)
    static let UBR: Shift = Shift(oldPos: .UBR)
    static let UBR_c: Shift = Shift(oldPos: .UBR, rotation: 1)
    static let UBR_p: Shift = Shift(oldPos: .UBR, rotation: 2)
    static let UB: Shift = Shift(oldPos: .UB)
    static let UB_f: Shift = Shift(oldPos: .UB, rotation: 1)
    static let UBL: Shift = Shift(oldPos: .UBL)
    static let UBL_c: Shift = Shift(oldPos: .UBL, rotation: 1)
    static let UBL_p: Shift = Shift(oldPos: .UBL, rotation: 2)
    
    static let FR: Shift = Shift(oldPos: .FR)
    static let FR_f: Shift = Shift(oldPos: .FR, rotation: 1)
    static let F: Shift = Shift(oldPos: .F)
    static let FL: Shift = Shift(oldPos: .FL)
    static let FL_f: Shift = Shift(oldPos: .FL, rotation: 1)
    static let R: Shift = Shift(oldPos: .R)
    static let L: Shift = Shift(oldPos: .L)
    static let BR: Shift = Shift(oldPos: .BR)
    static let BR_f: Shift = Shift(oldPos: .BR, rotation: 1)
    static let B: Shift = Shift(oldPos: .B)
    static let BL: Shift = Shift(oldPos: .BL)
    static let BL_f: Shift = Shift(oldPos: .BL, rotation: 1)
    
    static let DFR: Shift = Shift(oldPos: .DFR)
    static let DFR_c: Shift = Shift(oldPos: .DFR, rotation: 1)
    static let DFR_p: Shift = Shift(oldPos: .DFR, rotation: 2)
    static let DF: Shift = Shift(oldPos: .DF)
    static let DF_f: Shift = Shift(oldPos: .DF, rotation: 1)
    static let DFL: Shift = Shift(oldPos: .DFL)
    static let DFL_c: Shift = Shift(oldPos: .DFL, rotation: 1)
    static let DFL_p: Shift = Shift(oldPos: .DFL, rotation: 2)
    static let DR: Shift = Shift(oldPos: .DR)
    static let DR_f: Shift = Shift(oldPos: .DR, rotation: 1)
    static let D: Shift = Shift(oldPos: .D)
    static let DL: Shift = Shift(oldPos: .DL)
    static let DL_f: Shift = Shift(oldPos: .DL, rotation: 1)
    static let DBR: Shift = Shift(oldPos: .DBR)
    static let DBR_c: Shift = Shift(oldPos: .DBR, rotation: 1)
    static let DBR_p: Shift = Shift(oldPos: .DBR, rotation: 2)
    static let DB: Shift = Shift(oldPos: .DB)
    static let DB_f: Shift = Shift(oldPos: .DB, rotation: 1)
    static let DBL: Shift = Shift(oldPos: .DBL)
    static let DBL_c: Shift = Shift(oldPos: .DBL, rotation: 1)
    static let DBL_p: Shift = Shift(oldPos: .DBL, rotation: 2)
}

let moveShifts: [Move: [Position: Shift]] = [
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
        .UFR: .UFL_c, .UFL: .DFL_p, .DFL: .DFR_c, .DFR: .UFR_p,
        .UF: .FL_f, .FL: .DF_f, .DF: .FR_f, .FR: .UF_f,
    ],
    Move(.F, .c2): [
        .UFR: .DFL, .DFL: .UFR,
        .UFL: .DFR, .DFR: .UFL,
        .UF: .DF, .DF: .UF,
        .FR: .FL, .FL: .FR,
    ],
    Move(.F, .p1): [
        .UFR: .DFR_c, .DFR: .DFL_p, .DFL: .UFL_c, .UFL: .UFR_p,
        .UF: .FR_f, .FR: .DF_f, .DF: .FL_f, .FL: .UF_f,
    ],
    
    Move(.B, .c1): [
        .UBR: .DBR_p, .DBR: .DBL_c, .DBL: .UBL_p, .UBL: .UBR_c,
        .UB: .BR_f, .BR: .DB_f, .DB: .BL_f, .BL: .UB_f,
    ],
    Move(.B, .c2): [
        .UBR: .DBL, .DBL: .UBR,
        .UBL: .DBR, .DBR: .UBL,
        .UB: .DB, .DB: .UB,
        .BR: .BL, .BL: .BR,
    ],
    Move(.B, .p1): [
        .UBR: .UBL_p, .UBL: .DBL_c, .DBL: .DBR_p, .DBR: .UBR_c,
        .UB: .BL_f, .BL: .DB_f, .DB: .BR_f, .BR: .UB_f,
    ],
    
    Move(.R, .c1): [
        .UFR: .DFR_p, .DFR: .DBR_c, .DBR: .UBR_p, .UBR: .UFR_c,
        .UR: .FR, .FR: .DR, .DR: .BR, .BR: .UR,
    ],
    Move(.R, .c2): [
        .UFR: .DBR, .DBR: .UFR,
        .UBR: .DFR, .DFR: .UBR,
        .UR: .DR, .DR: .UR,
        .FR: .BR, .BR: .FR,
    ],
    Move(.R, .p1): [
        .UFR: .UBR_p, .UBR: .DBR_c, .DBR: .DFR_p, .DFR: .UFR_c,
        .UR: .BR, .BR: .DR, .DR: .FR, .FR: .UR,
    ],
    
    Move(.L, .c1): [
        .UFL: .UBL_c, .UBL: .DBL_p, .DBL: .DFL_c, .DFL: .UFL_p,
        .UL: .BL, .BL: .DL, .DL: .FL, .FL: .UL,
    ],
    Move(.L, .c2): [
        .UFL: .DBL, .DBL: .UFL,
        .UBL: .DFL, .DFL: .UBL,
        .UL: .DL, .DL: .UL,
        .FL: .BL, .BL: .FL,
    ],
    Move(.L, .p1): [
        .UFL: .DFL_c, .DFL: .DBL_p, .DBL: .UBL_c, .UBL: .UFL_p,
        .UL: .FL, .FL: .DL, .DL: .BL, .BL: .UL,
    ],
    
    //
    
    Move(.u, .c1): [
        .UFR: .UBR, .UBR: .UBL, .UBL: .UFL, .UFL: .UFR,
        .UF: .UR, .UR: .UB, .UB: .UL, .UL: .UF,
        .FR: .BR_f, .BR: .BL_f, .BL: .FL_f, .FL: .FR_f,
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
        .FR: .FL_f, .FL: .BL_f, .BL: .BR_f, .BR: .FR_f,
        .F: .L, .L: .B, .B: .R, .R: .F,
    ],
    
    Move(.d, .c1): [
        .DFR: .DFL, .DFL: .DBL, .DBL: .DBR, .DBR: .DFR,
        .DF: .DL, .DL: .DB, .DB: .DR, .DR: .DF,
        .FR: .FL_f, .FL: .BL_f, .BL: .BR_f, .BR: .FR_f,
        .F: .L, .L: .B, .B: .R, .R: .F,
    ],
    Move(.d, .c2): [
        .DFR: .DBL, .DBL: .DFR,
        .DFL: .DBR, .DBR: .DFL,
        .DF: .DB, .DB: .DF,
        .DR: .DL, .DL: .DR,
        .FR: .BL, .BL: .FR,
        .FL: .BR, .BR: .FL,
        .F: .B, .B: .F,
        .R: .L, .L: .R,
    ],
    Move(.d, .p1): [
        .DFR: .DBR, .DBR: .DBL, .DBL: .DFL, .DFL: .DFR,
        .DF: .DR, .DR: .DB, .DB: .DL, .DL: .DF,
        .FR: .BR_f, .BR: .BL_f, .BL: .FL_f, .FL: .FR_f,
        .F: .R, .R: .B, .B: .L, .L: .F,
    ],
    
    Move(.f, .c1): [
        .UFR: .UFL_c, .UFL: .DFL_p, .DFL: .DFR_c, .DFR: .UFR_p,
        .UF: .FL_f, .FL: .DF_f, .DF: .FR_f, .FR: .UF_f,
        .UR: .UL_f, .UL: .DL_f, .DL: .DR_f, .DR: .UR_f,
        .U: .L, .L: .D, .D: .R, .R: .U,
    ],
    Move(.f, .c2): [
        .UFR: .DFL, .DFL: .UFR,
        .UFL: .DFR, .DFR: .UFL,
        .UF: .DF, .DF: .UF,
        .FR: .FL, .FL: .FR,
        .UR: .DL, .DL: .UR,
        .UL: .DR, .DR: .UL,
        .U: .D, .D: .U,
        .R: .L, .L: .R,
    ],
    Move(.f, .p1): [
        .UFR: .DFR_c, .DFR: .DFL_p, .DFL: .UFL_c, .UFL: .UFR_p,
        .UF: .FR_f, .FR: .DF_f, .DF: .FL_f, .FL: .UF_f,
        .UR: .DR_f, .DR: .DL_f, .DL: .UL_f, .UL: .UR_f,
        .U: .R, .R: .D, .D: .L, .L: .U,
    ],
    
    Move(.b, .c1): [
        .UBR: .DBR_p, .DBR: .DBL_c, .DBL: .UBL_p, .UBL: .UBR_c,
        .UB: .BR_f, .BR: .DB_f, .DB: .BL_f, .BL: .UB_f,
        .UR: .DR_f, .DR: .DL_f, .DL: .UL_f, .UL: .UR_f,
        .U: .R, .R: .D, .D: .L, .L: .U,
    ],
    Move(.b, .c2): [
        .UBR: .DBL, .DBL: .UBR,
        .UBL: .DBR, .DBR: .UBL,
        .UB: .DB, .DB: .UB,
        .BR: .BL, .BL: .BR,
        .UR: .DL, .DL: .UR,
        .UL: .DR, .DR: .UL,
        .U: .D, .D: .U,
        .R: .L, .L: .R,
    ],
    Move(.b, .p1): [
        .UBR: .UBL_p, .UBL: .DBL_c, .DBL: .DBR_p, .DBR: .UBR_c,
        .UB: .BL_f, .BL: .DB_f, .DB: .BR_f, .BR: .UB_f,
        .UR: .UL_f, .UL: .DL_f, .DL: .DR_f, .DR: .UR_f,
        .U: .L, .L: .D, .D: .R, .R: .U,
    ],
    
    Move(.r, .c1): [
        .UFR: .DFR_p, .DFR: .DBR_c, .DBR: .UBR_p, .UBR: .UFR_c,
        .UR: .FR, .FR: .DR, .DR: .BR, .BR: .UR,
        .UF: .DF_f, .DF: .DB_f, .DB: .UB_f, .UB: .UF_f,
        .U: .F, .F: .D, .D: .B, .B: .U,
    ],
    Move(.r, .c2): [
        .UFR: .DBR, .DBR: .UFR,
        .UBR: .DFR, .DFR: .UBR,
        .UR: .DR, .DR: .UR,
        .FR: .BR, .BR: .FR,
        .UF: .DB, .DB: .UF,
        .UB: .DF, .DF: .UB,
        .U: .D, .D: .U,
        .F: .B, .B: .F,
    ],
    Move(.r, .p1): [
        .UFR: .UBR_p, .UBR: .DBR_c, .DBR: .DFR_p, .DFR: .UFR_c,
        .UR: .BR, .BR: .DR, .DR: .FR, .FR: .UR,
        .UF: .UB_f, .UB: .DB_f, .DB: .DF_f, .DF: .UF_f,
        .U: .B, .B: .D, .D: .F, .F: .U,
    ],
    
    Move(.l, .c1): [
        .UFL: .UBL_c, .UBL: .DBL_p, .DBL: .DFL_c, .DFL: .UFL_p,
        .UL: .BL, .BL: .DL, .DL: .FL, .FL: .UL,
        .UF: .UB_f, .UB: .DB_f, .DB: .DF_f, .DF: .UF_f,
        .U: .B, .B: .D, .D: .F, .F: .U,
    ],
    Move(.l, .c2): [
        .UFL: .DBL, .DBL: .UFL,
        .UBL: .DFL, .DFL: .UBL,
        .UL: .DL, .DL: .UL,
        .FL: .BL, .BL: .FL,
        .UF: .DB, .DB: .UF,
        .UB: .DF, .DF: .UB,
        .U: .D, .D: .U,
        .F: .B, .B: .F,
    ],
    Move(.l, .p1): [
        .UFL: .DFL_c, .DFL: .DBL_p, .DBL: .UBL_c, .UBL: .UFL_p,
        .UL: .FL, .FL: .DL, .DL: .BL, .BL: .UL,
        .UF: .DF_f, .DF: .DB_f, .DB: .UB_f, .UB: .UF_f,
        .U: .F, .F: .D, .D: .B, .B: .U,
    ],
    
    //
    
    Move(.M, .c1): [
        .UF: .UB_f, .UB: .DB_f, .DB: .DF_f, .DF: .UF_f,
        .U: .B, .B: .D, .D: .F, .F: .U,
    ],
    Move(.M, .c2): [
        .UF: .DB, .DB: .UF,
        .UB: .DF, .DF: .UB,
        .U: .D, .D: .U,
        .F: .B, .B: .F,
    ],
    Move(.M, .p1): [
        .UF: .DF_f, .DF: .DB_f, .DB: .UB_f, .UB: .UF_f,
        .U: .F, .F: .D, .D: .B, .B: .U,
    ],
    
    Move(.S, .c1): [
        .UR: .UL_f, .UL: .DL_f, .DL: .DR_f, .DR: .UR_f,
        .U: .L, .L: .D, .D: .R, .R: .U,
    ],
    Move(.S, .c2): [
        .UR: .DL, .DL: .UR,
        .UL: .DR, .DR: .UL,
        .U: .D, .D: .U,
        .R: .L, .L: .R,
    ],
    Move(.S, .p1): [
        .UR: .DR_f, .DR: .DL_f, .DL: .UL_f, .UL: .UR_f,
        .U: .R, .R: .D, .D: .L, .L: .U,
    ],
    
    Move(.E, .c1): [
        .FR: .FL_f, .FL: .BL_f, .BL: .BR_f, .BR: .FR_f,
        .F: .L, .L: .B, .B: .R, .R: .F,
    ],
    Move(.E, .c2): [
        .FR: .BL, .BL: .FR,
        .FL: .BR, .BR: .FL,
        .F: .B, .B: .F,
        .R: .L, .L: .R,
    ],
    Move(.E, .p1): [
        .FR: .BR_f, .BR: .BL_f, .BL: .FL_f, .FL: .FR_f,
        .F: .R, .R: .B, .B: .L, .L: .F,
    ],
    
    //
    
    Move(.x, .c1): [
        .UFR: .DFR_p, .DFR: .DBR_c, .DBR: .UBR_p, .UBR: .UFR_c,
        .UR: .FR, .FR: .DR, .DR: .BR, .BR: .UR,
        .UF: .DF_f, .DF: .DB_f, .DB: .UB_f, .UB: .UF_f,
        .U: .F, .F: .D, .D: .B, .B: .U,
        .UFL: .DFL_c, .DFL: .DBL_p, .DBL: .UBL_c, .UBL: .UFL_p,
        .UL: .FL, .FL: .DL, .DL: .BL, .BL: .UL,
    ],
    Move(.x, .c2): [
        .UFR: .DBR, .DBR: .UFR,
        .UBR: .DFR, .DFR: .UBR,
        .UR: .DR, .DR: .UR,
        .FR: .BR, .BR: .FR,
        .UF: .DB, .DB: .UF,
        .UB: .DF, .DF: .UB,
        .U: .D, .D: .U,
        .F: .B, .B: .F,
        .UFL: .DBL, .DBL: .UFL,
        .UBL: .DFL, .DFL: .UBL,
        .UL: .DL, .DL: .UL,
        .FL: .BL, .BL: .FL,
    ],
    Move(.x, .p1): [
        .UFR: .UBR_p, .UBR: .DBR_c, .DBR: .DFR_p, .DFR: .UFR_c,
        .UR: .BR, .BR: .DR, .DR: .FR, .FR: .UR,
        .UF: .UB_f, .UB: .DB_f, .DB: .DF_f, .DF: .UF_f,
        .U: .B, .B: .D, .D: .F, .F: .U,
        .UFL: .UBL_c, .UBL: .DBL_p, .DBL: .DFL_c, .DFL: .UFL_p,
        .UL: .BL, .BL: .DL, .DL: .FL, .FL: .UL,
    ],
    
    Move(.y, .c1): [
        .UFR: .UBR, .UBR: .UBL, .UBL: .UFL, .UFL: .UFR,
        .UF: .UR, .UR: .UB, .UB: .UL, .UL: .UF,
        .FR: .BR_f, .BR: .BL_f, .BL: .FL_f, .FL: .FR_f,
        .F: .R, .R: .B, .B: .L, .L: .F,
        .DFR: .DBR, .DBR: .DBL, .DBL: .DFL, .DFL: .DFR,
        .DF: .DR, .DR: .DB, .DB: .DL, .DL: .DF,
    ],
    Move(.y, .c2): [
        .UFR: .UBL, .UBL: .UFR,
        .UFL: .UBR, .UBR: .UFL,
        .UF: .UB, .UB: .UF,
        .UR: .UL, .UL: .UR,
        .FR: .BL, .BL: .FR,
        .FL: .BR, .BR: .FL,
        .F: .B, .B: .F,
        .R: .L, .L: .R,
        .DFR: .DBL, .DBL: .DFR,
        .DFL: .DBR, .DBR: .DFL,
        .DF: .DB, .DB: .DF,
        .DR: .DL, .DL: .DR,
    ],
    Move(.y, .p1): [
        .UFR: .UFL, .UFL: .UBL, .UBL: .UBR, .UBR: .UFR,
        .UF: .UL, .UL: .UB, .UB: .UR, .UR: .UF,
        .FR: .FL_f, .FL: .BL_f, .BL: .BR_f, .BR: .FR_f,
        .F: .L, .L: .B, .B: .R, .R: .F,
        .DFR: .DFL, .DFL: .DBL, .DBL: .DBR, .DBR: .DFR,
        .DF: .DL, .DL: .DB, .DB: .DR, .DR: .DF,
    ],
    
    Move(.z, .c1): [
        .UFR: .UFL_c, .UFL: .DFL_p, .DFL: .DFR_c, .DFR: .UFR_p,
        .UF: .FL_f, .FL: .DF_f, .DF: .FR_f, .FR: .UF_f,
        .UR: .UL_f, .UL: .DL_f, .DL: .DR_f, .DR: .UR_f,
        .U: .L, .L: .D, .D: .R, .R: .U,
        .UBR: .UBL_p, .UBL: .DBL_c, .DBL: .DBR_p, .DBR: .UBR_c,
        .UB: .BL_f, .BL: .DB_f, .DB: .BR_f, .BR: .UB_f,
    ],
    Move(.z, .c2): [
        .UFR: .DFL, .DFL: .UFR,
        .UFL: .DFR, .DFR: .UFL,
        .UF: .DF, .DF: .UF,
        .FR: .FL, .FL: .FR,
        .UR: .DL, .DL: .UR,
        .UL: .DR, .DR: .UL,
        .U: .D, .D: .U,
        .R: .L, .L: .R,
        .UBR: .DBL, .DBL: .UBR,
        .UBL: .DBR, .DBR: .UBL,
        .UB: .DB, .DB: .UB,
        .BR: .BL, .BL: .BR,
    ],
    Move(.z, .p1): [
        .UFR: .DFR_c, .DFR: .DFL_p, .DFL: .UFL_c, .UFL: .UFR_p,
        .UF: .FR_f, .FR: .DF_f, .DF: .FL_f, .FL: .UF_f,
        .UR: .DR_f, .DR: .DL_f, .DL: .UL_f, .UL: .UR_f,
        .U: .R, .R: .D, .D: .L, .L: .U,
        .UBR: .DBR_p, .DBR: .DBL_c, .DBL: .UBL_p, .UBL: .UBR_c,
        .UB: .BR_f, .BR: .DB_f, .DB: .BL_f, .BL: .UB_f,
    ],
]
