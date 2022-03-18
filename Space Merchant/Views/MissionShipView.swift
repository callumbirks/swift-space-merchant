//
//  MissionShipView.swift
//  Space Merchant
//
//  Created by Callum Birks on 05/03/2022.
//

import SwiftUI
import RealmSwift

struct MissionShipView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedRealmObject var player: Player
    var mission: Mission?
    @State private var shipIndex: Int?
    private var selectedShip: Ship? {
        if let si = shipIndex {
            return player.ships[si]
        }
        return nil
    }
    @Binding var submittedShip: Ship?
    
    private var shipCondition: Bool {
        if let ship = selectedShip, let miss = mission,
           ship.stats.hullSize >= miss.cargoSize {
            return true
        }
        return false
    }
    
    private var availableShips: [Ship] {
        try! player.ships.filter({ ship throws in player.journeys.allSatisfy({ $0.shipId != ship.id }) })
    }
    
    var body: some View {
        VStack {
            MenuBar(player: self.player, leftBtn: {
                self.dismiss()
            }, rightBtn: {}, title: "Select Ship")
            HStack {
                shipSelector
                shipInfo
                missionInfo
                selectShipButton
            }
        }
        .background(Color(Colors.background))
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    var shipSelector: some View {
        VStack(alignment: .leading) {
            Text("Ships")
                .font(.title)
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(availableShips) { ship in
                        Button {
                            self.shipIndex = player.ships.firstIndex(of: ship)!
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
    
    var shipInfo: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Details")
                .font(.title)
            if !player.ships.isEmpty, let si = shipIndex {
                let ship = player.ships[si]
                Text("Name: \(ship.name)")
                Text("Level: \(ship.level)")
                Text("Health: \(ship.health)/\(ship.stats.health)")
                Text("Hull Size: \(ship.stats.hullSize)")
                Text("Power: \(ship.stats.power)")
                Text("Speed: \(ship.stats.speed)")
                Text("Fuel: \(ship.fuel)/\(ship.stats.fuelCapacity)")
            }
            else {
                Text("No ships")
            }
        }
        .foregroundColor(Color(Colors.offwhite))
    }
    
    var missionInfo: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Cargo size: \(mission?.cargoSize ?? -1)")
//            Text("Recommended power: \(mission?.recommendedPower ?? -1)")
        }
    }
    
    var selectShipButton: some View {
        Button {
            if let ship = selectedShip {
                submittedShip = selectedShip
                self.dismiss()
            }
        } label: {
            RoundedButton(btnColor: Color(Colors.green), textColor: Color(Colors.offwhite), text: "Select", condition: shipCondition)
        }
        .disabled(!shipCondition)
    }
    
}
