//
//  RichNavButton.swift
//  Space Merchant
//
//  Created by Callum Birks on 10/02/2022.
//

import SwiftUI

struct RichNavButton: View {
    let title: String
    let icon: String
    init(title: String, icon: String? = "photo.fill") {
        self.title = title
        self.icon = icon!
    }
    var body: some View {
        ZStack {
            Rectangle()
                .stroke(Color(Colors.nav_blue))
                .glow(color: Color(Colors.nav_blue))
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color(Colors.nav_blue))
                    Text(title)
                        .font(.title2)
                        .foregroundColor(Color(Colors.offwhite))
                        
                }
                .frame(maxWidth: .infinity, maxHeight: 40)
                Image(systemName: icon)
                    .font(.system(size: 48))
                    .foregroundColor(Color(Colors.offwhite))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

struct RichNavButton_Previews: PreviewProvider {
    static var previews: some View {
        RichNavButton(title: "Button")
            .background(Color(Colors.background))
    }
}
