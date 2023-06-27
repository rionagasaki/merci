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
        let message = "友達追加してね。私のIDは\(userModel.uid)です。よろしくね。"
        let encodedMessage = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return URL(string: lineScheme + (encodedMessage ?? ""))!
    }
    @EnvironmentObject var userModel: UserObservableModel
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Link(destination: lineURL) {
                    Image("LINE")
                        .resizable()
                        .frame(width: 70, height:70)
                        .cornerRadius(10)
                }

                Image("Instagram")
                    .resizable()
                    .frame(width: 70, height:70)
                    .cornerRadius(10)
            }
        }
        
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Text("戻る")
            }
        }
    }
}

struct SNSShareView_Previews: PreviewProvider {
    static var previews: some View {
        SNSShareView()
    }
}
