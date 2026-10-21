//
//  AlgInput.swift
//  solve.training
//
//  Created by chris on '26.10.16.
//

import Foundation

struct AlgInput {
    let moves: [MoveInput]
    
    init(alg: Alg) {
        var moves: [MoveInput] = []
        for move in alg.moves {
            moves.append(contentsOf: move.input)
        }
        self.moves = moves
    }
    
    var string: String {
        return moves.map { $0.string }.joined(separator: "")
    }
    
    func stringStart(completed n: Int) -> String {
        return moves.dropLast(moves.count - n).map { $0.string }.joined(separator: "")
    }
    
    func stringEnd(completed n: Int) -> String {
        return moves.dropFirst(n).map { $0.string }.joined(separator: "")
    }
}

struct MoveInput {
    let slice: Slice
    let turn: TurnInput
    
    init(_ slice: Slice, _ turn: TurnInput) {
        self.slice = slice
        self.turn = turn
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
        case .B: return turn.c ? "t" : "y"
        case .R: return turn.c ? "i" : "k"
        case .L: return turn.c ? "d" : "e"
            
        case .u: return turn.c ? "J" : "F"
        case .d: return turn.c ? "SO" : "LW"
        case .r: return turn.c ? "I" : "K"
        case .l: return turn.c ? "D" : "E"
        case .f: return turn.c ? "H" : "G"
        case .b: return turn.c ? "T" : "Y"
            
        case .M: return turn.c ? "z." : "x'"
        case .S: return turn.c ? "n" : "b"
        case .E: return turn.c ? "c" : ","
            
        case .x: return turn.c ? "v" : "r"
        case .y: return turn.c ? ";p" : "aq"
        case .z: return turn.c ? "u" : "m"
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
        
        "b": Move(.B, .c1),
        "n": Move(.B, .p1),
        
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
        
        "B": Move(.b, .c1),
        "N": Move(.b, .p1),
        
        "I": Move(.r, .c1),
        "K": Move(.r, .p1),
        
        "D": Move(.l, .c1),
        "E": Move(.l, .p1),
        
        
        
        "z": Move(.M, .c1),
        ".": Move(.M, .c1),
        "x": Move(.M, .p1),
        "'": Move(.M, .p1),
        
        "y": Move(.S, .c1),
        "t": Move(.S, .p1),
        
        "c": Move(.E, .c1),
        ",": Move(.E, .p1),
        
        
        
        "v": Move(.x, .p1),
        "r": Move(.x, .p1),
        
        ";": Move(.y, .c1),
        "p": Move(.y, .c1),
        "a": Move(.y, .p1),
        "q": Move(.y, .p1),
        
        "u": Move(.z, .c1),
        "m": Move(.z, .p1),
    ]
}

enum TurnInput {
    case c1, c2i1, c2i2, c3i1, c3i2, c3i3
    case p1, p2i1, p2i2, p3i1, p3i2, p3i3
    
    var c: Bool {
        return self == .c1 || self == .c2i1 || self == .c2i2 || self == .c3i1 || self == .c3i2 || self == .c3i3
    }
}
