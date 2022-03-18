//
//  Mercenary.swift
//  Space Merchant
//
//  Created by Callum Birks on 21/02/2022.
//

import Foundation

struct Pirate {
    static func attackPower(value: Int) -> Int {
        return value / 8
    }
    
    static func willAttack(missionTime: TimeInterval) -> Bool {
        let hours = Int(missionTime / 3600)
        return Int.random(in: 0...50) < hours
    }
}
