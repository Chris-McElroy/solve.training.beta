//
//  Method.swift
//  solve.training
//
//  Created by chris on '26.10.22.
//

import SwiftUI

class Method {
    var name: String
    var steps: [Step]
    var groups: [Group]
    var cases: [Case]
    var orientations: [[Move?]]
    
    init(name: String, steps: [Step], groups: [Group], cases: [Case]) {
        self.name = name
        self.steps = steps
        self.groups = groups
        self.cases = cases
        self.orientations = Move.myOrientations
    }
}

struct Step {
    let name: String
    let color: Color
}

struct Group {
    let name: String
    let color: Color
}

struct Setup {
    var pre: Alg
    var post: Alg
    var right: Bool
    
    init(pre: Alg = Alg(), post: Alg = Alg(), right: Bool = true) {
        self.pre = pre
        self.post = post
        self.right = right
    }
}

class Case {
    var name: String
    var step: String
    var group: String
    var status: CaseStatus
    var highlights: [Position: [Int]]
    
    var alg: Alg
    var premoves: [Alg]
    var setup: [Setup]
    var postmoves: Alg
    var postScramble: PostScramble
    
    var altAlgs: [Alg]
    
    var stats: [CaseStatus: CaseStats]
    
    init(name: String,
         step: String,
         group: String,
         status: CaseStatus = .unknown,
         highlights: [Position: [Int]],
         
         alg: Alg,
         premoves: [Alg] = Alg.AUFs,
         setup: [Setup] = [],
         postmoves: Alg = Alg(),
         postScramble: PostScramble = PostScramble(),
         
         altAlgs: [Alg] = [],
         
         stats: [CaseStatus : CaseStats] = [:]) {
        
        self.name = name
        self.step = step
        self.group = group
        self.status = status
        self.highlights = highlights
        
        self.alg = alg
        self.premoves = premoves
        self.setup = setup
        self.postmoves = postmoves
        self.postScramble = postScramble
        
        self.altAlgs = altAlgs
        
        self.stats = stats
    }
}

enum CaseStatus: String {
    case unknown = "unknown"
    case memorizing = "memorizing"
    case training = "training"
    case learned = "learned"
}

class CaseStats {
    // laterDO see if i'm initing too many of these, should i make it a struct
    
    var attemptCount: Int = 0
    var successCount: Int = 0
    var recogTime: [TimeInterval] = []
    var execTime: [TimeInterval] = []
    var perMoveExecTime: [TimeInterval] = []
}

struct PostScramble {
    let unsolvedCorners: Set<Position>
    let cornerConstraints: [Constraint]
    let unsolvedEdges: Set<Position>
    let edgeConstraints: [Constraint]
    let algOptions: [Alg]
    
    init(unsolvedCorners: Set<Position> = [], cornerConstraints: [Constraint] = [], unsolvedEdges: Set<Position> = [], edgeConstraints: [Constraint] = [], algOptions: [Alg] = []) {
        self.unsolvedCorners = unsolvedCorners
        self.cornerConstraints = cornerConstraints
        self.unsolvedEdges = unsolvedEdges
        self.edgeConstraints = edgeConstraints
        self.algOptions = algOptions
    }
    
