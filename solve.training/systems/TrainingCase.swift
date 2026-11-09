//
//  TrainingCase.swift
//  solve.training
//
//  Created by chris on '26.10.16.
//

import SwiftUI

class TrainingCase: Equatable {
    let base: Case
    
    let orientations: [Move]
    let canceledMoves: Alg
    let setup: Setup
    let pre: Alg
    let alg: Alg
    let post: Alg
    let postScramble: [[Position: Shift]]
    
    let moveInputs: [MoveInput]
    private var progress: Int = 0
    
    private let textBits: [String]
    
    let cube = Cube.main
    
    init(from base: Case) {
        self.base = base
        
        var setup = base.setup.randomElement() ?? Setup()
        let pre = base.premoves.randomElement() ?? Alg()
        var alg = base.alg
        let post = base.postmoves
        var canceledMoves = Alg()
        
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
                    canceledMoves.moves.append(setup.post.moves[setupCancelIndex]) // laterDO this may be in the wrong order
                    setup.post.moves.remove(at: setupCancelIndex)
                    alg.moves.removeLast()
                } else {
                    print("hi chris, now you have to set up move adding! (for post)")
                }
            }
        }
        
        self.canceledMoves = canceledMoves
        self.setup = setup
        self.pre = pre
        self.alg = alg
        self.post = post
        self.postScramble = base.postScramble.getScramble()
        
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
        
        Manager.main.completedText = ""
        Manager.main.currentText = textBits[0]
        Manager.main.upcomingText = textBits.dropFirst().joined()
        
        cube.reset(right: setup.right)
        
        var orientations: [Move] = []
        for orientationSet in methods[0].orientations {
            if let orientation = orientationSet.randomElement() as? Move {
                orientations.append(orientation)
                cube.exec(orientation)
            }
        }
        self.orientations = orientations
        
        cube.exec(postScramble)
        cube.scramble(setup.post)
        
        // included canceled moves for correct highlighting
        cube.scramble(canceledMoves)
        for (position, highlight) in base.highlights {
            cube.pieces[position.rawValue].highlights = highlight
        }
        cube.exec(canceledMoves)
        
        cube.scramble(post)
        cube.scramble(alg)
        cube.scramble(pre)
        cube.scramble(setup.pre)
        cube.update.toggle()
    }
    
    func processInput(_ inputChr: Character) {
        guard !Manager.main.finished else { return }
        
        if inputChr == " " {
            cube.transparent.toggle()
            cube.update.toggle()
            return
        }
        
        guard moveInputs[progress].inputChr.contains(inputChr) else {
            Manager.main.mistake = true
            Manager.main.success = false
            return
        }
        Manager.main.mistake = false
        Cube.main.exec(moveInputs[progress].move)
        Cube.main.update.toggle()
        progress += 1
        Manager.main.started = true
        
        Manager.main.completedText = textBits.dropLast(textBits.count - progress).joined()
        Manager.main.currentText = progress < textBits.count ? textBits[progress] : ""
        Manager.main.upcomingText = progress < textBits.count ? textBits.dropFirst(progress + 1).joined() : ""
        
        if progress == textBits.count {
            Manager.main.finished = true
        }
    }
    
    func reset() {
        progress = 0
        Manager.main.mistake = false
        Manager.main.success = true
        Manager.main.started = false
        Manager.main.finished = false
        
        Manager.main.completedText = ""
        Manager.main.currentText = textBits[0]
        Manager.main.upcomingText = textBits.dropFirst().joined()
        
        cube.reset(right: setup.right)
        for orientation in orientations {
            cube.exec(orientation)
        }
        
        cube.exec(postScramble)
        cube.scramble(setup.post)
        
        // included canceled moves for correct highlighting
        cube.scramble(canceledMoves)
        for (position, highlight) in base.highlights {
            cube.pieces[position.rawValue].highlights = highlight
        }
        cube.exec(canceledMoves)
        
        cube.scramble(post)
        cube.scramble(alg)
        cube.scramble(pre)
        cube.scramble(setup.pre)
        cube.update.toggle()
    }
    
    static func == (lhs: TrainingCase, rhs: TrainingCase) -> Bool {
        return lhs.base.step == rhs.base.step &&
        lhs.base.group == rhs.base.group &&
        lhs.base.name == rhs.base.name &&
        lhs.orientations == rhs.orientations &&
        lhs.canceledMoves == rhs.canceledMoves &&
        lhs.setup == rhs.setup &&
        lhs.pre == rhs.pre &&
        lhs.alg == rhs.alg &&
        lhs.post == rhs.post &&
        lhs.postScramble == rhs.postScramble
    }
}
