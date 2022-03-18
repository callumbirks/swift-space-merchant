//
//  Space_MerchantApp.swift
//  Space Merchant
//
//  Created by Callum Birks on 12/01/2022.
//

import SwiftUI
import RealmSwift

@main
struct Space_MerchantApp: SwiftUI.App {
    init() {
        DataController.loadGameData()
        let realm = try! Realm()
        try! realm.write {
            realm.objects(Player.self).first?.journeys.forEach({
                $0.checkCombat()
            })
        }
    }
    var body: some Scene {
        WindowGroup {
            StartView()
                .previewInterfaceOrientation(.landscapeRight)
        }
    }
}


