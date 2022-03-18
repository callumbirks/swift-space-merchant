//
//  ContentView.swift
//  Space Merchant
//
//  Created by Callum Birks on 12/01/2022.
//

import SwiftUI
import RealmSwift

struct StartView: View {
    @ObservedResults(Player.self) var players
    
    var body: some View {
        if players.isEmpty {
            LoginView()
        } else {
            HomeView(player: players.first!)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
