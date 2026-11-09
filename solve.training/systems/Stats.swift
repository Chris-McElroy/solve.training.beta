//
//  Stats.swift
//  solve.training
//
//  Created by chris on '26.11.8.
//

import Foundation

struct Stats {
    var attempts: Int
    var success: [Bool]
    var tps: [Double]
    var recog: [Double]
    var exec: [Double]
    var total: [Double]
    var date: [Double]
    
    var tpsPB: Double
    var recogPB: Double
    var execPB: Double
    var totalPB: Double
    
    init() {
        attempts = 0
        
        success = []
        tps = []
        recog = []
        exec = []
        total = []
        date = []
        
        tpsPB = Double.greatestFiniteMagnitude
        recogPB = Double.greatestFiniteMagnitude
        execPB = Double.greatestFiniteMagnitude
        totalPB = Double.greatestFiniteMagnitude
    }
    
    init?(from dict: [String: Any]) {
        guard let attempts = dict[Key.attempts.rawValue] as? Int else { return nil }
        
        guard let success = dict[Key.success.rawValue] as? [Bool] else { return nil }
        guard let tps = dict[Key.tps.rawValue] as? [Double] else { return nil }
        guard let recog = dict[Key.recog.rawValue] as? [Double] else { return nil }
        guard let exec = dict[Key.exec.rawValue] as? [Double] else { return nil }
        guard let total = dict[Key.total.rawValue] as? [Double] else { return nil }
        guard let date = dict[Key.date.rawValue] as? [Double] else { return nil }
        
        guard let tpsPB = dict[Key.tpsPB.rawValue] as? Double else { return nil }
        guard let recogPB = dict[Key.recogPB.rawValue] as? Double else { return nil }
        guard let execPB = dict[Key.execPB.rawValue] as? Double else { return nil }
        guard let totalPB = dict[Key.totalPB.rawValue] as? Double else { return nil }
        
        self.attempts = attempts
        
        self.success = success
        self.tps = tps
        self.recog = recog
        self.exec = exec
        self.total = total
        self.date = date
        
        self.tpsPB = tpsPB
        self.recogPB = recogPB
        self.execPB = execPB
        self.totalPB = totalPB
    }
    
    func toDict() -> [String: Any] {
        [
            Key.attempts.rawValue: attempts,
            
            Key.success.rawValue: success,
            Key.tps.rawValue: tps,
            Key.recog.rawValue: recog,
            Key.exec.rawValue: exec,
            Key.total.rawValue: total,
            Key.date.rawValue: date,
            
            Key.tpsPB.rawValue: tpsPB,
            Key.recogPB.rawValue: recogPB,
            Key.execPB.rawValue: execPB,
            Key.totalPB.rawValue: totalPB,
        ]
    }
    
    mutating func addAttempt(success: Bool, moves: Int, recog: Double, exec: Double) -> [Key: Bool] {
        attempts += 1
        
        if attempts > 10 {
            self.success.removeFirst()
            self.tps.removeFirst()
            self.recog.removeFirst()
            self.exec.removeFirst()
            self.total.removeFirst()
            self.date.removeFirst()
        }
        
        let total = recog + exec
        let tps = (recog + exec)/Double(moves)
        
        self.success.append(success)
        self.tps.append(tps)
        self.recog.append(recog)
        self.exec.append(exec)
        self.total.append(total)
        self.date.append(Date().timeIntervalSinceReferenceDate)
        
        var newPB: [Key: Bool] = [.tpsPB: tps > tpsPB,
                                  .recogPB: recog < recogPB,
                                  .execPB: exec < execPB,
                                  .totalPB: total < totalPB,
                                  ]
        
        if newPB[.tpsPB] ?? false {
            tpsPB = tps
        }
        
        if newPB[.recogPB] ?? false {
            recogPB = recog
        }
        
        if newPB[.execPB] ?? false {
            execPB = exec
        }
        
        if newPB[.totalPB] ?? false {
            totalPB = total
        }
        
        return newPB
    }
}

struct SessionStats {
    var cases: Int = 0
    var caseIDs: Set<String> = []
    
    var success: [CaseStatus: [Bool]] = [:]
    var tps: [CaseStatus: [Double]] = [:]
    var recog: [CaseStatus: [Double]] = [:]
    var exec: [CaseStatus: [Double]] = [:]
    var total: [CaseStatus: [Double]] = [:]
    
    var PBs: [String: [Key: Bool]] = [:]
    
    func addAttempt(success: Bool, moves: Int, recog: Double, exec: Double) {
        // TODO add the attempt here
    }
    
}
