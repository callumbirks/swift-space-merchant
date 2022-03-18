//
//  DataController.swift
//  Space Merchant
//
//  Created by Callum Birks on 08/03/2022.
//

import Foundation
import RealmSwift
import SwiftyJSON

struct DataController {
    private static var config: Realm.Configuration {
        return Realm.Configuration(fileURL: URL(string: "temp.realm", relativeTo: Bundle.main.bundleURL))
    }
    // Checks if JSON version has changed, if so overwrite data realm file
    public static func loadGameData() {
        guard let jsonUrl = Bundle.main.url(forResource: "data", withExtension: "json")
        else {
            print("Error loading JSON")
            return
        }
        let json = try! JSON(data: Data(contentsOf: jsonUrl))
        if json["version"].intValue > 1 {
            parseJSON(from: json, saveTo: try! Realm(configuration: DataController.config))
        }
    }
    public static func parseJSON(from json: JSON, saveTo dRealm: Realm) {
        try! dRealm.write {
            dRealm.deleteAll()
        }
        let resourcesArray = json["resources"].arrayValue.map({ Resource(value: [ObjectId.generate(), $0["name"].stringValue, $0["value"].intValue]) })
        try! dRealm.write {
            resourcesArray.forEach({ resource in
                dRealm.create(Resource.self, value: resource)
            })
        }
        let shipsArray = json["ships"].arrayValue.map({
            ShipStats(value: ShipStats(
                name: $0["name"].stringValue,
                health: $0["health"].intValue,
                power: $0["power"].intValue,
                hullSize: $0["hullSize"].intValue,
                speed: $0["speed"].intValue)) })
        try! dRealm.write {
            shipsArray.forEach({ ship in
                dRealm.create(ShipStats.self, value: ship)
            })
        }
        let missionsArray = json["missions"].arrayValue.map({ jsd in
            Mission(value: Mission(
                name: jsd["name"].stringValue,
                desc: jsd["description"].stringValue,
                requiredLevel: jsd["requiredLevel"].intValue,
                missionTime: jsd["missionTime"].doubleValue,
                cargoSize: jsd["cargoSize"].intValue,
                rewards: List<ResourceQuantity>(allResources: dRealm.objects(Resource.self),
                                                scrap: jsd["rewards"].arrayValue[0]["quantity"].intValue,
                                                elec: jsd["rewards"].arrayValue[1]["quantity"].intValue,
                                                hiqual: jsd["rewards"].arrayValue[2]["quantity"].intValue,
                                                reacp: jsd["rewards"].arrayValue[3]["quantity"].intValue)
            ))
        })
        try! dRealm.write {
            missionsArray.forEach({ mission in
                dRealm.create(Mission.self, value: mission)
            })
        }
        do {
            let dataBundleUrl = Bundle.main.url(forResource: "data", withExtension: "realm")!
            let dataLocalUrl = URL(fileURLWithPath: "/Users/callum/Documents/Uni/Year 3/CTEC3451 Development Project/Space Merchant/Space Merchant/data.realm")
            try Realm.deleteFiles(for: Realm.Configuration.dataRealm)
            try Realm.deleteFiles(for: Realm.Configuration.defaultConfiguration)
            let fm = FileManager()
            try fm.removeItem(at: dataLocalUrl)
            try dRealm.writeCopy(toFile: dataBundleUrl)
            try dRealm.writeCopy(toFile: dataLocalUrl)
        }
        catch {
            print(error.localizedDescription)
        }
    }
}
