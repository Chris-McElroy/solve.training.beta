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
                    .frame(width: 800, height: 800)
                Spacer()
            }
            Spacer()
        }
        .padding(.all)
        .background(.black)
        .onAppear {
            Cube.main.exec(Move(.x, .c1))
        }
    }
}
