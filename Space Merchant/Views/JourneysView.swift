//
//  JourneysView.swift
//  Space Merchant
//
//  Created by Callum Birks on 21/02/2022.
//

import SwiftUI
import RealmSwift

struct JourneysView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedRealmObject var player: Player
    @State private var journey: Journey?
    
    init(player: Player) {
        self.player = player
        player.journeys.forEach({
            $0.checkCombat()
            if $0.remainingTime < -86400 { // 24 hours passed
                $player.journeys.remove(at: player.journeys.firstIndex(of: $0)!)
            }
        })
    }
    
    var body: some View {
        VStack {
            MenuBar(player: self.player, leftBtn: {
                self.dismiss()
            }, rightBtn: {
                
            }, title: "Journeys")
            HStack(alignment: .top, spacing: 10) {
                journeyList
                journeyInfo
            }
            .padding(10)
        }
        .background(Color(Colors.background))
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    var journeyList: some View {
        LazyVStack {
            if player.journeys.isEmpty {
                Text("No journeys, start a new one in Missions")
            }
            ForEach(player.journeys) { journ in
                Button {
                    self.journey = journ
                } label: {
                    HStack {
                        Text(journ.ship.name)
                        Text(journ.remainingTimeText)
                    }
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .border(Color(Colors.offwhite), width: 1)
                }
            }
        }
        .foregroundColor(Color(Colors.offwhite))
    }
    
    var journeyInfo: some View {
        VStack(alignment: .leading) {
            if let journ = journey {
                Text(journ.mission.desc)
                Text(journ.ship.name)
                Text("Total time: \(journ.missionTime.asHoursMinutes)")
                Text("Rewards:")
                ForEach(journ.mission.rewards) { resq in
                    Text("  \(resq.resource!.name): \(resq.quantity)")
                }
                switch(journ.combat) {
                case Combat.CombatEnum.NONE.rawValue:
                    Text("Combat: None")
                case Combat.CombatEnum.WON.rawValue:
                    Text("Combat: Won")
                case Combat.CombatEnum.LOST.rawValue:
                    Text("Combat: Lost")
                default:
                    Text("Combat: Nil")
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .foregroundColor(Color(Colors.offwhite))
    }
}

struct JourneysView_Previews: PreviewProvider {
    static var previews: some View {
        JourneysView(player: Player.example)
    }
}
