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
        VStack {
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
            } else {
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        Text(manager.currentCase?.base.name ?? "")
                            .frame(minWidth: 200, maxWidth: 800, minHeight: 40, maxHeight: 150)
                            .scaledToFit()
                            .minimumScaleFactor(0.01)
                            .font(.custom("Rubik-Bold", size: 100))
                            .opacity((manager.trainingMode == .learning || !manager.success) ? 1 : 0)
                        Spacer()
                        HStack {
                            Spacer()
                                manager.cubeView  // laterDO check that i'm not making way too many cubies or maintatining them after the cubeview leaves. could consider having it only ever be one cube but that seems bad
                                .frame(minWidth: 250, maxWidth: 600, minHeight: 250, maxHeight: 600)
                                    .scaledToFit()
                                    .minimumScaleFactor(0.01)
                                    .opacity(!(manager.started) || (manager.trainingMode != .noCube) || (!manager.success) ? 1 : 0)
                            Spacer()
                        }
                        Spacer()
                        textView
                        Spacer()
                    }
                    .lineLimit(1)
                    Spacer()
                }
            }
        }
        .padding(.all)
        .background(.black)
        .onAppear() {
            manager.startNewTraining()
        }
    }
    
    var textView: some View {
        HStack(spacing: 0) {
            Spacer()
            Text(manager.completedText)
                .foregroundStyle(.green) +
            Text(manager.currentText)
                .foregroundStyle((manager.trainingMode == .learning) || (!manager.success) ? ((manager.mistake) ? .red : .white) : .black) +
            Text(manager.upcomingText)
                .foregroundStyle((manager.trainingMode == .learning || (!manager.success)) ? .gray.opacity(0.5) : .black)
            Spacer()
        }
        .font(.custom("Rubik-Regular", size: 80))
        .frame(minWidth: 300, maxWidth: 1200, minHeight: 40, maxHeight: 100)
        .scaledToFit()
        .minimumScaleFactor(0.01)
    }
}

enum TrainingMode {
    case learning, noAlg, noCube
}
