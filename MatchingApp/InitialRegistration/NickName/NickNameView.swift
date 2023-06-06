//
//  NickNameView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/22.
//

import SwiftUI

struct NickNameView: View {
    @EnvironmentObject var userModel: UserObservableModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(alignment: .leading){
                        Text("ニックネームを\n入力してください")
                            .foregroundColor(.customBlack)
                            .fontWeight(.bold)
                            .font(.system(size: 25))
                            .padding(.horizontal, 16)
                            .padding(.top, 80)
                        VStack(alignment: .leading, spacing: .zero){
                            TextField(text: $userModel.nickname) {
                                Text("入力してください")
                            }
                            .foregroundColor(.customBlack)
                            .font(.system(size: 25))
                            .padding(.vertical, 16)
                            .padding(.horizontal, 4)
                            .cornerRadius(10)
                            .padding(.horizontal, 16)
                            .padding(.top, 8)
                            
                            Rectangle()
                                .foregroundColor(.gray.opacity(0.3))
                                .frame(height: 2)
                                .padding(.horizontal, 16)
                                .padding(.top, -8)
                        }
                        VStack(alignment: .leading){
                            Text("※本名などあなたを特定できる情報の使用は控えてください。")
                            Text("※ニックネームはあとから変更できます。")
                        }
                        .foregroundColor(.gray)
                        .padding(.horizontal, 16)
                        .font(.system(size: 13))
                        
                    }
                }
                Spacer()
                NavigationLink {
                    GenderView(presentationMode: presentationMode)
                } label: {
                    NextButtonView()
                }
            }
        }
    }
}
