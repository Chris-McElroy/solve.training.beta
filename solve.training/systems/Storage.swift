//
//  Storage.swift
//  solve.training
//
//  Created by chris on '26.10.22.
//

import SwiftUI

enum Key: String {
    case vyx = "vyx"
    
    case stats = "Stats"
    
    case attempts = "attempts"
    
    case success = "success"
    case tps = "tps"
    case recog = "recog"
    case exec = "exec"
    case total = "total"
    case date = "date"
    
    case tpsPB = "tpsPB"
    case recogPB = "recogPB"
    case execPB = "execPB"
    case totalPB = "totalPB"
}

class Storage {
    static func getStats(_ method: Key = .vyx, for caseID: String) -> Stats? {
        guard let allStatsDict = UserDefaults.standard.dictionary(forKey: method.rawValue + Key.stats.rawValue) as? [String: [String: Any]] else { return nil }
        
        guard let caseStatsDict = allStatsDict[String(caseID)] else { return nil }
        
        return Stats(from: caseStatsDict)
    }
    
    static func getAllStats(_ method: Key = .vyx) -> [String: Stats] {
        guard let allStatsDict = UserDefaults.standard.dictionary(forKey: method.rawValue + Key.stats.rawValue) as? [String: [String: Any]] else { return [:] }
        
        return allStatsDict.mapValues { Stats(from: $0) ?? Stats() }
    }
    
    static func updateStats(_ method: Key = .vyx, for caseID: String, to stats: Stats) {
        guard var allStatsDict = UserDefaults.standard.dictionary(forKey: method.rawValue + Key.stats.rawValue) as? [String: [String: Any]] else { return }
        
        allStatsDict[caseID] = stats.toDict()
        
        UserDefaults.standard.set(allStatsDict, forKey: method.rawValue + Key.stats.rawValue)
    }
}

