//
//  HangarView.swift
//  Space Merchant
//
//  Created by Callum Birks on 10/02/2022.
//

import SwiftUI
import RealmSwift

struct HangarView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedRealmObject var player: Player
    @State var shipIndex: Int = 0

    init(player: Player) {
        self.player = player
    }
    
    var body: some View {
        VStack {
            MenuBar(player: player, leftBtn: {
                self.dismiss()
            }, rightBtn: {
                // GO HOME
            }, title: "Hangar")
            HStack(spacing: 20) {
                hangarStack
                    .frame(maxWidth: 250)
                shipStack
            }
        }
        .background(Color(Colors.background))
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    var hangarStack: some View {
        VStack(spacing: 20) {
            Text("Level \(player.hangar!.level)")
                .font(.title2)
                .foregroundColor(Color(Colors.offwhite))
            ZStack {
                Rectangle()
                    .stroke(Color(Colors.offwhite))
                Image(systemName: "photo.fill")
                    .font(.system(size: 48))
                    .foregroundColor(Color(Colors.offwhite))
            }
            
            upgradeButton
                .frame(maxWidth: .infinity, maxHeight: 50)
        }
    }
    
    var shipStack: some View {
        VStack(spacing: 20) {
            Text("Ships")
                .font(.title2)
                .foregroundColor(Color(Colors.offwhite))
            ZStack {
                Rectangle()
                    .stroke(Color(Colors.offwhite))
                HStack {
                    Image(systemName: "photo.fill")
                        .font(.system(size: 48))
                        .foregroundColor(Color(Colors.offwhite))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    statStack
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            HStack(spacing: 10) {
                prevButton
                    .frame(maxWidth: 50, maxHeight: 50)
                Button {
                    
                } label: {
                RoundedButton(btnColor: Color(Colors.blue), textColor: Color(Colors.offwhite), text: "View Ship")
                }
                    .frame(maxWidth: .infinity, maxHeight: 50)
                nextButton
                    .frame(maxWidth: 50, maxHeight: 50)
                addButton
                    .frame(maxWidth: 50, maxHeight: 50)
                    .padding(.leading)
            }
        }
    }
    
    var statStack: some View {
        VStack {
            if !player.ships.isEmpty {
                let ship = player.ships[shipIndex]
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
    
    var upgradeButton: some View {
        Button {
            upgrade()
        } label: {
            RoundedButton(btnColor: Color(player.hangar!.canUpgrade ? Colors.green : Colors.grey), textColor: Color(Colors.offwhite), text: "Upgrade", symbol: Symbols.arrowup)
        }
        .disabled(!player.hangar!.canUpgrade)
    }
    
    var prevButton: some View {
        Button {
            prevShip()
        } label: {
            RoundedButton(btnColor: Color(Colors.light_blue), textColor: Color(Colors.offwhite), symbol: "arrow.left")
        }
    }
    
    var nextButton: some View {
        Button {
            nextShip()
        } label: {
            RoundedButton(btnColor: Color(Colors.light_blue), textColor: Color(Colors.offwhite), symbol: "arrow.right")
        }
    }
    
    var addButton: some View {
        NavigationLink {
            ShipBuildView(player: self.player)
        } label: {
            RoundedButton(btnColor: Color(Colors.green), textColor: Color(Colors.offwhite), symbol: "plus")
        }
    }
    
    func upgrade() {
        if let hangar = player.hangar, hangar.canUpgrade {
            let realm = try! Realm()
            try! realm.write {
                hangar.upgrade()
            }
        }
    }
    
    func prevShip() {
        if shipIndex > 0 {
            self.shipIndex -= 1
        }
        else { // Loop round to the end
            self.shipIndex = player.ships.count - 1
        }
    }
    
    func nextShip() {
        if shipIndex < player.ships.count - 1 {
                self.shipIndex += 1
        }
        else { // Loop round to the start
            self.shipIndex = 0
        }
    }
}

struct HangarView_Previews: PreviewProvider {
    static var previews: some View {
        HangarView(player: Player.example)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
