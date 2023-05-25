//
//  RichButtton.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/04.
//

import SwiftUI

struct RichButton: View {
    let buttonText:String
    var body: some View {
        LinearGradient(colors: [.purple, .black], startPoint: .topLeading, endPoint: .bottom).mask {
            Text(buttonText)
        }.font(.system(size: 22, weight: .heavy, design: .rounded))
            .frame(width: 200, height: 60)
            .background(ZStack{
                Color(.displayP3, red: 195/255,  green: 208/255, blue: 232/255, opacity: 1)
                RoundedRectangle(cornerRadius: 16, style: .continuous).foregroundColor(.white).blur(radius: 4).offset(x: -8, y: -8)
                RoundedRectangle(cornerRadius: 16, style: .continuous).fill(
                    LinearGradient(colors: [Color(.displayP3, red: 214/255,  green: 225/255, blue: 251/255, opacity: 1), .white], startPoint: .leading, endPoint: .trailing)
                ).padding(2).blur(radius: 2)
            })
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        
    }
}

struct RichButton_Previews: PreviewProvider {
    static var previews: some View {
        RichButton(buttonText: "Sign In")
    }
}
