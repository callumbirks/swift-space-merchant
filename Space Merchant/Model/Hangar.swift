//
//  Hangar.swift
//  Space Merchant
//
//  Created by Callum Birks on 10/01/2022.
//

import Foundation
import RealmSwift

class Hangar: Object {
    @Persisted(originProperty: "hangar") var player: LinkingObjects<Player>
    @Persisted var level: Int = 1
    var totalSlots: Int = 6
    var availableSlots: Int {
        self.totalSlots - self.player.first!.ships.count
    }
    var canUpgrade: Bool {
        player[0].inventory!.resourcesAvailable(Hangar.upgradeCost(level: self.level + 1))
    }
    
    private static func upgradeCost(level: Int) -> List<ResourceQuantity> {
        List<ResourceQuantity>(allResources: Resource.allResources,
                                          scrap: level * 10,
                                          elec: level * 4,
                                          hiqual: level * 3,
                                          reacp: level)
        
    }

    // Upgrade level of hangar, if required resources are available
    func upgrade() {
        if canUpgrade {
            self.level += 1
        }
    }
    
    static var example: Hangar {
        Hangar(value: [Player.example])
    }
}
