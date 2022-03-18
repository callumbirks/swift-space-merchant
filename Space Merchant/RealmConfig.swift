//
//  RealmConfig.swift
//  Space Merchant
//
//  Created by Callum Birks on 13/01/2022.
//

import SwiftUI
import RealmSwift

extension Realm.Configuration {
    static var dataRealm =
        Realm.Configuration(fileURL: Bundle.main.url(forResource: "data", withExtension: "realm")!, readOnly: true)
}
