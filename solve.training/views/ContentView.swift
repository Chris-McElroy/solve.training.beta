//
//  ContentView.swift
//  solve.training
//
//  Created by chris on '26.10.15.
//

import SwiftUI

let alg = Alg("D' R' D F2 D' R D R' F2 R")!
let algInput: AlgInput = AlgInput(alg: alg)

struct ContentView: View {
    var body: some View {
        TrainingView()
    }
}

// code for free solving:
//guard let move = MoveInput.inputDict[new] else { return } // exec this
//Cube.main.exec(move)
//Cube.main.update.toggle()
