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
                VStack(spacing: .zero){
                    Image("Person")
                        .resizable()
                        .frame(width: 100, height: 100)
                    Image("Header_One")
                        .resizable()
                        .frame(width: 100, height: 100)
                }
                Spacer()
                VStack(alignment: .leading){
                    Text("居酒屋に行きたい。")
                        .foregroundColor(.black)
                        .bold()
                        .font(.system(size: 18))
                        .padding(.top, 8)
                        
                    Text("5月3日(水)")
                        .fontWeight(.light)
                        .font(.system(size: 12))
                        .padding(.all, 8)
                        .background(.gray.opacity(0.3))
                        .cornerRadius(20)
                    Text("ここにはコメントここにはコメントここにはコメントここにはコメントここにはコメントここにはコメント")
                        .foregroundColor(.black)
                        .fontWeight(.light)
                        .font(.system(size: 14))
                        .padding(.top, 8)
                        
                }
            }
            Button {
                print("さそう")
            } label: {
                Text("いいかも")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .padding(.all, 8)
                    .background(Color.customRed1.opacity(0.8))
                    .cornerRadius(20)
            }
            .frame(maxWidth: .infinity,alignment: .trailing)
            .padding(.trailing, 8)

        }
        .frame(width: UIScreen.main.bounds.width/1.5)
        .background(.white)
        .compositingGroup()
        .shadow(radius: 10)
        
        .cornerRadius(20)
        .padding(.horizontal, 16)
        
        
    }
}

struct RecruitmentView_Previews: PreviewProvider {
    static var previews: some View {
        RecruitmentView()
    }
}
