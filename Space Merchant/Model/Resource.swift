//
//  Resource.swift
//  Space Merchant
//
//  Created by Callum Birks on 11/01/2022.
import Foundation
import RealmSwift

class Resource: Object, ObjectKeyIdentifiable, _MapKey {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var value: Int
    
    static var allResources: Results<Resource> {
        let dataRealm = try! Realm(configuration: Realm.Configuration.dataRealm)
        return dataRealm.objects(Resource.self)
    }
}

class ResourceQuantity: Object, ObjectKeyIdentifiable {
    @Persisted var resource: Resource?
    @Persisted var quantity: Int
    
    convenience init(_ resource: Resource, _ quantity: Int) {
        self.init()
        self.resource = resource
        self.quantity = quantity
    }
}

extension List where Element == ResourceQuantity {
    convenience init(allResources: Results<Resource>) {
        self.init()
        allResources.forEach({ res in
            self.append(ResourceQuantity(res, 0))
        })
    }
    
    convenience init(allResources: Results<Resource>, scrap: Int, elec: Int, hiqual: Int, reacp: Int) {
        self.init(allResources: allResources)
        self.forEach({ resq in
            switch(resq.resource!.name) {
            case "Scrap Metal":
                resq.quantity = scrap
            case "Electronics":
                resq.quantity = elec
            case "High Quality Metal":
                resq.quantity = hiqual
            case "Reactor Parts":
                resq.quantity = reacp
            default:
                resq.quantity = 0
            }
        })
    }
    
    func resourcesAvailable(_ resources: List<ResourceQuantity>) -> Bool {
        return self.allSatisfy({ myResq in
            if let resq = resources.resourceWithId(myResq.resource!.id) {
                return myResq.quantity >= resq.quantity
            }
            else { return false }
        })
    }
    
    func deductResources(_ resources: List<ResourceQuantity>) {
        if !resourcesAvailable(resources) { return }
        resources.forEach { resq in
            if let myResq = self.resourceWithId(resq.resource!.id), let mutableResq = myResq.thaw() {
                mutableResq.quantity -= resq.quantity
            }
        }
    }
    
    func addResources(_ resources: List<ResourceQuantity>) {
        resources.forEach { resq in
            if let myResq = self.resourceWithId(resq.resource!.id), let mutableResq = myResq.thaw() {
                mutableResq.quantity += resq.quantity
            }
        }
    }
    
    func fractionResources(_ fraction: Double) -> List<ResourceQuantity> {
        let fracArray = self.map({ resq -> ResourceQuantity in
            resq.quantity = lround(Double(resq.quantity) * fraction)
            return resq
        })
        let fracRes = List<ResourceQuantity>()
        fracArray.forEach { resq in
            fracRes.append(resq)
        }
        return fracRes
    }
    
    func resourceWithId(_ id: ObjectId) -> ResourceQuantity? {
        return try? self.first(where: { resq throws in resq.resource!.id == id })
    }
}
