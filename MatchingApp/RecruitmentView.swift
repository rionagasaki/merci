//
//  RecruitmentView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/03.
//

import SwiftUI

struct RecruitmentView: View {
    var body: some View {
        VStack {
            HStack(alignment: .top){
                HStack(spacing: 10){
                    VStack {
                        Image("Person")
                            .resizable()
                            .frame(width: (UIScreen.main.bounds.width/2)-30, height: (UIScreen.main.bounds.width/2)-30)
                            .cornerRadius(20)
                        Text("22歳 渋谷")
                            .foregroundColor(.black.opacity(0.8))
                            .bold()
                            .font(.system(size: 14))
                    }
                    VStack {
                        Image("Header_One")
                            .resizable()
                            .frame(width: (UIScreen.main.bounds.width/2)-30, height: (UIScreen.main.bounds.width/2)-30)
                            .cornerRadius(20)
                        Text("22歳 渋谷")
                            .foregroundColor(.black.opacity(0.8))
                            .bold()
                            .font(.system(size: 14))
                    }
                }
            }
            .padding(.horizontal, 16)
            
            Button {
                print("さそう")
            } label: {
                Text("いいかも")
                    .frame(maxWidth: 400)
                    .padding(.all, 8)
                    .foregroundColor(.white)
                    .fontWeight(.medium)
                    .background(Color.customGreen)
                    .cornerRadius(10)
            }
        }
        .padding(.top, 8)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.white)
                .shadow(radius: 1)
        }
        .padding(.horizontal, 8)
        
    }
}

struct RecruitmentView_Previews: PreviewProvider {
    static var previews: some View {
        RecruitmentView()
    }
}
