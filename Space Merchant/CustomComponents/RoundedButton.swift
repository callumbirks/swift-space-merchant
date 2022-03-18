//
//  Buttons.swift
//  Space Merchant
//
//  Created by Callum Birks on 20/01/2022.
//

import SwiftUI

struct RoundedButton: View {
    var btnColor: Color
    var textColor: Color
    var text: String?
    var symbol: String?
    var condition: Bool
    
    init(btnColor: Color, textColor: Color, text: String? = nil, symbol: String? = nil, condition: Bool? = nil) {
        self.btnColor = btnColor
        self.textColor = textColor
        self.text = text != nil ? text : nil
        self.symbol = symbol != nil ? symbol : nil
        self.condition = condition != nil ? condition! : true
    }
    
    var activeColor: Color {
        condition ? btnColor : Color(Colors.grey)
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(activeColor)
                .glow(color: activeColor)
            HStack {
                if let symb = symbol {
                    Image(systemName: symb)
                }
                if let tex = text {
                    Text(tex.uppercased())
                }
            }
            .font(.title.weight(.black))
            .foregroundColor(textColor)
        }
    }
}

struct RoundedButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            RoundedButton(btnColor: Color(Colors.green), textColor: Color(Colors.offwhite), text: "Upgrade", symbol: Symbols.arrowup)
                .padding([.top,.bottom], 360)
        }
        .background(Color(Colors.background))
    }
}

//extension Text {
//    var allCaps: String {
//        get {  }
//    }
//}
