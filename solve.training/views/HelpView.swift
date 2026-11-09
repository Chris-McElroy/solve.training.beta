//
//  HelpView.swift
//  solve.training
//
//  Created by chris on '26.11.8.
//

import SwiftUI

struct HelpView: View {
    @State var showHelp: Bool = false // laterDO move to manager
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                VStack(spacing: 0) {
                    Spacer()
                    VStack(spacing: 7) {
                        Spacer()
                        Text("space to toggle\nenter to exit\ntab to reset\nclick here for button info")
                            .font(.custom("Rubik", size: 20))
                            .lineSpacing(7)
                            .multilineTextAlignment(.leading)
                        Spacer().frame(height: 10)
                    }
                    .frame(width: 300, height: 150)
                    .background(.black)
                    .onTapGesture {
                        showHelp = true
                    }
                }
                Spacer()
            }
            if showHelp {
                Rectangle()
                    .background(.black)
                    .opacity(0.6)
                    .onTapGesture {
                        showHelp = false
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
