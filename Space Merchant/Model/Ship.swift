//
//  Ship.swift
//  Space Merchant
//
//  Created by Callum Birks on 11/01/2022.
//

import Foundation
import RealmSwift

class Ship: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted(originProperty: "ships") var player: LinkingObjects<Player>
    @Persisted var name: String
    @Persisted var level: Int = 1
    @Persisted var fuel: Int
    @Persisted var health: Int
    
    var stats: ShipStats {
        let dataRealm = try! Realm(configuration: Realm.Configuration.dataRealm)
        return dataRealm.object(ofType: ShipStats.self, forPrimaryKey: self.id)!
    }
    
    convenience init(shipStats: ShipStats) {
        self.init()
        self.id = shipStats.id
        self.name = shipStats.name
        self.fuel = shipStats.fuelCapacity
        self.health = shipStats.health
    }
    
    // Upgrade level of ship, if required resources are available
    func upgrade() {
        let requiredResources = ShipStats.resourceCostFor(level: self.level + 1)
        if !player[0].inventory!.resourcesAvailable(requiredResources) { return }
        player[0].inventory!.deductResources(requiredResources)
        self.level += 1
        self.stats.levelUp()
        return
    }
    
    // Deduct given amount of fuel from tank, if available
    func deductFuel(x: Int) {
        if self.fuel - x < 0 { return }
        self.fuel -= x
    }
    
    // Fill fuel to capacity, return the amount of fuel that was used
    func refuel() -> Int {
        let x = self.stats.fuelCapacity - self.fuel
        self.fuel = self.stats.fuelCapacity
        return x
    }
    
    func deductHealth(x: Int) {
        self.health = self.health - x >= 0 ? self.health - x : 0
    }
    
    private func repairResourcesFraction() -> Double {
        return 0.05 * (10.0 * floor(Double(100 - health) / 10))
    }
    
    func repair() {
        let requiredResources = stats.resources.fractionResources(repairResourcesFraction())
        player[0].inventory!.deductResources(requiredResources)
    }
}
