//
//  InventoryView.swift
//  Space Merchant
//
//  Created by Callum Birks on 11/02/2022.
//

import SwiftUI
import RealmSwift

struct InventoryView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedRealmObject var player: Player
    
    var body: some View {
        VStack {
            MenuBar(player: self.player, leftBtn: {
                self.dismiss()
            }, rightBtn: {
                
            }, title: "Inventory")
            ScrollView(.horizontal) {
                HStack {
                    LazyHGrid(rows: inventoryRow) {
                        ForEach(player.inventory!.resources, id: \.id) { resq in
                            VStack {
                                Image(systemName: "photo.fill" /*resource.icon*/)
                                    .font(.system(size: 28))
                                Text(resq.resource!.name)
                                Text(String(resq.quantity))
                            }
                            .foregroundColor(Color(Colors.offwhite))
                        }
                    }
//                    Button {
//                        if let inv = player.inventory {
//                            let resqs = RealmSwift.List<ResourceQuantity>(allResources: Resource.allResources,
//                                                                          scrap: 500,
//                                                                          elec: 200,
//                                                                          hiqual: 100,
//                                                                          reacp: 50)
//                            let realm = try! Realm()
//                            try! realm.write {
//                                inv.addResources(resqs)
//                            }
//                        }
//                    } label: {
//                        RoundedButton(btnColor: Color(Colors.green), textColor: Color(Colors.offwhite), text: "Add resources")
//                    }
                }
            }
        }
        .background(Color(Colors.background))
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    var inventoryRow = [GridItem(.adaptive(minimum: 80))]
}

struct InventoryView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryView(player: Player.example)
    }
}
