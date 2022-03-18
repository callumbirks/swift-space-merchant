//
//  MissionsView.swift
//  Space Merchant
//
//  Created by Callum Birks on 03/03/2022.
//

import SwiftUI
import RealmSwift

struct MissionsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedRealmObject var player: Player
    @ObservedRealmObject private var activeJourneys: RealmSwift.List<Journey>
    private var allMissions: Results<Mission>
    private var availableMissions: [Mission] {
        allMissions.filter({ mission in mission.requiredLevel <= player.level && activeJourneys.allSatisfy({ $0.missionId != mission.id }) })
    }
    @State private var selectedMission: Mission?
    @State private var selectedShip: Ship?
    private var missionCondition: Bool {
        selectedShip != nil && selectedMission?.requiredLevel ?? 999 <= player.level
    }
    
    init(player: Player) {
        self.player = player
        self.activeJourneys = player.journeys
        let dataRealm = try! Realm(configuration: Realm.Configuration.dataRealm)
        self.allMissions = dataRealm.objects(Mission.self)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            MenuBar(player: self.player, leftBtn: {
                self.dismiss()
            }, rightBtn: {
                
            }, title: "Missions")
            HStack {
                missionSelector
                VStack {
                    missionInfo
                    shipButton
                        .frame(maxWidth: .infinity, maxHeight: 50)
                    missionButton
                        .frame(maxWidth: .infinity, maxHeight: 50)
                }
            }
        }
        .background(Color(Colors.background))
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    var missionSelector: some View {
        LazyVStack {
            ForEach(availableMissions) { mission in
                Button {
                    self.selectedMission = mission
                } label: {
                    Text("Mission \(mission.id)")
                        .padding([.vertical, .leading], 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .border(Color(Colors.offwhite), width: 1)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(Color(Colors.offwhite))
    }
    
    var missionInfo: some View {
        VStack(alignment: .leading) {
            if let mission = selectedMission {
                Text(mission.desc)
                Text("Time: \(mission.missionTime.asHoursMinutes)")
                Text("Cargo size: \(mission.cargoSize)")
//                Text("Recommended Power: \(mission.recommendedPower)")
                Text("Rewards: ")
                ForEach(mission.rewards) { resq in
                    Text("\(resq.resource!.name) \(resq.quantity)")
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(Color(Colors.offwhite))
    }
    
    var shipButton: some View {
        NavigationLink {
            MissionShipView(player: player, mission: self.selectedMission, submittedShip: $selectedShip)
        } label: {
            RoundedButton(btnColor: Color(Colors.blue), textColor: Color(Colors.offwhite), text: "Select ship")
        }
        .disabled(selectedMission == nil)
    }
    
    var missionButton: some View {
        Button {
            startMission()
        } label: {
            RoundedButton(btnColor: Color(Colors.green), textColor: Color(Colors.offwhite), text: "Start", condition: missionCondition)
        }
        .disabled(!missionCondition)
    }
    
    func startMission() {
        if let missionId = selectedMission?.id,
           let dataRealm = try? Realm(configuration: Realm.Configuration.dataRealm),
           let mission = dataRealm.object(ofType: Mission.self, forPrimaryKey: missionId),
           let shipId = selectedShip?.id,
           let realm = try? Realm() {
            try! realm.write {
                self.$player.journeys.append(realm.create(Journey.self, value: Journey(missionId: mission.id, shipId: shipId)))
            }
        }
        
    }
}

struct MissionsView_Previews: PreviewProvider {
    static var previews: some View {
        MissionsView(player: Player.example)
    }
}
