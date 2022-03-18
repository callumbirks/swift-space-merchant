//
//  Mission.swift
//  Space Merchant
//
//  Created by Callum Birks on 10/03/2022.
//

import Foundation
import RealmSwift

class Mission: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var desc: String
    @Persisted var requiredLevel: Int
    @Persisted var missionTime: TimeInterval
    @Persisted var cargoSize: Int
    @Persisted var rewards: List<ResourceQuantity>
    
    convenience init(name: String, desc: String, requiredLevel: Int, missionTime: TimeInterval, cargoSize: Int, rewards: List<ResourceQuantity>) {
        self.init()
        self.id = ObjectId.generate()
        self.name = name
        self.desc = desc
        self.requiredLevel = requiredLevel
        self.missionTime = missionTime
        self.cargoSize = cargoSize
        self.rewards = rewards
    }
}
