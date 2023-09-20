//
//  SNSShareView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/20.
//

import SwiftUI

struct SNSShareView: View {
    var lineURL: URL {
        let lineScheme = "https://line.me/R/share?text="
        let message = "一緒に恋活しよ💓 \n 友達と始めるマッチングアプリNiNi：https://github.com/"
        let encodedMessage = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return URL(string: lineScheme + (encodedMessage ?? "https://github.com/"))!
    }
    @EnvironmentObject var userModel: UserObservableModel
    var body: some View {
        VStack(alignment: .leading){
            Text("SNSでプロフィールを公開して、友達になってみよう!")
                .foregroundColor(.customBlack)
                .font(.system(size: 20, weight: .bold))
                .frame(width: UIScreen.main.bounds.width-32)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 32)
            HStack {
                Image("LINE")
                    .resizable()
                    .frame(width: 70, height:70)
                    .cornerRadius(10)
                Text("LINEで招待する")
                    .foregroundColor(.customBlack)
                    .font(.system(size: 20, weight: .bold))
                    .padding(.leading, 8)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            HStack {
                Image("Twitter")
                    .resizable()
                    .frame(width: 70, height:70)
                    .cornerRadius(10)
                Text("Xで招待する")
                    .foregroundColor(.customBlack)
                    .font(.system(size: 20, weight: .bold))
                    .padding(.leading, 8)
            }
            .padding(.horizontal, 16)
            .padding(.top, 28)
            
            HStack {
                Image("Instagram")
                    .resizable()
                    .frame(width: 70, height:70)
                    .cornerRadius(10)
                Text("Instagramで招待する")
                    .foregroundColor(.customBlack)
                    .font(.system(size: 20, weight: .bold))
                    .padding(.leading, 8)
            }
            .padding(.horizontal, 16)
            .padding(.top, 28)
            Spacer()
        }
        .frame(height: UIScreen.main.bounds.height/2.1)
    }
}

struct SNSShareView_Previews: PreviewProvider {
    static var previews: some View {
        SNSShareView()
    }
}
