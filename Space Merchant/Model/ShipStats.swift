//
//  ShipStats.swift
//  Space Merchant
//
//  Created by Callum Birks on 10/03/2022.
//

import Foundation
import RealmSwift

class ShipStats: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var health: Int
    @Persisted var power: Int
    @Persisted var hullSize: Int
    @Persisted var speed: Int
    @Persisted var fuelCapacity: Int = 6
    
    var resources: List<ResourceQuantity> {
        List<ResourceQuantity>(allResources: Resource.allResources,
                               scrap: Int(Double(self.hullSize) * 0.25),
                               elec: Int(Double(self.power) * 0.1),
                               hiqual: Int(Double(self.health) * 0.1),
                               reacp: Int(Double(self.speed) * 0.1))
    }
    
    convenience init(name: String, health: Int, power: Int, hullSize: Int, speed: Int) {
        self.init()
        self.id = ObjectId.generate()
        self.name = name
        self.health = health
        self.power = power
        self.hullSize = hullSize
        self.speed = speed
    }
    
    static func resourceCostFor(level: Int) -> List<ResourceQuantity> {
        List<ResourceQuantity>(allResources: Resource.allResources,
                               scrap: level * 10,
                               elec: level * 5,
                               hiqual: level * 3,
                               reacp: level)
    }
    
    func levelUp() {
        self.health = Int(Double(self.health) * 1.02)
        self.power = Int(Double(self.health) * 1.02)
        self.speed = Int(Double(self.speed) * 1.02)
    }
}
