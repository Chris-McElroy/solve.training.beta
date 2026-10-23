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
        cases: [
            Case(name: "us-p", step: "c2", group: "main", alg: Alg("D' R' D F2 D' R D R' F2 R")!, keyFacelets: []),
            Case(name: "as-s", step: "c2", group: "main", alg: Alg("R F' r' U D R' D' R U' M' F")!, keyFacelets: []),
        ]
    )
]
