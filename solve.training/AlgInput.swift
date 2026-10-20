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
        case .R: return turn.c ? "i" : "k"
        case .L: return turn.c ? "d" : "e"
        case .F: return turn.c ? "h" : "g"
        case .B: return turn.c ? "b" : "n"
            
        case .u: return turn.c ? "J" : "F"
        case .d: return turn.c ? "SO" : "LW"
        case .r: return turn.c ? "I" : "K"
        case .l: return turn.c ? "D" : "E"
        case .f: return turn.c ? "H" : "G"
        case .b: return turn.c ? "B" : "N"
            
        case .M: return turn.c ? "z." : "x'"
        case .S: return turn.c ? "y" : "t"
        case .E: return turn.c ? "c" : ","
            
        case .x: return turn.c ? "v" : "r"
        case .y: return turn.c ? ";p" : "aq"
        case .z: return turn.c ? "u" : "m"
        }
    }
}

enum TurnInput {
    case c1, c2i1, c2i2, c3i1, c3i2, c3i3
    case p1, p2i1, p2i2, p3i1, p3i2, p3i3
    
    var c: Bool {
        return self == .c1 || self == .c2i1 || self == .c2i2 || self == .c3i1 || self == .c3i2 || self == .c3i3
    }
}
