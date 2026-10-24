//
//  TrainingCase.swift
//  solve.training
//
//  Created by chris on '26.10.16.
//

import Foundation

class TrainingCase {
    let base: Case
    
    let setup: (pre: Alg, post: Alg)
    let pre: Alg
    let alg: Alg
    let post: Alg
    
    let moveInputs: [MoveInput]
    
    private var progress: Int = 0
    private let textBits: [String]
    var completedText: String
    var currentText: String
    var upcomingText: String
    
    var mistake: Bool = false
    var success: Bool = true
    var finished: Bool = false
    
    let cube = Cube.main
    
    init(from base: Case) {
        self.base = base
        
        var setup = base.setup.randomElement() ?? (pre: Alg(), post: Alg())
        let pre = base.premoves.randomElement() ?? Alg()
        var alg = base.alg
        let post = base.postmoves
        
        if let setupCancelIndex = setup.pre.moves.lastIndex(where: { $0.slice == .D }) {
            if alg.moves.first?.slice == .D {
                if setup.pre.moves[setupCancelIndex].inverse == alg.moves.first {
                    setup.pre.moves.remove(at: setupCancelIndex)
                    alg.moves.removeFirst()
                } else {
                    print("hi chris, now you have to set up move adding! (for pre)")
                }
            }
        }
        
        if let setupCancelIndex = setup.post.moves.firstIndex(where: { $0.slice == .D }) {
            if alg.moves.last?.slice == .D {
                if setup.post.moves[setupCancelIndex].inverse == alg.moves.last {
                    setup.post.moves.remove(at: setupCancelIndex)
                    alg.moves.removeLast()
                } else {
                    print("hi chris, now you have to set up move adding! (for post)")
                }
            }
        }
        
        self.setup = setup
        self.pre = pre
        self.alg = alg
        self.post = post
        
        var text: [String] = []
        var moveInputs: [MoveInput] = []
        
        let premoves = Alg(setup.pre.moves + pre.moves)
        
        if !premoves.moves.isEmpty {
            let preMoveInputs = premoves.moves.flatMap { $0.input }
            moveInputs.append(contentsOf: preMoveInputs)
            text.append(contentsOf: preMoveInputs.map { $0.string })
            text[0] = "(" + text[0]
            text[text.count - 1] = text[text.count - 1].dropLast().appending(") ")
        }
        
        let algInputs = alg.moves.flatMap { $0.input }
        moveInputs.append(contentsOf: algInputs)
        text.append(contentsOf: algInputs.map { $0.string })
        
        if !setup.post.moves.isEmpty {
            let postTextStart = text.count
            let postMoveInputs = setup.post.moves.flatMap { $0.input }
            moveInputs.append(contentsOf: postMoveInputs)
            text.append(contentsOf: postMoveInputs.map { $0.string })
            text[postTextStart] = "(" + text[postTextStart]
            text[text.count - 1] = text[text.count - 1].dropLast().appending(")")
        } else if !text.isEmpty {
            text[text.count - 1].removeLast()
        } else {
            print("error - empty base")
        }
        
        self.textBits = text
        self.moveInputs = moveInputs
        
        completedText = ""
        currentText = textBits[0]
        upcomingText = textBits.dropFirst().joined()
        
        cube.reset()
        for orientationSet in methods[0].orientations {
            if let orientation = orientationSet.randomElement() as? Move {
                cube.exec(orientation)
            }
        }
        if let postAUF = Alg.AUFs.randomElement() {
            cube.scramble(postAUF)
        }
        cube.scramble(setup.post)
        for (position, highlight) in base.highlights {
            Cube.main.pieces[position.rawValue].highlights = highlight
        }
        cube.scramble(post)
        cube.scramble(alg)
        cube.scramble(pre)
        cube.scramble(setup.pre)
        Cube.main.update.toggle()
    }
    
    func processInput(_ inputChr: Character) {
        guard !finished else { return }
        
        if inputChr == " " {
            cube.transparent.toggle()
            cube.update.toggle()
            return
        }
        
        guard moveInputs[progress].inputChr.contains(inputChr) else {
            mistake = true
            success = false
            return
        }
        mistake = false
        Cube.main.exec(moveInputs[progress].move)
        Cube.main.update.toggle()
        progress += 1
        
        completedText = textBits.dropLast(textBits.count - progress).joined()
        currentText = progress < textBits.count ? textBits[progress] : ""
        upcomingText = progress < textBits.count ? textBits.dropFirst(progress + 1).joined() : ""
        
        if progress == textBits.count {
            finished = true
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
            
        case .x: return turn.c ? "r" : "v"
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
        
        "t": Move(.B, .c1),
        "y": Move(.B, .p1),
        
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
        
        "T": Move(.b, .c1),
        "Y": Move(.b, .p1),
        
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
    
    var turn: Turn {
        return c ? .c1 : .p1
    }
}
