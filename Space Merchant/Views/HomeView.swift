//
//  HomeView.swift
//  Space Merchant
//
//  Created by Callum Birks on 12/01/2022.
//

import SwiftUI
import RealmSwift

struct HomeView: View {
    @ObservedRealmObject var player: Player
    private var hasCompletedJourneys: Bool {
        !player.completedJourneys.isEmpty
    }
    var body: some View {
        NavigationView {
            if hasCompletedJourneys {
                ZStack {
                    homeVStack
                        .blur(radius: 3)
                    completedJourneysPopup
                }
                .background(Color(Colors.background))
            }
            else {
                homeVStack
            }
            
        }
        .navigationViewStyle(.stack)
    }
    
    var homeVStack: some View {
        VStack {
            MenuBar(player: player, leftBtn: {
                // GO HOME
            }, rightBtn: {
                // GO TO SETTINGS
            })
            HStack(spacing: 20) {
                NavigationLink {
                    HangarView(player: self.player)
                } label: {
                    RichNavButton(title: "Hangar")
                }
                .disabled(hasCompletedJourneys)
                NavigationLink {
                    MissionsView(player: self.player)
                } label: {
                    RichNavButton(title: "Missions", icon: "list.bullet.rectangle.fill")
                }
                .disabled(hasCompletedJourneys)
                NavigationLink {
                    JourneysView(player: self.player)
                } label: {
                    RichNavButton(title: "Journeys", icon: "arrow.left.arrow.right")
                }
                .disabled(hasCompletedJourneys)
                VStack(spacing: 20) {
                    NavigationLink {
                        InventoryView(player: self.player)
                    } label: {
                        RichNavButton(title: "Inventory", icon: "shippingbox.fill")
                    }
                    .disabled(hasCompletedJourneys)
                    NavigationLink {
                        
                    } label: {
                        RichNavButton(title: "Shop", icon: "cart.fill")
                    }
                    .disabled(hasCompletedJourneys)
                }
            }
            .padding(10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(Colors.background))
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    var completedJourneysPopup: some View {
        VStack {
            Text("Completed journeys")
                .foregroundColor(Color(Colors.offwhite))
        }
        .frame(width: 400, height: 200)
        .background(Color(Colors.background))
        .border(Color(Colors.offwhite), width: 1)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(player: Player.example)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
