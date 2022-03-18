//
//  Journey.swift
//  Space Merchant
//
//  Created by Callum Birks on 21/02/2022.
//

import Foundation
import RealmSwift

class Journey: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var missionId: ObjectId
    @Persisted(originProperty: "journeys") var players: LinkingObjects<Player>
    @Persisted var shipId: ObjectId
    @Persisted var missionTime: TimeInterval
    @Persisted var startTime: Date
    @Persisted var timeDeductions: TimeInterval = 0
    @Persisted var combat: Int?
    
    convenience init(missionId: ObjectId, shipId: ObjectId) {
        self.init()
        self.missionId = missionId
        self.shipId = shipId
        self.missionTime = mission.missionTime
        self.startTime = Date.now
        self.combat = nil
    }
    
    var remainingTime: TimeInterval {
        startTime.advanced(by: missionTime - timeDeductions).timeIntervalSinceNow
    }
    var mission: Mission {
        let dataRealm = try! Realm(configuration: Realm.Configuration.dataRealm)
        return dataRealm.object(ofType: Mission.self, forPrimaryKey: missionId)!
    }
    var ship: Ship {
        let realm = try! Realm()
        return realm.object(ofType: Ship.self, forPrimaryKey: shipId)!
    }
    var remainingTimeText: String {
        remainingTime > 0 ? "\(remainingTime.asHoursMinutes) remaining" : "Complete"
    }
    
    func speedUp() {
        if let player = players.first, player.antimatter >= speedUpCost(),
           let realm = try? Realm() {
            try! realm.write {
                player.deductAntimatter(x: speedUpCost())
                self.timeDeductions += 3600
            }
            self.checkCombat()
        }
    }
    
    func speedUpCost() -> Int {
        return ( (3600 - 3600 % Int(remainingTime)) / 3600 ) * 50
    }
    
    func decideCombat() {
        // Pirates attacking multiple times?
        if !Pirate.willAttack(missionTime: self.missionTime) {
            self.combat = Combat.CombatEnum.NONE.rawValue
            return
        }
        let realm = try! Realm()
        try! realm.write {
            self.combat = Combat.decideCombat(shipPower: ship.stats.power, mercenaryPower: Pirate.attackPower(value: mission.rewards.reduce(0, { $0 + $1.resource!.value}))).rawValue // rudimentary function
            if self.combat == Combat.CombatEnum.WON.rawValue {
                ship.deductHealth(x: Int.random(in: 2...20))
            }
            else if self.combat == Combat.CombatEnum.LOST.rawValue {
                ship.deductHealth(x: Int.random(in: 50...90))
                // need to deduct rewards
                // possibly lose ship
            }
        }
    }
        
    func checkCombat() {
        if self.remainingTime <= 0, combat == nil {
            self.decideCombat()
        }
    }
}

extension TimeInterval {
    var asHoursMinutes: String {
        let hours = Int(floor(self / 3600))
        let minutes = Int(floor(self.truncatingRemainder(dividingBy: 3600) / 60))
        return "\(hours)h \(minutes)m"
    }
}
