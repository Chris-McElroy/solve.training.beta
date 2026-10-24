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

class Case {
    var name: String
    var step: String
    var group: String
    var status: CaseStatus
    
    var alg: Alg
    var premoves: [Alg]
    var setup: [(pre: Alg, post: Alg)]
    var postmoves: Alg
    var altAlgs: [Alg]
    var highlights: [Position: [Int]]
    
    var stats: [CaseStatus: CaseStats]
    
    init(name: String,
         step: String,
         group: String,
         status: CaseStatus = .unknown,
         alg: Alg,
         premoves: [Alg] = Alg.AUFs,
         setup: [(pre: Alg, post: Alg)] = [],
         postmoves: Alg = Alg(),
         altAlgs: [Alg] = [],
         highlights: [Position: [Int]],
         stats: [CaseStatus : CaseStats] = [:]) {
        
        self.name = name
        self.step = step
        self.group = group
        self.status = status
        self.alg = alg
        self.premoves = premoves
        self.setup = setup
        self.postmoves = postmoves
        self.altAlgs = altAlgs
        self.highlights = highlights
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
