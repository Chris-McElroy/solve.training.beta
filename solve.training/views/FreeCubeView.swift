//
//  FreeCubeView.swift
//  solve.training
//
//  Created by chris on '26.11.7.
//

import SwiftUI

struct FreeCubeView: View {
    @ObservedObject var manager = Manager.main
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                manager.cubeView
                    .frame(maxWidth: 800, maxHeight: 800)
                    .scaledToFit()
                    .minimumScaleFactor(0.01)
                Spacer()
            }
            Spacer()
        }
        .padding(.all)
        .background(.black)
//        .onAppear { // for Tim
//            Cube.main.exec(Move(.x, .c1))
//        }
    }
}
