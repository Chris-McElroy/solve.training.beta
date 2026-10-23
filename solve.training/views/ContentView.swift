//
//  ContentView.swift
//  solve.training
//
//  Created by chris on '26.10.15.
//

import SwiftUI

struct ContentView: View {
    @State var cases: [Case] = methods.first!.cases
    
    var body: some View {
        TrainingView(cases: cases)
    }
}

// code for free solving:
//guard let move = MoveInput.inputDict[new] else { return } // exec this
//Cube.main.exec(move)
//Cube.main.update.toggle()
