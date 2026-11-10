//
//  Manager.swift
//  solve.training
//
//  Created by chris on '26.11.7.
//

import SwiftUI
import Combine

class Manager: ObservableObject {
    static var main = Manager()
    
    @Published var view: ViewOptions = .freeCube
    @Published var trainingEndCard: Bool = false
    
    @Published var cases: [Case] = methods[1].cases //.filter { $0.status == .memorizing }
    @Published var currentCase: TrainingCase? = nil
    @Published var currentCaseIndex: Int? = nil
    
    @Published var casesDone: Int = 0
    @Published var startTime: TimeInterval = Date().timeIntervalSinceReferenceDate
    @Published var successfulCases: Int = 0
    @Published var trainingMode: TrainingMode = .learning
    
    @Published var completedText: String = ""
    @Published var currentText: String = ""
    @Published var upcomingText: String = ""
    
    @Published var mistake: Bool = false
    @Published var success: Bool = true
    @Published var started: Bool = false
    @Published var finished: Bool = false
    
    var cubeView = CubeView()
    
    #if os(iOS)
    func process(_ input: Character) {
        if view == .freeCube {
            if input == " " {
                Cube.main.right.toggle()
                Cube.main.update.toggle()
            } else if input == "\n" {
                view = .training
                return
            } else {
                Cube.main.exec(from: input)
            }
            return
        }
        
        if input == "\n" {
            view = .freeCube
            Cube.main.reset(right: true)
            return
        }
        
        if trainingEndCard {
            if input == " " {
                startNewTraining()
            }
            return
        }
        
        currentCase?.processInput(input)
        
        if finished {
            Timer.scheduledTimer(withTimeInterval: 0.15, repeats: false, block: { _ in
                self.newCase()
            })
        }
        
        return
    }
    #endif
    
    #if os(macOS)
    func process(input: KeyPress) {
        if view == .freeCube {
            if input.key == .space {
                Cube.main.right.toggle()
                Cube.main.update.toggle()
            } else if input.key == .return {
                view = .training
                return
            } else if let inputChr = input.characters.first {
                Cube.main.exec(from: inputChr)
            }
            return
        }
        
        if input.key == .return {
            view = .freeCube
            Cube.main.reset(right: true)
            return
        }
        
        if trainingEndCard {
            if input.key == .space {
                startNewTraining()
            }
            return
        }
        
        if let inputChr = input.characters.first {
            currentCase?.processInput(inputChr)
        }
        
        if finished {
            Timer.scheduledTimer(withTimeInterval: 0.15, repeats: false, block: { _ in
                self.newCase()
            })
        }
        
        return
    }
    #endif
    
    func startNewTraining() {
        trainingEndCard = false
        currentCaseIndex = nil
        currentCase = nil
        newCase()
        startTime = Date().timeIntervalSinceReferenceDate
        casesDone = 0
        successfulCases = 0
    }
    
    
    func newCase() {
        if currentCase?.base.status == .memorizing && trainingMode == .learning {
            trainingMode = .noAlg
            currentCase?.reset()
            return
        }
        
        if let currentCaseIndex {
//            Storage.
            
            casesDone += 1
            if success {
                successfulCases += 1
            }
            
            if Date().timeIntervalSinceReferenceDate - startTime >= 60 {
                trainingEndCard = true
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
        mistake = false
        success = true
        started = false
        finished = false
        
        switch currentCase?.base.status ?? .unknown {
        case .unknown, .memorizing: trainingMode = .learning
        case .training: trainingMode = .noAlg
        case .learned: trainingMode = .noCube
        }
    }
}

enum ViewOptions {
    case training, freeCube
}
