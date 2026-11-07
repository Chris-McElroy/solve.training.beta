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
    
    @Published var cases: [Case] = methods.first!.cases.filter({ $0.status == .unknown })
    @Published var currentCase: TrainingCase? = nil
    @Published var currentCaseIndex: Int? = nil
    
    @Published var casesDone: Int = 0
    @Published var startTime: TimeInterval = Date().timeIntervalSinceReferenceDate
    @Published var successfulCases: Int = 0
    @Published var trainingMode: TrainingMode = .learning
    
    @Published var completedText: String = ""
    @Published var currentText: String = ""
    @Published var upcomingText: String = ""
    
    var cubeView = CubeView()
    
    func keyPressed(_ key: KeyPress) {
        if view == .freeCube {
            if key.key == .space {
                Cube.main.right.toggle()
                Cube.main.update.toggle()
            } else if key.key == .return {
                view = .training
                return
            } else if let input = key.characters.first {
                Cube.main.exec(from: input)
            }
            return
        }
        
        if trainingEndCard {
            if key.key == .space {
                startNewTraining()
            } else if key.key == .return {
                view = .freeCube
                Cube.main.reset(right: true)
            }
            return
        }
        
        currentCase?.processInput(key.characters.first ?? " ")
        
        if currentCase?.finished ?? false {
            Timer.scheduledTimer(withTimeInterval: 0.15, repeats: false, block: { _ in
                self.newCase()
            })
        }
        
        return
    }
    
    func startNewTraining() {
        trainingEndCard = false
        currentCaseIndex = nil
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
            casesDone += 1
            if currentCase?.success ?? false {
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
