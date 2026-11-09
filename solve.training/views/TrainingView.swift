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
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    manager.cubeView  // laterDO check that i'm not making way too many cubies or maintatining them after the cubeview leaves. could consider having it only ever be one cube but that seems bad
                        .frame(maxWidth: 800, maxHeight: 800)
                        .scaledToFit()
                        .minimumScaleFactor(0.01)
                        .opacity(!(manager.started) || (manager.trainingMode != .noCube) || (manager.mistake) ? 1 : 0)
                    Spacer()
                }
                Spacer()
            }
            VStack {
                Spacer().frame(minHeight: 200)
                Text(manager.currentCase?.base.name ?? "")
                    .frame(minWidth: 300, maxWidth: 500, minHeight: 25, maxHeight: 150)
                    .scaledToFit()
                    .font(.custom("Rubik-Bold", size: 100))
                    .opacity((manager.trainingMode == .learning) ? 1 : 0)
                Spacer().frame(height: 400)
                HStack(spacing: 0) {
                    Spacer()
                    Text(manager.completedText)
                        .foregroundStyle(.green)
                    Text(manager.currentText)
                        .foregroundStyle((manager.mistake) ? .red : .white)
                        .opacity((manager.trainingMode == .learning) || (manager.mistake) ? 1 : 0)
                    Text(manager.upcomingText)
                        .foregroundStyle(.tertiary)
                        .opacity((manager.trainingMode == .learning) ? 1 : 0)
                    Spacer()
                }
                .font(.custom("Rubik-Regular", size: 80))
                .frame(minHeight: 25)
                Spacer()
                    .frame(minHeight: 200)
            }
            .scaledToFit()
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
