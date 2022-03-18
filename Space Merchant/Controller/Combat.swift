//
//  Combat.swift
//  Space Merchant
//
//  Created by Callum Birks on 21/02/2022.
//

import Foundation
import RealmSwift

struct Combat {
    enum CombatEnum: Int {
        case NONE
        case WON
        case LOST
    }
    
    static func decideCombat(shipPower: Int, mercenaryPower: Int) -> CombatEnum {
        let powerDisparity = shipPower - mercenaryPower
        let pctPowerDisparity: Double = Double(powerDisparity) / Double(shipPower)
        if powerDisparity < 0 {
            return Int.random(in: 0...Int(pctPowerDisparity * -100)) < 10 ? CombatEnum.WON : CombatEnum.LOST
        }
        else if powerDisparity == 0 {
            return Int.random(in: 0...100) < 60 ? CombatEnum.WON : CombatEnum.LOST
        }
        else {
            return Int.random(in: 0...Int(pctPowerDisparity * 100)) > 5 ? CombatEnum.WON : CombatEnum.LOST
        }
    }
}
