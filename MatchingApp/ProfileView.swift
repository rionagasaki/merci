//
//  ProfileView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/01.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ScrollView {
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    Image("Person")
                        .resizable()
                        .frame(width: 180, height: 180)
                        .clipShape(Circle())
                    Image(systemName: "plus")
                        .resizable()
                        .padding(.all, 8)
                        .foregroundColor(.white)
                        .background(Color.customRed1)
                        .frame(width: 48, height: 48)
                        .overlay(content: {
                            Circle().stroke(lineWidth: 4).foregroundColor(.white)
                        })
                        .clipShape(Circle())
                    
                }
                HStack {
                    Text("ながり")
                        .font(.system(size: 16))
                        .bold()
                    Text("21歳/千葉")
                }
                HStack {
                    VStack {
                        Text("友達")
                            .foregroundColor(.gray)
                            .font(.system(size: 16))
                            .bold()
                        Button {
                            print("aaa")
                        } label: {
                            Text("追加")
                                .padding(.vertical, 4)
                                .padding(.horizontal, 8)
                                .foregroundColor(.black.opacity(0.8))
                                .background(.gray.opacity(0.4))
                                .cornerRadius(15)
                        }
                        
                    }
                    Divider()
                    VStack {
                        Text("無料会員")
                            .foregroundColor(.gray)
                            .font(.system(size: 16))
                            .bold()
                        Button {
                            print("aaa")
                        } label: {
                            Text("変更")
                                .padding(.vertical, 4)
                                .padding(.horizontal, 8)
                                .foregroundColor(.black.opacity(0.8))
                                .background(.gray.opacity(0.4))
                                .cornerRadius(15)
                        }
                    }
                }
                .frame(height: 100)
                CustomDivider()
                Text("自己紹介")
                    .padding(.leading, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.black.opacity(0.8))
                    .font(.system(size: 18))
                    .bold()
                Text("こんにちはこんにちはこんにちはこんにちはこんにちはこんにちはこんにちはこんにちはこんにちはこんにちはこんにちはこんにちは")
                    .padding(.horizontal, 16)
                    .font(.system(size: 14))
                    .fontWeight(.light)
                CustomDivider()
                Text("ペア")
                    .padding(.leading, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.black.opacity(0.8))
                    .font(.system(size: 18))
                    .bold()
                HStack {
                    Image("Person")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                    Text("ジェニファー")
                    Spacer()
                }
                .padding(.leading, 16)
                Spacer()
            }

        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