let methods: [Method] = [
    Method(
        name: "vyx",
        steps: [
            Step(name: "c", color: .white),
            Step(name: "p", color: .blue),
            Step(name: "5es", color: .yellow),
            Step(name: "5epu", color: .brown),
            Step(name: "2c", color: .purple),
            Step(name: "3c", color: .pink),
        ],
        groups: [
            Group(name: "main", color: .black)
        ],
        // laterDO make .U2 move shortcut and alg shortcut for postmoves alg
        cases: [
            // a
            Case(ID: "aa-p", name: "aa-p", step: "2c", group: "aa", status: .learned,
                 alg: Alg("R' D' R U' R' D R")!, postmoves: Alg("U'")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(ID: "aa-o", name: "aa-o", step: "2c", group: "aa", status: .learned,
                 alg: Alg("R' D' R U2 R' D R")!, postmoves: Alg(),
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(ID: "aa-c", name: "aa-c", step: "2c", group: "aa", status: .learned,
                 alg: Alg("R' D' R U R' D R")!, postmoves: Alg("U")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(ID: "aa-s", name: "aa-s", step: "2c", group: "aa", status: .training,
                 alg: Alg("R2 B D2 B' R2' U2' F r2 B' x2'")!, postmoves: Alg(),
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            
            Case(ID: "as-p", name: "as-p", step: "2c", group: "as", status: .training,
                 alg: Alg("R U' R D R' U2 R D' R' U' R'")!, postmoves: Alg(),
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(ID: "as-o", name: "as-o", step: "2c", group: "as", status: .training,
                 alg: Alg("R U' R D R' U' R D' R' U2 R'")!, postmoves: Alg("U")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(ID: "as-c", name: "as-c", step: "2c", group: "as", status: .training,
                 alg: Alg("r' F' r D' r' F2 r D r' F' r")!, postmoves: Alg("U")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(ID: "as-s", name: "as-s", step: "2c", group: "as", status: .training,
                 alg: Alg("R F' r' U D R' D' R U' M' F")!, postmoves: Alg("U2")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            
            Case(ID: "ad-p", name: "ad-p", step: "2c", group: "ad", status: .training,
                 alg: Alg("D' r U2' r' D L D' F2' D L'")!, postmoves: Alg("U2")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(ID: "ad-o", name: "ad-o", step: "2c", group: "ad", status: .learned,
                 alg: Alg("x' R U' R' D' R U R' D x")!, postmoves: Alg(),
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(ID: "ad-c", name: "ad-c", step: "2c", group: "ad", status: .training,
                 alg: Alg("R2 U' r' F R2' x U' L")!, postmoves: Alg(),
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(ID: "ad-s", name: "ad-s", step: "2c", group: "ad", status: .training,
                 alg: Alg("R' U' R2 U' R2' U2' R U2 R U R'")!, postmoves: Alg("U2")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            
            // s
            Case(ID: "sa-p", name: "sa-p", step: "2c", group: "sa", status: .memorizing,
                 alg: Alg("r' F r D' r' F2 r D r' F r")!, postmoves: Alg("U2")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(ID: "sa-o", name: "sa-o", step: "2c", group: "sa", status: .memorizing,
                 alg: Alg("R U2 R D R' U R D' R' U R'")!, postmoves: Alg("U'")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(ID: "sa-c", name: "sa-c", step: "2c", group: "sa", status: .memorizing,
                 alg: Alg("R U R D R' U2 R D' R' U R'")!, postmoves: Alg("U'")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(ID: "sa-s", name: "sa-s", step: "2c", group: "sa", status: .memorizing,
                 alg: Alg("R' D' R U' M' F R F' r' D")!, postmoves: Alg("U'")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),

            Case(ID: "ss-p", name: "ss-p", step: "2c", group: "ss", status: .learned,
                 alg: Alg("D' R' D R U' R' D' R D")!, postmoves: Alg("U'")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(ID: "ss-o", name: "ss-o", step: "2c", group: "ss", status: .learned,
                 alg: Alg("D' R' D R U2 R' D' R D")!, postmoves: Alg(),
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(ID: "ss-c", name: "ss-c", step: "2c", group: "ss", status: .learned,
                 alg: Alg("D' R' D R U R' D' R D")!, postmoves: Alg("U")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(ID: "ss-s", name: "ss-s", step: "2c", group: "ss", status: .training,
                 alg: Alg("M2' U2' r U r' U2' M2' U2' r U r'")!, postmoves: Alg(),
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            
            Case(ID: "sd-p", name: "sd-p", step: "2c", group: "sd", status: .unknown,
                 alg: Alg("B r' D r B r' D' r B2")!, postmoves: Alg(),
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(ID: "sd-o", name: "sd-o", step: "2c", group: "sd", status: .learned,
                 alg: Alg("R' F R U R U' R' F' R U R'")!, postmoves: Alg(),
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(ID: "sd-c", name: "sd-c", step: "2c", group: "sd", status: .unknown,
                 alg: Alg("R' F2 R D' R' D F2 D' R D")!, postmoves: Alg("U")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(ID: "sd-s", name: "sd-s", step: "2c", group: "sd", status: .unknown,
                 alg: Alg("R U' R' U' r' F' r2 F U2 F' r'")!, postmoves: Alg(),
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),

            
            // u
            Case(ID: "ua-p", name: "ua-p", step: "c2", group: "ua", status: .unknown,
                 alg: Alg("r' F R2 F' L F l2' x'")!, postmoves: Alg(),
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(ID: "ua-o", name: "ua-o", step: "c2", group: "ua", status: .unknown,
                 alg: Alg("x' D' R U' R' D R U l'")!, postmoves: Alg("U2")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(ID: "ua-c", name: "ua-c", step: "c2", group: "ua", status: .unknown,
                 alg: Alg("L D' F2' D L' D' L F2' L' D")!, postmoves: Alg("U")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(ID: "ua-s", name: "ua-s", step: "c2", group: "ua", status: .unknown,
                 alg: Alg("R U' R' U2 R' U2' R2 U R2' U R")!, postmoves: Alg("U")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            
            Case(ID: "us-p", name: "us-p", step: "c2", group: "us", status: .training,
                 alg: Alg("D' R' D F2 D' R D R' F2 R")!, postmoves: Alg("U2")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(ID: "us-o", name: "us-o", step: "c2", group: "us", status: .unknown,
                 alg: Alg("R F' L F l' U' r' F")!, postmoves: Alg("U2")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(ID: "us-c", name: "us-c", step: "c2", group: "us", status: .unknown,
                 alg: Alg("D' R U' r2' D R' D' r2 D")!, postmoves: Alg("U'")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(ID: "us-s", name: "us-s", step: "c2", group: "us", status: .unknown,
                 alg: Alg("r F U2 F' r2 F r U R U R'")!, postmoves: Alg("U")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            
            Case(ID: "ud-p", name: "ud-p", step: "c2", group: "ud", status: .unknown,
                 alg: Alg("x' D' R U' R' D2 R U R' D' x")!, postmoves: Alg("U")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(ID: "ud-o", name: "ud-o", step: "c2", group: "ud", status: .training,
                 alg: Alg("R' D R U2 R D' R' U2 R D R2' D' R")!, postmoves: Alg("U")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(ID: "ud-c", name: "ud-c", step: "c2", group: "ud", status: .training,
                 alg: Alg("R F' L F x R2' U' r' F R")!, postmoves: Alg("U'")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(ID: "ud-s", name: "ud-s", step: "c2", group: "ud", status: .learned,
                 alg: Alg("R U' R' U R U' R' U R U' R'")!, postmoves: Alg("U2")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
        ]
    ),
    Method(
        name: "cfop",
        steps: [
            Step(name: "cross", color: .white),
            Step(name: "f2l", color: .blue),
            Step(name: "oll", color: .yellow),
            Step(name: "pll", color: .brown),
        ],
        groups: [
            Group(name: "main", color: .black)
        ],
        cases: [
            // edges
            Case(ID: "Ua1", name: "Ua", step: "pll", group: "U", status: .memorizing,
                 premoves: [], alg: Alg("M2' U M U2 M' U M2'")!,
                 setup: pllSetup, highlights: pllHighlights),
            Case(ID: "Ua2", name: "Ua", step: "pll", group: "U", status: .memorizing,
                 premoves: nearAUFs, alg: Alg("R U R' U R' U' R2 U' R' U R' U R")!,
                 setup: pllSetup, highlights: pllHighlights),
            Case(ID: "Ub1", name: "Ub", step: "pll", group: "U", status: .memorizing,
                 premoves: [], alg: Alg("M2' U' M U2 M' U' M2'")!,
                 setup: pllSetup, highlights: pllHighlights),
            Case(ID: "Ub2", name: "Ub", step: "pll", group: "U", status: .memorizing,
                 premoves: nearAUFs, alg: Alg("L' U' L U' L U L2' U L U' L U' L'")!,
                 setup: pllLeftySetup, highlights: pllHighlights),
            
            Case(ID: "H", name: "H", step: "pll", group: "H", status: .learned,
                 premoves: [], alg: Alg("M2' U M2' U2 M2' U M2'")!,
                 setup: pllSetup, highlights: pllHighlights),
            
            Case(ID: "Z", name: "Z", step: "pll", group: "Z", status: .learned,
                 premoves: mirrorAUFs, alg: Alg("M U M2' U M2' U M U2 M2'")!,
                 setup: pllSetup, highlights: pllHighlights),
            
            // corners
            Case(ID: "Aa1", name: "Aa", step: "pll", group: "A", status: .training,
                 premoves: [], alg: Alg("x L2 D2' L' U' L D2' L' U L' x'")!,
                 setup: pllLeftySetup, highlights: pllHighlights),
            Case(ID: "Aa2", name: "Aa", step: "pll", group: "A", status: .training,
                 premoves: [], alg: Alg("x' L' U L' D2' L U' L' D2' L2 x")!,
                 setup: pllLeftySetup, highlights: pllHighlights),
            Case(ID: "Aa3", name: "Aa", step: "pll", group: "A", status: .training,
                 premoves: [], alg: Alg("x R' U R' D2 R U' R' D2 R2 x'")!,
                 setup: pllSetup, highlights: pllHighlights),
            Case(ID: "Aa4", name: "Aa", step: "pll", group: "A", status: .training,
                 premoves: [], alg: Alg("x' R2 D2 R' U' R D2 R' U R' x")!,
                 setup: pllSetup, highlights: pllHighlights),
            Case(ID: "Ab1", name: "Ab", step: "pll", group: "A", status: .training,
                 premoves: [], alg: Alg("x L U' L D2' L' U L D2' L2' x'")!,
                 setup: pllLeftySetup, highlights: pllHighlights),
            Case(ID: "Ab2", name: "Ab", step: "pll", group: "A", status: .training,
                 premoves: [], alg: Alg("x' L2' D2' L U L' D2' L U' L x")!,
                 setup: pllLeftySetup, highlights: pllHighlights),
            Case(ID: "Ab3", name: "Ab", step: "pll", group: "A", status: .training,
                 premoves: [], alg: Alg("x' R U' R D2 R' U R D2 R2' x")!,
                 setup: pllSetup, highlights: pllHighlights),
            Case(ID: "Ab4", name: "Ab", step: "pll", group: "A", status: .training,
                 premoves: [], alg: Alg("x R2' D2 R U R' D2 R U' R x'")!,
                 setup: pllSetup, highlights: pllHighlights),
            
            Case(ID: "E", name: "E", step: "pll", group: "E", status: .learned,
                 premoves: mirrorAUFs, alg: Alg("R' U' R' D' R U' R' D R U R' D' R U R' D R2")!,
                 setup: pllSetup, highlights: pllHighlights),
            
            // corners and edges
            Case(ID: "T", name: "T", step: "pll", group: "T", status: .unknown,
                 alg: Alg("R U R' U' R' F R2 U' R' U' R U R' F'")!,
                 setup: pllSetup, highlights: pllHighlights),
            
            Case(ID: "F", name: "F", step: "pll", group: "F", status: .unknown,
                 alg: Alg("R' U' F' R U R' U' R' F R2 U' R' U' R U R' U R")!,
                 setup: pllSetup, highlights: pllHighlights),
            
            Case(ID: "Jb", name: "Jb", step: "pll", group: "J", status: .training,
                 alg: Alg("R U R' F' R U R' U' R' F R2 U' R'")!,
                 setup: pllSetup, highlights: pllHighlights),
            
            Case(ID: "Ja", name: "Ja", step: "pll", group: "J", status: .training,
                 alg: Alg("L' U' L F L' U' L U L F' L2' U L")!,
                 setup: pllLeftySetup, highlights: pllHighlights),
            
            Case(ID: "Ra", name: "Ra", step: "pll", group: "R", status: .training,
                 alg: Alg("R U' R' U' R U R D R' U' R D' R' U2 R'")!,
                 setup: pllSetup, highlights: pllHighlights),
            Case(ID: "Rb", name: "Rb", step: "pll", group: "R", status: .training,
                 alg: Alg("R2' F R U R U' R' F' R U2' R' U2 R")!,
                 setup: pllSetup, highlights: pllHighlights),
            
            Case(ID: "Y", name: "Y", step: "pll", group: "Y", status: .training,
                 alg: Alg("F R U' R' U' R U R' F' R U R' U' R' F R F'")!,
                 setup: pllSetup, highlights: pllHighlights),
            
            Case(ID: "V", name: "V", step: "pll", group: "V", status: .training,
                 alg: Alg("R U' R U R' D R D' R U' D R2' U R2 D' R2'")!,
                 setup: pllSetup, highlights: pllHighlights),
            
            Case(ID: "Na", name: "Na", step: "pll", group: "N", status: .training,
                 alg: Alg("R U R' U R U R' F' R U R' U' R' F R2 U' R' U2 R U' R'")!,
                 setup: pllSetup, highlights: pllHighlights),
            Case(ID: "Nb", name: "Nb", step: "pll", group: "N", status: .training,
                 alg: Alg("L' U' L U' L' U' L F L' U' L U L F' L2' U L U2' L' U L")!,
                 setup: pllLeftySetup, highlights: pllHighlights),
            
            Case(ID: "Ga", name: "Ga", step: "pll", group: "G", status: .memorizing,
                 alg: Alg("R2 U R' U R' U' R U' R2 U' D R' U R D'")!,
                 setup: pllSetup, highlights: pllHighlights),
            Case(ID: "Gb", name: "Gb", step: "pll", group: "G", status: .memorizing,
                 alg: Alg("R' U' R U D' R2 U R' U R U' R U' R2' D")!,
                 setup: pllSetup, highlights: pllHighlights),
            Case(ID: "Gc1", name: "Gc", step: "pll", group: "G", status: .memorizing,
                 premoves: mirrorAUFs, alg: Alg("R2' U' R U' R U R' U R2 U D' R U' R' D")!,
                 setup: pllSetup, highlights: pllHighlights),
            Case(ID: "Gc2", name: "Gc", step: "pll", group: "G", status: .memorizing,
                 premoves: mirrorAUFs, alg: Alg("R2' F2 R U2 R U2' R' F R U R' U' R' F R2")!,
                 setup: pllSetup, highlights: pllHighlights),
            Case(ID: "Gd", name: "Gd", step: "pll", group: "G", status: .memorizing,
                 alg: Alg("R U R' U' D R2 U' R U' R' U R' U R2 D'")!,
                 setup: pllSetup, highlights: pllHighlights),
        ]
    )
]

let nearAUFs: [Alg] = [Alg(), Alg("U")!, Alg("U'")!]
let mirrorAUFs: [Alg] = [Alg(), Alg("U")!]

let c2Highlights: [Position: [Int]] = [.DFR: [0, 1, 2], .UBL: [0, 1, 2]]

let pllHighlights: [Position: [Int]] = [.UFR: [1, 2], .UFL: [1, 2], .UBR: [1, 2], .UBL: [1, 2], .UF: [1], .UR: [1], .UL: [1], .UB: [1]]

let c2Setup: [Setup] = [Setup()] // , Setup(pre: Alg("D")!, post: Alg("D'")!, right: false)]

let pllSetup: [Setup] = [Setup(), Setup(post: Alg("U")!), Setup(post: Alg("U2")!), Setup(post: Alg("U'")!)]
let pllLeftySetup: [Setup] = [Setup(right: false), Setup(post: Alg("U")!, right: false), Setup(post: Alg("U2")!, right: false), Setup(post: Alg("U'")!, right: false)]

let c2PostScramble: PostScramble = PostScramble(unsolvedCorners: [.UFL, .UFR, .UBR], algOptions: Alg.AUFs)


