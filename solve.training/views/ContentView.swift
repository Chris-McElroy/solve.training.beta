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
    @State var input: String = ""
    @FocusState var focus: Bool
    @State var progress: Int = 0
    
    var body: some View {
        VStack {
            Spacer()
            Text("usp")
            CubeView()
            Text(algInput.stringStart(completed: progress))
                .foregroundStyle(.green)
                + Text(algInput.stringEnd(completed: progress))
            Spacer()
            ZStack {
                TextField("input", text: $input)
                    .focused($focus)
                    .textFieldStyle(.plain)
                    .opacity(0.0000001)
            }
        }
        .padding(.all)
        .background(.black)
        .onAppear() {
            focus = true
        }
        .onChange(of: input, {
            if input.isEmpty { return }
            let new = input.removeLast()
//            if algInput.moves[progress].inputChr.contains(new) {
//                progress += 1
                guard let move = MoveInput.inputDict[new] else { return } // exec this
                Cube.main.exec(move)
                Cube.main.update.toggle()
//                if progress == algInput.moves.count {
//                    Timer.scheduledTimer(withTimeInterval: 0.15, repeats: false, block: { _ in
//                        progress = 0
//                    })
//                }
//            }
        })
    }
}
