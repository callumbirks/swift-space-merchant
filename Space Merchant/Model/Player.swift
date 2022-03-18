//
//  Player.swift
//  Space Merchant
//
//  Created by Callum Birks on 10/01/2022.
//

import Foundation
import RealmSwift

class Player: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id = ObjectId()
    @Persisted var username: String
    @Persisted var xp: Int = 0
    @Persisted var level: Int = 1
    @Persisted var credits: Int = 0
    @Persisted var antimatter: Int = 0
    @Persisted var hangar: Hangar?
    @Persisted var ships = List<Ship>()
    @Persisted var inventory: Inventory?
    @Persisted var journeys = List<Journey>()
    var completedJourneys: [Journey] {
        journeys.filter({ $0.remainingTime <= 0 })
    }
    
    convenience init(username: String) {
        self.init()
        self.username = username
        self.hangar = Hangar()
        self.inventory = Inventory(allResources: Resource.allResources)
    }
    
    private static func requiredXPFor(level: Int) -> Int {
        return level * 2000
    }
    
    private func canLevelUp() -> Bool {
        if Player.requiredXPFor(level: self.level + 1) < self.xp { return true }
        return false
    }
    
    private func levelUp() {
        self.level += 1
    }
    
    func addXP(x: Int) {
        self.xp += x
        if self.canLevelUp() {
            self.levelUp()
        }
    }
    
    func deductCredits(x: Int) {
        if self.credits - x >= 0 {
            credits -= x
        }
    }
    
    func addCredits(x: Int) {
        credits += x
    }
    
    func deductAntimatter(x: Int) {
        if antimatter - x >= 0 {
            antimatter -= x
        }
    }
    
    func addAntimatter(x: Int) {
        antimatter += x
    }
    
    static var example: Player {
        Player(value: [ObjectId.generate(), "bork", 21000, 21, 1337, 137, Hangar.example, List<Ship>(), Inventory.example, List<Mission>(), List<Journey>()])
    }
}
