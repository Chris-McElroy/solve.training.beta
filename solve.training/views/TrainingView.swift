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
    @State var cubeView = CubeView()
    @State var currentCase: TrainingCase? = nil
    @State var currentCaseIndex: Int? = nil
    @State var casesDone: Int = 0
    @State var startTime: TimeInterval = Date().timeIntervalSinceReferenceDate
    @State var successfulCases: Int = 0
    @State var showEndCard: Bool = false
    @State var mode: TrainingMode = .learning
    
    var body: some View {
        ZStack {
            TextEditor(text: $input)
                .focused($focus)
                .textFieldStyle(.plain)
                .opacity(0.0000001)
            cubeView  // laterDO check that i'm not making way too many cubies or maintatining them after the cubeview leaves. could consider having it only ever be one cube but that seems bad
                .frame(width: 800, height: 800)
                .opacity(!(currentCase?.started ?? false) || (mode != .noCube) || (currentCase?.mistake ?? false) ? 1 : 0)
            VStack {
                Spacer()
                Text(currentCase?.base.name ?? "")
                    .font(.custom("Rubik-Bold", size: 100))
                    .opacity((mode == .learning) ? 1 : 0)
                Spacer().frame(height: 500)
                HStack(spacing: 0) {
                    Text(currentCase?.completedText ?? "")
                        .foregroundStyle(.green)
                    Text(currentCase?.currentText ?? "")
                        .foregroundStyle((currentCase?.mistake ?? false) ? .red : .white)
                        .opacity((mode == .learning) || (currentCase?.mistake ?? false) ? 1 : 0)
                    Text(currentCase?.upcomingText ?? "")
                        .foregroundStyle(.tertiary)
                        .opacity((mode == .learning) ? 1 : 0)
                }
                .font(.custom("Rubik-Regular", size: 80))
                Spacer()
            }
            if showEndCard {
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        Text("you trained \(casesDone) case\(casesDone > 1 ? "s" : "")!")
                            .font(.custom("Rubik-Bold", size: 70))
                        Spacer().frame(height: 300) // laterDO track stats and put them here
                        /*
                         it should be a table that has rows for total, then each learning status that was trained
                         and shows full stats totalling across learning status type
                         columns for all of these:
                         number of cases done (double counting repeated cases)
                         percent success (idk best way to say this)
                         total exec recog /move times
                         */
                        Text("enter to retrain")
                            .font(.custom("Rubik-Regular", size: 50))
                        Spacer().frame(height: 40)
                        Text("space to exit")
                            .font(.custom("Rubik-Regular", size: 50))
//                            .padding(.horizontal, 60)
//                            .padding(.vertical, 35)
//                            .background(Color(hue: 0.842, saturation: 1, brightness: 1))
//                            .cornerRadius(10)
//                            .onTapGesture {
//                                startNewTraining()
//                            }
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
            if input.isEmpty { return }
            
            let inputChr = input.removeLast()
            
            if inputChr == "\n" {
                if showEndCard {
                    startNewTraining()
                }
                return
            }
            currentCase?.processInput(inputChr)
            
            if currentCase?.finished ?? false {
                Timer.scheduledTimer(withTimeInterval: 0.15, repeats: false, block: { _ in
                    newCase()
                })
            }
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
        if currentCase?.base.status == .memorizing && mode == .learning {
            mode = .noAlg
            currentCase?.reset()
            return
        }
        
        if let currentCaseIndex {
            casesDone += 1
            if currentCase?.success ?? false {
                successfulCases += 1
            }
            
            if Date().timeIntervalSinceReferenceDate - startTime >= 60 {
                showEndCard = true
                return
            }
            
            if cases.count > 1 {
                var newIndex = (0..<(cases.count - 1)).randomElement() ?? 0
                if newIndex >= currentCaseIndex {
                    newIndex += 1
                }
                self.currentCaseIndex = newIndex
            }
        } else {
            currentCaseIndex = (0..<cases.count).randomElement() ?? 0
        }
        
        currentCase = TrainingCase(from: cases[currentCaseIndex ?? 0])
        
        switch currentCase?.base.status ?? .unknown {
        case .unknown, .memorizing: mode = .learning
        case .training: mode = .noAlg
        case .learned: mode = .noCube
        }
    }
}

enum TrainingMode {
    case learning, noAlg, noCube
}
