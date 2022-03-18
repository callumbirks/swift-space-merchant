//
//  MenuBar.swift
//  Space Merchant
//
//  Created by Callum Birks on 27/01/2022.
//

import SwiftUI

struct MenuBar: View {
    var player: Player
    let leftBtn: () -> Void
    let rightBtn: () -> Void
    let title: String
    
    init(player: Player, leftBtn: @escaping () -> Void, rightBtn: @escaping () -> Void, title: String? = nil) {
        self.player = player
        self.leftBtn = leftBtn
        self.rightBtn = rightBtn
        self.title = title ?? "\(player.level)   \(player.username)"
    }
    
    var body: some View {
        HStack(spacing: 10) {
            Button {
                leftBtn()
            } label: {
                homeButton
                    .frame(width: 80, height: 40)
                    .ignoresSafeArea()
            }
            Text(title)
                .foregroundColor(Color(Colors.offwhite))
                .shadow(radius: 5)
            Spacer()
            Image(Images.credits)
                .scaleEffect(0.3)
                .frame(width: 40, height: 40)
            Text("\(player.credits)")
                .foregroundColor(Color(Colors.offwhite))
                .shadow(radius: 5)
                .padding([.trailing], 20)
            Image(Images.antimatter)
                .scaleEffect(0.3)
                .frame(width: 40, height: 40)
            Text("\(player.antimatter)")
                .foregroundColor(Color(Colors.offwhite))
                .shadow(radius: 5)
            Button {
                rightBtn()
            } label: {
                settingsButton
                    .frame(width: 80, height: 40)
                    .ignoresSafeArea()
                    
            }
        }
        .background(Color(Colors.toolbar))
        
    }
    
    var homeButton: some View {
        ZStack {
            Path() {
                $0.addLines([
                    CGPoint(x: 0, y: 0),
                    CGPoint(x: 110, y: 0),
                    CGPoint(x: 85, y: 40),
                    CGPoint(x: 0, y: 40)
                ])
            }
                .foregroundColor(Color(Colors.nav_blue).opacity(0.9))
            Image(systemName: Symbols.home)
                .font(.system(size: 28))
                .foregroundColor(Color(Colors.offwhite))
                .padding([.leading], 45)
        }
    }
    
    var settingsButton: some View {
        ZStack {
            Path() {
                $0.addLines([
                    CGPoint(x: 0, y: 0),
                    CGPoint(x: 200, y: 0),
                    CGPoint(x: 200, y: 40),
                    CGPoint(x: 25, y: 40)
                ])
            }
                .foregroundColor(Color(Colors.nav_blue).opacity(0.9))
            Image(systemName: Symbols.gear)
                .font(.system(size: 28))
                .foregroundColor(Color(Colors.offwhite))
                .padding([.leading], 15)
        }
    }
}
