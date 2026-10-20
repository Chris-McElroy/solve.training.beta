//
//  Cube.swift
//  solve.training
//
//  Created by chris on '26.10.18.
//

import SwiftUI
import Combine

class Cube: ObservableObject {
    static var main: Cube = Cube()
    
    @Published var update: Bool = true
//    var corners: [Corner] = [.UFR, .U]
}

struct Corner {
//    var position
}

struct Edge {
    
    
}

struct Center {
    
}

enum Cubie: Int {
    case UFR = 0
}

enum Facelet: Int {
    case Ufr = 0
}

enum CornerPositions: Int {
    case UFR = 0, UFL = 1, UBR = 2, UBL = 3, DFR = 4, DFL = 5, DBR = 6, DBL = 7
}

enum EdgePositions: Int {
    case UF = 0
}

enum CenterPositions: Int {
    case U = 0, D = 1, F = 2, B = 3, R = 4, L = 5
}
