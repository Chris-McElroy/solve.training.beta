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
    @State var success: Bool = true
    @State var casesDone: Int = 0
    @State var startTime: TimeInterval = Date().timeIntervalSinceReferenceDate
    @State var successfulCases: Int = 0
    @State var showEndCard: Bool = false
    
    var body: some View {
        ZStack {
            TextEditor(text: $input)
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
            if showEndCard {
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        Text("you trained \(casesDone) cases!")
                            .font(.custom("Rubik-Bold", size: 70))
                        Spacer()
                            .frame(height: 300) // laterDO track stats and put them here
                        /*
                         it should be a table that has rows for total, then each learning status that was trained
                         and shows full stats totalling across learning status type
                         columns for all of these:
                         number of cases done (double counting repeated cases)
                         percent success (idk best way to say this)
                         total exec recog /move times
                         */
                        Text("retrain")
                            .font(.custom("Rubik-Regular", size: 40))
                            .padding(.all, 30)
                            .background(.pink)
                            .cornerRadius(40)
                            .onTapGesture {
                                startNewTraining()
                            }
                        // laterDO add exit button
                        Spacer()
                    }
                    Spacer()
                }
                .background(.black)
                
            }
        }
        .padding(.all)
        .background(.black)
        .onAppear() {
            focus = true
            startNewTraining()
        }
        .onChange(of: focus, { focus = true })
        .onChange(of: input, {
            processInput()
        })
    }
    
    func startNewTraining() {
        currentCase = nil
        showEndCard = false
        casesDone = 0
        successfulCases = 0
        startTime = Date().timeIntervalSinceReferenceDate
        newCase()
    }
    
    func newCase() {
        if let currentCase {
            casesDone += 1
            if success {
                successfulCases += 1
            } else {
                success = true
            }
            
            if Date().timeIntervalSinceReferenceDate - startTime >= 60 {
                showEndCard = true
                return
            }
            
            if let newCase = cases.drop(while: { $0 === currentCase }).randomElement() {
                self.currentCase = newCase
            }
        } else if let newCase = cases.randomElement() {
            currentCase = newCase
        }
        guard let currentCase else { return }
        progress = 0
        success = true
        Cube.main.pieces = Cube.solvedCube
        // i think postmoves go here??
        for (position, highlight) in currentCase.highlights {
            Cube.main.pieces[position.rawValue].highlights = highlight
        }
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
    
    func processInput() {
        if input.isEmpty { return }
        let new = input.removeLast()
        
        if new == " " {
            Cube.main.transparent.toggle()
            Cube.main.update.toggle()
            return
        } else if new == "\n" {
            if showEndCard {
                startNewTraining()
            }
            return
        }
        
        guard alg.moves[progress].inputChr.contains(new) else {
            mistake = true
            success = false
            return
        }
        mistake = false
        Cube.main.exec(alg.moves[progress].move)
        Cube.main.update.toggle()
        progress += 1
        
        if progress == alg.moves.count {
            Timer.scheduledTimer(withTimeInterval: 0.15, repeats: false, block: { _ in
                newCase()
            })
        }
    }
}
