//
//  Storage.swift
//  solve.training
//
//  Created by chris on '26.10.22.
//

import SwiftUI

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
            Case(name: "aa-p", step: "c2", group: "aa", status: .learned,
                 alg: Alg("R' D' R U' R' D R")!, postmoves: Alg("U'")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(name: "aa-o", step: "c2", group: "aa", status: .learned,
                 alg: Alg("R' D' R U2 R' D R")!, postmoves: Alg(),
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(name: "aa-c", step: "c2", group: "aa", status: .learned,
                 alg: Alg("R' D' R U R' D R")!, postmoves: Alg("U")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(name: "aa-s", step: "c2", group: "aa", status: .training,
                 alg: Alg("R2 B D2 B' R2' U2' F r2 B' x2'")!, postmoves: Alg(),
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            
            Case(name: "as-p", step: "c2", group: "as", status: .training,
                 alg: Alg("R U' R D R' U2 R D' R' U' R'")!, postmoves: Alg(),
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(name: "as-o", step: "c2", group: "as", status: .training,
                 alg: Alg("R U' R D R' U' R D' R' U2 R'")!, postmoves: Alg("U")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(name: "as-c", step: "c2", group: "as", status: .training,
                 alg: Alg("r' F' r D' r' F2 r D r' F' r")!, postmoves: Alg("U")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(name: "as-s", step: "c2", group: "as", status: .training,
                 alg: Alg("R F' r' U D R' D' R U' M' F")!, postmoves: Alg("U2")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            
            Case(name: "ad-p", step: "c2", group: "ad", status: .training,
                 alg: Alg("D' r U2' r' D L D' F2' D L'")!, postmoves: Alg("U2")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(name: "ad-o", step: "c2", group: "ad", status: .learned,
                 alg: Alg("x' R U' R' D' R U R' D x")!, postmoves: Alg(),
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(name: "ad-c", step: "c2", group: "ad", status: .training,
                 alg: Alg("R2 U' r' F R2' x U' L")!, postmoves: Alg(),
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(name: "ad-s", step: "c2", group: "ad", status: .training,
                 alg: Alg("R' U' R2 U' R2' U2' R U2 R U R'")!, postmoves: Alg("U2")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            
            // s
            Case(name: "sa-p", step: "c2", group: "sa", status: .memorizing,
                 alg: Alg("r' F r D' r' F2 r D r' F r")!, postmoves: Alg("U2")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(name: "sa-o", step: "c2", group: "sa", status: .memorizing,
                 alg: Alg("R U2 R D R' U R D' R' U R'")!, postmoves: Alg("U'")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(name: "sa-c", step: "c2", group: "sa", status: .memorizing,
                 alg: Alg("R U R D R' U2 R D' R' U R'")!, postmoves: Alg("U'")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(name: "sa-s", step: "c2", group: "sa", status: .memorizing,
                 alg: Alg("R' D' R U' M' F R F' r' D")!, postmoves: Alg("U'")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),

            Case(name: "ss-p", step: "c2", group: "ss", status: .learned,
                 alg: Alg("D' R' D R U' R' D' R D")!, postmoves: Alg("U'")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(name: "ss-o", step: "c2", group: "ss", status: .learned,
                 alg: Alg("D' R' D R U2 R' D' R D")!, postmoves: Alg(),
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(name: "ss-c", step: "c2", group: "ss", status: .learned,
                 alg: Alg("D' R' D R U R' D' R D")!, postmoves: Alg("U")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(name: "ss-s", step: "c2", group: "ss", status: .training,
                 alg: Alg("M2' U2' r U r' U2' M2' U2' r U r'")!, postmoves: Alg(),
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            
            Case(name: "sd-p", step: "c2", group: "sd", status: .unknown,
                 alg: Alg("B r' D r B r' D' r B2")!, postmoves: Alg(),
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(name: "sd-o", step: "c2", group: "sd", status: .learned,
                 alg: Alg("R' F R U R U' R' F' R U R'")!, postmoves: Alg(),
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(name: "sd-c", step: "c2", group: "sd", status: .unknown,
                 alg: Alg("R' F2 R D' R' D F2 D' R D")!, postmoves: Alg("U")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(name: "sd-s", step: "c2", group: "sd", status: .unknown,
                 alg: Alg("R U' R' U' r' F' r2 F U2 F' r'")!, postmoves: Alg(),
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),

            
            // u
            Case(name: "us-p", step: "c2", group: "us", status: .training,
                 alg: Alg("D' R' D F2 D' R D R' F2 R")!, postmoves: Alg("U2")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            
            Case(name: "ud-p", step: "c2", group: "ud", status: .unknown,
                 alg: Alg("x' D' R U' R' D2 R U R' D' x")!, postmoves: Alg("U")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(name: "ud-o", step: "c2", group: "ud", status: .training,
                 alg: Alg("R' D R U2 R D' R' U2 R D R2' D' R")!, postmoves: Alg("U")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(name: "ud-c", step: "c2", group: "ud", status: .training,
                 alg: Alg("R F' L F x R2' U' r' F R")!, postmoves: Alg("U'")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(name: "ud-s", step: "c2", group: "ud", status: .learned,
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
            Case(name: "Ua", step: "pll", group: "U", status: .memorizing,
                 premoves: nearAUFs, alg: Alg("M2' U M U2 M' U M2'")!,
                 setup: pllSetup, highlights: pllHighlights),
            Case(name: "Ua", step: "pll", group: "U", status: .memorizing,
                 premoves: [], alg: Alg("M2' U M' U2 M U M2'")!,
                 setup: pllSetup, highlights: pllHighlights),
            Case(name: "Ub", step: "pll", group: "U", status: .memorizing,
                 premoves: nearAUFs, alg: Alg("M2' U' M U2 M' U' M2'")!,
                 setup: pllSetup, highlights: pllHighlights),
            Case(name: "Ub", step: "pll", group: "U", status: .memorizing,
                 premoves: [], alg: Alg("M2' U' M' U2' M U' M2'")!,
                 setup: pllSetup, highlights: pllHighlights),
            
            Case(name: "H", step: "pll", group: "H", status: .learned,
                 premoves: [], alg: Alg("M2' U M2' U2 M2' U M2'")!,
                 setup: pllSetup, highlights: pllHighlights),
            
            Case(name: "Z", step: "pll", group: "Z", status: .learned,
                 premoves: mirrorAUFs, alg: Alg("M U M2' U M2' U M U2 M2'")!,
                 setup: pllSetup, highlights: pllHighlights),
            
            // corners
            Case(name: "Aa", step: "pll", group: "A", status: .training,
                 premoves: [], alg: Alg("x L2 D2' L' U' L D2' L' U L' x'")!,
                 setup: pllSetup, highlights: pllHighlights),
            Case(name: "Aa", step: "pll", group: "A", status: .training,
                 premoves: [], alg: Alg("x' L' U L' D2' L U' L' D2' L2 x")!,
                 setup: pllSetup, highlights: pllHighlights),
            Case(name: "Aa", step: "pll", group: "A", status: .training,
                 premoves: [], alg: Alg("x R' U R' D2 R U' R' D2 R2 x'")!,
                 setup: pllSetup, highlights: pllHighlights),
            Case(name: "Aa", step: "pll", group: "A", status: .training,
                 premoves: [], alg: Alg("x' R2 D2 R' U' R D2 R' U R' x")!,
                 setup: pllSetup, highlights: pllHighlights),
            Case(name: "Ab", step: "pll", group: "A", status: .training,
                 premoves: [], alg: Alg("x L U' L D2' L' U L D2' L2' x'")!,
                 setup: pllSetup, highlights: pllHighlights),
            Case(name: "Ab", step: "pll", group: "A", status: .training,
                 premoves: [], alg: Alg("x' L2' D2' L U L' D2' L U' L x")!,
                 setup: pllSetup, highlights: pllHighlights),
            Case(name: "Ab", step: "pll", group: "A", status: .training,
                 premoves: [], alg: Alg("x' R U' R D2 R' U R D2 R2' x")!,
                 setup: pllSetup, highlights: pllHighlights),
            Case(name: "Ab", step: "pll", group: "A", status: .training,
                 premoves: [], alg: Alg("x R2' D2 R U R' D2 R U' R x'")!,
                 setup: pllSetup, highlights: pllHighlights),
            
            Case(name: "E", step: "pll", group: "E", status: .learned,
                 premoves: mirrorAUFs, alg: Alg("R' U' R' D' R U' R' D R U R' D' R U R' D R2")!,
                 setup: pllSetup, highlights: pllHighlights),
            
            // corners and edges
            Case(name: "T", step: "pll", group: "T", status: .unknown,
                 alg: Alg("R U R' U' R' F R2 U' R' U' R U R' F'")!,
                 setup: pllSetup, highlights: pllHighlights),
            
            Case(name: "F", step: "pll", group: "F", status: .unknown,
                 alg: Alg("R' U' F' R U R' U' R' F R2 U' R' U' R U R' U R")!,
                 setup: pllSetup, highlights: pllHighlights),
            
            Case(name: "Jb", step: "pll", group: "J", status: .training,
                 alg: Alg("R U R' F' R U R' U' R' F R2 U' R'")!,
                 setup: pllSetup, highlights: pllHighlights),
            
            Case(name: "Ja", step: "pll", group: "J", status: .training,
                 alg: Alg("x R2 F R F' R U2 r' U r U2 x'")!,
                 setup: pllSetup, highlights: pllHighlights),
            
            Case(name: "Ra", step: "pll", group: "R", status: .training,
                 alg: Alg("R U' R' U' R U R D R' U' R D' R' U2 R'")!,
                 setup: pllSetup, highlights: pllHighlights),
            Case(name: "Rb", step: "pll", group: "R", status: .training,
                 alg: Alg("R2' F R U R U' R' F' R U2' R' U2 R")!,
                 setup: pllSetup, highlights: pllHighlights),
            
            Case(name: "Y", step: "pll", group: "Y", status: .training,
                 alg: Alg("F R U' R' U' R U R' F' R U R' U' R' F R F'")!,
                 setup: pllSetup, highlights: pllHighlights),
            
            Case(name: "V", step: "pll", group: "V", status: .training,
                 alg: Alg("R U' R U R' D R D' R U' D R2' U R2 D' R2'")!,
                 setup: pllSetup, highlights: pllHighlights),
            
            Case(name: "Na", step: "pll", group: "N", status: .training,
                 alg: Alg("R U R' U R U R' F' R U R' U' R' F R2 U' R' U2 R U' R'")!,
                 setup: pllSetup, highlights: pllHighlights),
            Case(name: "Nb", step: "pll", group: "N", status: .training,
                 alg: Alg("r' D' F r U' r' F' D r2 U r' U' r' F r F'")!,
                 setup: pllSetup, highlights: pllHighlights),
            
            Case(name: "Ga", step: "pll", group: "G", status: .memorizing,
                 alg: Alg("R2 U R' U R' U' R U' R2 U' D R' U R D'")!,
                 setup: pllSetup, highlights: pllHighlights),
            Case(name: "Gb", step: "pll", group: "G", status: .memorizing,
                 alg: Alg("R' U' R U D' R2 U R' U R U' R U' R2' D")!,
                 setup: pllSetup, highlights: pllHighlights),
            Case(name: "Gc", step: "pll", group: "G", status: .memorizing,
                 premoves: mirrorAUFs, alg: Alg("R2' U' R U' R U R' U R2 U D' R U' R' D")!,
                 setup: pllSetup, highlights: pllHighlights),
            Case(name: "Gc", step: "pll", group: "G", status: .memorizing,
                 premoves: mirrorAUFs, alg: Alg("R2' F2 R U2 R U2' R' F R U R' U' R' F R2")!,
                 setup: pllSetup, highlights: pllHighlights),
            Case(name: "Gd", step: "pll", group: "G", status: .memorizing,
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

let c2PostScramble: PostScramble = PostScramble(unsolvedCorners: [.UFL, .UFR, .UBR], algOptions: Alg.AUFs)
