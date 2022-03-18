//
//  ShipBuildView.swift
//  Space Merchant
//
//  Created by Callum Birks on 11/02/2022.
//

import SwiftUI
import RealmSwift

struct ShipBuildView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedRealmObject private var player: Player
    private let shipStats: Results<ShipStats>
    @State private var selectedShip: ShipStats? = nil
    @State private var errorMsg: String?
    private var canBuild: Binding<Bool> { Binding(
        get: {
            if let ship = selectedShip {
                let resq = ship.resources
                return player.ships.count < player.hangar?.availableSlots ?? -1 && player.inventory?.resourcesAvailable(resq) ?? false
            }
            return false
        },
        set: { _ in }
    )}
    
    init(player: Player, errorMsg: String? = nil) {
        self.player = player
        let dataRealm = try! Realm(configuration: Realm.Configuration.dataRealm)
        self.shipStats = dataRealm.objects(ShipStats.self)
        self.errorMsg = errorMsg
    }
    
    var body: some View {
        VStack {
            MenuBar(player: self.player, leftBtn: {
                self.dismiss()
            }, rightBtn: {
                
            }, title: "Build Ship")
            HStack {
                shipStack
                statStack
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                resourceStack
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color(Colors.background))
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    var shipStack: some View {
        VStack(alignment: .leading) {
            Text("Ships")
                .font(.title)
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(shipStats) { ship in
                        Button {
                            self.selectedShip = ship
                        } label: {
                            Text(ship.name)
                                .padding([.vertical, .leading], 8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .border(Color(Colors.offwhite), width: 1)
                        }
                    }
                }
            }
        }
        .foregroundColor(Color(Colors.offwhite))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var statStack: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Stats")
                .font(.title)
            if let ship = selectedShip {
                Text("Health: \(ship.health)")
                Text("Hull Size: \(ship.hullSize)")
                Text("Power: \(ship.power)")
                Text("Speed: \(ship.speed)")
                Text("Fuel Capacity: \(ship.fuelCapacity)")
            }
        }
        .foregroundColor(Color(Colors.offwhite))
    }
    
    var resourceStack: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Resources")
                .font(.title)
            if let ship = selectedShip, let resqs = ship.resources {
                ForEach(resqs) { resq in
                    Text("\(resq.resource!.name): \(resq.quantity)")
                }
            }
            Spacer()
            if let error = errorMsg {
                Text(error)
            }
            Button {
                buildShip()
            } label: {
                RoundedButton(btnColor: Color(Colors.green), textColor: Color(Colors.offwhite), text: "Build", condition: canBuild.wrappedValue )
            }
//            .disabled(!canBuild.wrappedValue)
            .frame(maxWidth: .infinity, maxHeight: 50)
        }
        .foregroundColor(Color(Colors.offwhite))
    }
    
    func buildShip() {
        if player.ships.count == player.hangar?.availableSlots ?? -1 {
            self.errorMsg = "No hangar slots available"
            return
        }
        if let ship = selectedShip, let inv = player.inventory {
            let resqs = ship.resources
            if inv.resourcesAvailable(resqs) {
                let realm = try! Realm()
                try! realm.write {
                    inv.deductResources(resqs)
                    $player.ships.append(realm.create(Ship.self, value: Ship(shipStats: ship)))
                }
                self.dismiss()
            }
            else {
                self.errorMsg = "Resources not available"
                // TEST CODE
                let realm = try! Realm()
                try! realm.write {
                    inv.addResources(resqs)
                }
            }
        }
    }
}

struct ShipBuildView_Previews: PreviewProvider {
    static var previews: some View {
        ShipBuildView(player: Player.example, errorMsg: "Not enough resources")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