    func getScramble() -> [Position: Shift] {
        var scramble: [Position: Shift] = [:]
        
        
        /*
         
         
         CORNER scramble
         
         
         */
        
        var forwardPaths: [Position: Position] = [:]
        var backwardPaths: [Position: Position] = [:]
        var positionParity: Bool = true
        var orientationParity: Int = 0
        
        var remainingPieces = unsolvedCorners
        var remainingPositions = unsolvedCorners
        var remainingConstraints = cornerConstraints
        
        while !remainingConstraints.isEmpty && remainingPieces.count > 2 {
            let constraint = remainingConstraints.removeFirst()
            let pieceOptions = remainingPieces.intersection(constraint.options.keys)
            guard let piece = pieceOptions.randomElement() else {
                print("ran out of options!", unsolvedCorners, cornerConstraints, remainingPieces, remainingPositions, remainingConstraints)
                return [:]
            }
            remainingPieces.remove(piece)
            remainingPositions.remove(constraint.position)
            let rotation = constraint.options[piece]!.randomElement()!
            
            scramble[constraint.position] = Shift(oldPos: piece, rotation: rotation)
            
            orientationParity += rotation
            recordPositionParity(piece, constraint.position)
            
        }
        
        while !remainingConstraints.isEmpty && remainingPieces.count == 2 {
            // TODO find correct switch
        }
        
        while !remainingConstraints.isEmpty && remainingPieces.count == 1 {
            // TODO rotation
        }
        
        
        while remainingPieces.count > 2 {
            let piece = remainingPieces.randomElement()!
            remainingPieces.remove(piece)
            let rotation = (0..<3).randomElement()!
            let position = remainingPositions.randomElement()!
            remainingPositions.remove(position)
            
            scramble[position] = Shift(oldPos: piece, rotation: rotation)
            
            orientationParity += rotation
            recordPositionParity(piece, position)
        }
        
        if remainingPieces.count == 2 {
            let nextPiece = remainingPieces.randomElement()!
            remainingPieces.remove(nextPiece)
            let lastPiece = remainingPieces.first!
            remainingPieces.remove(lastPiece)
            let rotation1 = (0..<3).randomElement()!
            orientationParity += rotation1
            let rotation2 = (3 - (orientationParity % 3)) % 3
            
            let position1 = remainingPositions.randomElement()!
            remainingPositions.remove(position1)
            let position2 = remainingPositions.first!
            remainingPositions.remove(position2)
            
            recordPositionParity(nextPiece, position1)
            recordPositionParity(lastPiece, position2)
            
            if positionParity {
                scramble[position1] = Shift(oldPos: nextPiece, rotation: rotation1)
                scramble[position2] = Shift(oldPos: lastPiece, rotation: rotation2)
            } else {
                scramble[position2] = Shift(oldPos: nextPiece, rotation: rotation1)
                scramble[position1] = Shift(oldPos: lastPiece, rotation: rotation2)
            }
        }
        
        if remainingPieces.count == 1 {
            let piece = remainingPieces.first!
            let rotation = (3 - (orientationParity % 3)) % 3
            let position = remainingPositions.first!
            scramble[position] = Shift(oldPos: piece, rotation: rotation)
        }
        
        
        
        /*
         
         
         EDGE scramble
         
         
         */
        
        forwardPaths = [:]
        backwardPaths = [:]
        positionParity = true
        orientationParity = 0
        
        remainingPieces = unsolvedEdges
        remainingPositions = unsolvedEdges
        remainingConstraints = edgeConstraints
        
        while !remainingConstraints.isEmpty && remainingPieces.count > 2 {
            let constraint = remainingConstraints.removeFirst()
            let pieceOptions = remainingPieces.intersection(constraint.options.keys)
            guard let piece = pieceOptions.randomElement() else {
                print("ran out of options!", unsolvedCorners, cornerConstraints, remainingPieces, remainingPositions, remainingConstraints)
                return [:]
            }
            remainingPieces.remove(piece)
            remainingPositions.remove(constraint.position)
            let rotation = constraint.options[piece]!.randomElement()!
            
            scramble[constraint.position] = Shift(oldPos: piece, rotation: rotation)
            
            orientationParity += rotation
            recordPositionParity(piece, constraint.position)
        }
        
        while !remainingConstraints.isEmpty && remainingPieces.count == 2 {
            // TODO find correct switch
        }
        
        while !remainingConstraints.isEmpty && remainingPieces.count == 1 {
            // TODO rotation
        }
        
        
        while remainingPieces.count > 2 {
            let piece = remainingPieces.randomElement()!
            remainingPieces.remove(piece)
            let rotation = (0..<3).randomElement()!
            let position = remainingPositions.randomElement()!
            remainingPositions.remove(position)
            
            scramble[position] = Shift(oldPos: piece, rotation: rotation)
            
            orientationParity += rotation
            recordPositionParity(piece, position)
        }
        
        if remainingPieces.count == 2 {
            let nextPiece = remainingPieces.randomElement()!
            remainingPieces.remove(nextPiece)
            let lastPiece = remainingPieces.first!
            remainingPieces.remove(lastPiece)
            let rotation1 = (0..<3).randomElement()!
            orientationParity += rotation1
            let rotation2 = orientationParity&1 == 0 ? 0 : 1
            
            let position1 = remainingPositions.randomElement()!
            remainingPositions.remove(position1)
            let position2 = remainingPositions.first!
            remainingPositions.remove(position2)
            
            recordPositionParity(nextPiece, position1)
            recordPositionParity(lastPiece, position2)
            
            if positionParity {
                scramble[position1] = Shift(oldPos: nextPiece, rotation: rotation1)
                scramble[position2] = Shift(oldPos: lastPiece, rotation: rotation2)
            } else {
                scramble[position2] = Shift(oldPos: nextPiece, rotation: rotation1)
                scramble[position1] = Shift(oldPos: lastPiece, rotation: rotation2)
            }
        }
        
        if remainingPieces.count == 1 {
            let piece = remainingPieces.first!
            let rotation = orientationParity&1 == 0 ? 0 : 1
            let position = remainingPositions.first!
            scramble[position] = Shift(oldPos: piece, rotation: rotation)
        }
        
        // TODO add postAUF
        
        return scramble
        
        func recordPositionParity(_ newStart: Position, _ newEnd: Position) {
            if let end = forwardPaths[newEnd] {
                if let start = backwardPaths[newStart] {
                    if start == end {
                        // AB + BA = full cycle
                        forwardPaths[newEnd] = nil
                        backwardPaths[newStart] = nil
                    } else {
                        // AB + BE + SA = SABE
                        forwardPaths[start] = end
                        backwardPaths[end] = start
                        forwardPaths[newEnd] = nil
                        backwardPaths[newStart] = nil
                        positionParity.toggle()
                    }
                } else {
                    // AB + BE = ABE
                    forwardPaths[newStart] = end
                    backwardPaths[end] = newStart
                    forwardPaths[newEnd] = nil
                    positionParity.toggle()
                }
            } else if let start = backwardPaths[newStart] {
                // AB + SA = SAB
                forwardPaths[start] = newEnd
                backwardPaths[newEnd] = start
                backwardPaths[newStart] = nil
                positionParity.toggle()
            } else {
                forwardPaths[newStart] = newEnd
                backwardPaths[newEnd] = newStart
                positionParity.toggle()
            }
        }
    }
}

struct Constraint {
    let position: Position
    let options: [Position: [Int]]
}

struct Cycles {
    var head: Position
    var tail: Position
    var even: Bool
}
