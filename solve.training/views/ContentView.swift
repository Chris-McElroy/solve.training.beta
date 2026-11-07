//
//  ContentView.swift
//  solve.training
//
//  Created by chris on '26.10.15.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var manager = Manager.main
    
    var body: some View {
        VStack {
            if manager.view == .training {
                TrainingView()
            } else if manager.view == .freeCube {
                FreeCubeView()
            }
        }
        .focusable()
        .onKeyPress { key in
            DispatchQueue.main.async { // wait till next event cycle
                Manager.main.keyPressed(key)
            }
            return .handled
        }
    }
}

// code for free solving:
//guard let move = MoveInput.inputDict[new] else { return } // exec this
//Cube.main.exec(move)
//Cube.main.update.toggle()
