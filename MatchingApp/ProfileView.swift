//
//  ProfileView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/01.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        ScrollView {
            VStack {
                MyMainInfoView()
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
                NavigationLink {
                    UserProfileView()
                } label: {
                    HStack {
                        Image("Person")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        Text("ジェニファー")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.black.opacity(0.8))
                            .font(.system(size: 16))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .resizable()
                            .frame(width: 10, height: 20)
                            .foregroundColor(.gray)
                            .padding(.trailing, 16)
                        
                    }
                }
                .padding(.leading, 16)
                
                Button {
                    print("aaaa")
                } label: {
                    HStack(alignment: .center){
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 10, height: 10)
                        NavigationLink {
                            AddNewPairView()
                        } label: {
                            Text("追加する")
                        }
                    }
                    .foregroundColor(.black)
                }
                CustomDivider()
                SettingView()
                    .padding(.leading, 16)
                Button {
                    appState.isLogin = false
                } label: {
                    Text("ログアウト")
                        .foregroundColor(.red)
                        .padding(.vertical, 16)
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
