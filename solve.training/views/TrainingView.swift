//
//  TrainingView.swift
//  solve.training
//
//  Created by chris on '26.10.22.
//

import SwiftUI

struct TrainingView: View {
    @State var cases: [Case]
    
    @State var input: String = ""
    @FocusState var focus: Bool
    @State var progress: Int = 0
    @State var cubeView = CubeView()
    @State var currentCase: Case? = nil
    @State var alg: AlgInput = AlgInput(alg: Alg([]))
    @State var mistake: Bool = false
    
    var body: some View {
        ZStack { // todo make this background
            TextField("input", text: $input)
                .focused($focus)
                .textFieldStyle(.plain)
                .opacity(0.0000001)
            cubeView  // laterDO check that i'm not making way too many cubies or maintatining them after the cubeview leaves. could consider having it only ever be one cube but that seems bad
                .frame(height: 800)
            VStack {
                Spacer()
                Text(currentCase?.name ?? "")
                    .font(.custom("Rubik-Bold", size: 100))
                Spacer().frame(height: 500)
                HStack(spacing: 0) {
                    Text(alg.text.dropLast(alg.text.count - progress).joined(separator: ""))
                        .foregroundStyle(.green)
                    if progress < alg.text.count {
                        Text(alg.text[progress])
                            .foregroundStyle(mistake ? .red : .white)
                        if progress < (alg.text.count - 1) {
                            Text(alg.text.dropFirst(progress + 1).joined(separator: ""))
                                .foregroundStyle(.tertiary)
                        }
                    }
                }
                .font(.custom("Rubik-Regular", size: 80))
                Spacer()
            }
        }
        .padding(.all)
        .background(.black)
        .onAppear() {
            focus = true
            
            // TODO fold into funciton for this
            // TODO implement highlighted cubies
            // TODO implement transparency toggle
            // TODO add postmoves
            // TODO add c3 cases but don't select them for now
            // TODO use c3 cases to further scramble things
            // TODO add timer and stop at the end
            
            
            // todos for list
            // TODO add method list view with free cube option
            // TODO record case stats
            // TODO add case list view with colors and case things and times per notes
            // TODO add case popup with cube preview, allow me to edit learning status
            // TODO add search to case list view
            // TODO add all the algs for c2 and c3, make this the full replacement for alpha
            if let newCase = cases.randomElement() {
                currentCase = newCase
            }
            guard let currentCase else { return }
            progress = 0
            Cube.main.pieces = Cube.solvedCube
            let newAlg: Alg
            if let premove = currentCase.premoves.randomElement() as? Alg {
                newAlg = Alg(pre: premove, currentCase.alg)
            } else {
                newAlg = currentCase.alg
            }
            alg = AlgInput(alg: newAlg)
            Cube.main.scramble(newAlg)
            Cube.main.update.toggle()
        }
        .onChange(of: focus, { focus = true })
        .onChange(of: input, {
            if input.isEmpty { return }
            let new = input.removeLast()
            guard alg.moves[progress].inputChr.contains(new) else {
                mistake = true
                return
            }
            mistake = false
            Cube.main.exec(alg.moves[progress].move)
            Cube.main.update.toggle()
            progress += 1
            
            if progress == alg.moves.count {
                Timer.scheduledTimer(withTimeInterval: 0.15, repeats: false, block: { _ in
                    if let newCase = cases.drop(while: { $0 === currentCase }).randomElement() {
                        currentCase = newCase
                    }
                    guard let currentCase else { return }
                    progress = 0
                    Cube.main.pieces = Cube.solvedCube
                    let newAlg: Alg
                    if let premove = currentCase.premoves.randomElement() as? Alg {
                        newAlg = Alg(pre: premove, currentCase.alg)
                    } else {
                        newAlg = currentCase.alg
                    }
                    alg = AlgInput(alg: newAlg)
                    Cube.main.scramble(newAlg)
                    Cube.main.update.toggle()
                })
            }
        })
    }
}
