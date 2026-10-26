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
            Step(name: "3eu", color: .brown),
            Step(name: "2c", color: .purple),
            Step(name: "3c", color: .pink),
        ],
        groups: [
            Group(name: "main", color: .black)
        ],
        // laterDO make .U2 move shortcut and alg shortcut for postmoves alg
        cases: [
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
            
            Case(name: "as-p", step: "c2", group: "as", status: .memorizing,
                 alg: Alg("R U' R D R' U2 R D' R' U' R'")!, postmoves: Alg(),
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(name: "as-o", step: "c2", group: "as", status: .memorizing,
                 alg: Alg("R U' R D R' U' R D' R' U2 R'")!, postmoves: Alg("U")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(name: "as-c", step: "c2", group: "as", status: .memorizing,
                 alg: Alg("r' F' r D' r' F2 r D r' F' r")!, postmoves: Alg("U")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(name: "as-s", step: "c2", group: "as", status: .memorizing,
                 alg: Alg("R F' r' U D R' D' R U' M' F")!, postmoves: Alg("U2")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            
            Case(name: "ad-p", step: "c2", group: "ad", status: .memorizing,
                 alg: Alg("D' r U2 r' D L D' F2' D L'")!, postmoves: Alg("U2")!,
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

            Case(name: "us-p", step: "c2", group: "us", status: .memorizing,
                 alg: Alg("D' R' D F2 D' R D R' F2 R")!, postmoves: Alg("U2")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            
            Case(name: "ud-p", step: "c2", group: "ud", status: .memorizing,
                 alg: Alg("B' U' B R2' B' U B U' R2")!, postmoves: Alg(),
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(name: "ud-o", step: "c2", group: "ud", status: .memorizing,
                 alg: Alg("R' D R U2 R D' R' U2 R D R2 D' R")!, postmoves: Alg("U")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(name: "ud-c", step: "c2", group: "ud", status: .memorizing,
                 alg: Alg("R F' L F x R2' U' r' F R")!, postmoves: Alg("U'")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
            Case(name: "ud-s", step: "c2", group: "ud", status: .learned,
                 alg: Alg("R U' R' U R U' R' U R U' R'")!, postmoves: Alg("U2")!,
                 setup: c2Setup,  postScramble: c2PostScramble, highlights: c2Highlights),
        ]
    )
]

let c2Highlights: [Position: [Int]] = [.DFR: [0, 1, 2], .UBL: [0, 1, 2]]

let c2Setup: [Setup] = [Setup(pre: Alg(), post: Alg()), Setup(pre: Alg("D")!, post: Alg("D'")!, right: false)]

let c2PostScramble: PostScramble = PostScramble(unsolvedCorners: [.UFL, .UFR, .UBR], algOptions: Alg.AUFs)
