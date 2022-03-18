//
//  LoginView.swift
//  Space Merchant
//
//  Created by Callum Birks on 12/01/2022.
//

import SwiftUI
import RealmSwift

struct LoginView: View {
    @State var userText: String = ""
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                TextField("Username", text: $userText)
                    .foregroundColor(Color(Colors.offwhite))
                    .onSubmit {
                        if valid(userText)
                        { createPlayer(userText) }
                    }
                Button {
                    if valid(userText)
                    { createPlayer(userText) }
                } label: {
                    RoundedButton(btnColor: Color(Colors.green), textColor: Color(Colors.offwhite), text: "Register")
                }
            }
            .padding([.top, .bottom], 150)
            .padding([.leading, .trailing], 150)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(Colors.background))
    }
}

func valid(_ text: String) -> Bool {
    let regex = "\\w{4,20}"
    let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
    return predicate.evaluate(with: text)
}

func createPlayer(_ username: String) {
    let userRealm = try! Realm()
    do {
        try userRealm.write {
            userRealm.create(Player.self, value: Player(username: username))
        }
    }
    catch {
        return
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
