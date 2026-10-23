//
//  TrainingView.swift
//  solve.training
//
//  Created by chris on '26.10.22.
//

import SwiftUI

struct TrainingView: View {
    @State var input: String = ""
    @FocusState var focus: Bool
    @State var progress: Int = 0
    @State var cubeView = CubeView()
    @State var cases: [Case] = []
    @State var currentCase: Case = Case(name: "", step: "", group: "", alg: Alg([]), keyFacelets: [])
    
    var body: some View {
        ZStack { // todo make background
            TextField("input", text: $input)
                .focused($focus)
                .textFieldStyle(.plain)
                .opacity(0.0000001)
            VStack {
                Spacer()
                Text(currentCase.name)
                cubeView  // laterDO check that i'm not making way too many cubies or maintatining them after the cubeview leaves. could consider having it only ever be one cube but that seems bad
                Text(algInput.stringStart(completed: progress))
                    .foregroundStyle(.green)
                + Text(algInput.stringEnd(completed: progress))
                Spacer()
                
            }
        }
        .padding(.all)
        .background(.black)
        .onAppear() {
            focus = true
        }
        .onChange(of: focus, { focus = true })
        .onChange(of: input, {
            if input.isEmpty { return }
            let new = input.removeLast()
            if algInput.moves[progress].inputChr.contains(new) {
                progress += 1
                Cube.main.exec(algInput.moves[progress].move)
                Cube.main.update.toggle()
                if progress == algInput.moves.count {
                    Timer.scheduledTimer(withTimeInterval: 0.15, repeats: false, block: { _ in
                        progress = 0
                    })
                }
            }
        })
    }
}
