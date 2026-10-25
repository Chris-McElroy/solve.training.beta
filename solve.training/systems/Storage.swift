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
        // laterDO make .U2 move shortcut
        cases: [
            Case(name: "us-p", step: "c2", group: "main", alg: Alg("D' R' D F2 D' R D R' F2 R")!, setup: c2Setup, postmoves: Alg("U2")!, highlights: [.DFR: [0, 1, 2], .UBL: [0, 1, 2]]),
            Case(name: "as-s", step: "c2", group: "main", alg: Alg("R F' r' U D R' D' R U' M' F")!, setup: c2Setup, postmoves: Alg("U2")!, highlights: [.DFR: [0, 1, 2], .UBL: [0, 1, 2]]),
        ]
    )
]

let c2Setup: [Setup] = [Setup(pre: Alg(), post: Alg()), Setup(pre: Alg("D")!, post: Alg("D'")!, right: false)]

