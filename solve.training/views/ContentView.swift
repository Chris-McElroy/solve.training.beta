//
//  ContentView.swift
//  solve.training
//
//  Created by chris on '26.10.15.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var manager = Manager.main
    
    
    #if os(iOS)
    @State var input: String = ""
    @FocusState var focus: Bool
    #endif
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("solve.training")
                    .font(.custom("Rubik", size: 30))
                Spacer()
                Image(systemName: "info.circle.fill")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .padding(5)
                    .onTapGesture {
                        Manager.main.showInfo = true
                    }
                Spacer().frame(width: 5)
                Image(systemName: "gearshape.fill")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .padding(5)
            }
            .frame(height: 30)
            .padding(.all, 10)
            .background(.black)
            if manager.view == .training {
                TrainingView()
            } else if manager.view == .freeCube {
                FreeCubeView()
            }
        }
        .overlay {
            HelpView()
        }
    #if os(macOS)
    .focusable()
    .focusEffectDisabled()
    .onKeyPress { key in
        DispatchQueue.main.async { // wait till next event cycle
            Manager.main.process(input: key)
        }
        return .handled
    }
    #endif
        #if os(iOS)
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
            .opacity(0.001)
        #endif
    }
}

// code for free solving:
//guard let move = MoveInput.inputDict[new] else { return } // exec this
//Cube.main.exec(move)
//Cube.main.update.toggle()
