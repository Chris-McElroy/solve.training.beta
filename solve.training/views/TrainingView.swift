//
//  TrainingView.swift
//  solve.training
//
//  Created by chris on '26.10.22.
//

import SwiftUI

struct TrainingView: View {
    @ObservedObject var manager = Manager.main
    
    var body: some View {
        ZStack {
            manager.cubeView  // laterDO check that i'm not making way too many cubies or maintatining them after the cubeview leaves. could consider having it only ever be one cube but that seems bad
                .frame(width: 800, height: 800)
                .opacity(!(manager.currentCase?.started ?? false) || (manager.trainingMode != .noCube) || (manager.currentCase?.mistake ?? false) ? 1 : 0)
            VStack {
                Spacer()
                Text(manager.currentCase?.base.name ?? "")
                    .scaledToFit()
                    .font(.custom("Rubik-Bold", size: 100))
                    .opacity((manager.trainingMode == .learning) ? 1 : 0)
                Spacer().frame(height: 500)
                HStack(spacing: 0) {
                    Spacer()
                    Text(manager.completedText)
                        .foregroundStyle(.green)
                    Text(manager.currentText)
                        .foregroundStyle((manager.currentCase?.mistake ?? false) ? .red : .white)
                        .opacity((manager.trainingMode == .learning) || (manager.currentCase?.mistake ?? false) ? 1 : 0)
                    Text(manager.upcomingText)
                        .foregroundStyle(.tertiary)
                        .opacity((manager.trainingMode == .learning) ? 1 : 0)
                    Spacer()
                }
                .scaledToFit()
                .font(.custom("Rubik-Regular", size: 80))
                Spacer()
            }
            .minimumScaleFactor(0.01)
            .lineLimit(1)
            if manager.trainingEndCard {
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        Text("you trained \(manager.casesDone) case\(manager.casesDone > 1 ? "s" : "")!")
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
                        Text("enter to exit")
                            .font(.custom("Rubik-Regular", size: 50))
                        Spacer().frame(height: 40)
                        Text("space to retrain")
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
            manager.startNewTraining()
        }
    }
}

enum TrainingMode {
    case learning, noAlg, noCube
}
