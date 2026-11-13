//
//  HelpView.swift
//  solve.training
//
//  Created by chris on '26.11.8.
//

import SwiftUI

struct HelpView: View {
    @ObservedObject var manager = Manager.main
    
    var body: some View {
        ZStack {
            Spacer()
            if manager.showInfo {
                Rectangle()
                    .background(.black)
                    .opacity(0.6)
                    .onTapGesture {
                        manager.showInfo = false
                    }
                HStack(spacing: 0) {
                    Spacer()
                        .frame(width: 200)
                    VStack(spacing: 0) {
                        Spacer()
                            .frame(height: 200)
                        HStack {
                            Spacer()
                            VStack(spacing: 20) {
                                Spacer()
                                Text("space to toggle\nenter to exit\ntab to reset\nclick here for button info")
                                Spacer().frame(height: 20)
                                Text("y'    D'    L'    x     z'        B     B'    R     D     y")
                                Text("y'    D     L     U'    F'        F     U     R'    D'    y")
                                Text("M     M'    E     x'    S'        S     z     E'    M'    M")
                                Spacer()
                            }
                            .font(.custom("Rubik", size: 25))
                            Spacer()
                        }
                        .background(.black)
                        Spacer()
                            .frame(height: 200)
                    }
                    Spacer()
                        .frame(width: 200)
                }
            }
        }
    }
}
