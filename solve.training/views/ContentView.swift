//
//  ContentView.swift
//  solve.training
//
//  Created by chris on '26.10.15.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var manager = Manager.main
    @State var input: String = ""
    
    @FocusState var focus: Bool
    
    var body: some View {
        ZStack {
            TextEditor(text: $input)
                .focused($focus)
                .onAppear {
                    focus = true
                }
                .onChange(of: focus) {
                    focus = true
                }
                .onChange(of: input) {
                    if input.isEmpty { return }
                    
                    let newInput = input.removeLast()
                    input = ""
                    
                    Manager.main.process(newInput)
                }
            VStack {
                if manager.view == .training {
                    TrainingView()
                } else if manager.view == .freeCube {
                    FreeCubeView()
                }
            }
        }
//        .focusable()
//        .onKeyPress { key in
//            DispatchQueue.main.async { // wait till next event cycle
//                Manager.main.keyPressed(key)
//            }
//            return .handled
//        }
    }
}

// code for free solving:
//guard let move = MoveInput.inputDict[new] else { return } // exec this
//Cube.main.exec(move)
//Cube.main.update.toggle()
