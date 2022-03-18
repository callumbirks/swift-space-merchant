//
//  Inventory.swift
//  Space Merchant
//
//  Created by Callum Birks on 11/01/2022.
//

import Foundation
import RealmSwift

class Inventory: Object, ObjectKeyIdentifiable {
    @Persisted(originProperty: "inventory") var player: LinkingObjects<Player>
    @Persisted var resources: List<ResourceQuantity>

    convenience init(allResources: Results<Resource>) {
        self.init()
        self.resources = .init(allResources: allResources)
    }

    func resourcesAvailable(_ resources: List<ResourceQuantity>) -> Bool {
        return self.resources.resourcesAvailable(resources)
    }

    // Deduct given resources from user's inventory, if they have enough
    func deductResources(_ resources: List<ResourceQuantity>) {
        if self.resources.resourcesAvailable(resources) {
            self.resources.deductResources(resources)
        }
    }

    // Add given resources to user's inventory
    func addResources(_ resources: List<ResourceQuantity>) {
        self.resources.addResources(resources)
    }

    // Half given resources and add to user's inventory
    func refundResources(_ resources: List<ResourceQuantity>) {
        let halfResources = resources.fractionResources(0.5)
        self.resources.addResources(halfResources)
    }

    static var example: Inventory {
        Inventory()
    }
}
