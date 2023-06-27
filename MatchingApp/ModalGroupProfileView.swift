//
//  ModalGroupProfileView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/05.
//

import SwiftUI

struct ModalGroupProfileView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var selection = 0
    @Namespace var namespace
    @State var height: CGFloat = .init()
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var userModel: UserObservableModel
    var userInfos:[UserObservableModel] {
        return [userModel, appState.pairUserModel]
    }
    let pair: PairObservableModel
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.customBlack)
                        .padding(.leading, 16)
                }
                Spacer()
            }
            VStack {
                VStack {
                    HStack {
                        Button {
                            withAnimation {
                                selection = 0
                            }
                        } label: {
                            SelectUserComponent(nickname: pair.pair.pair_1_nickname, profileImageURL: pair.pair.pair_1_profileImageURL, activeRegion: pair.pair.pair_1_activeRegion, birthDate: pair.pair.pair_1_birthDate,selection: selection, selfNum: 0, namespace: namespace)
                        }
                        .padding(.leading, 8)
                        Spacer()
                        Button {
                            withAnimation {
                                selection = 1
                            }
                        } label: {
                            SelectUserComponent(nickname: pair.pair.pair_2_nickname, profileImageURL: pair.pair.pair_2_profileImageURL, activeRegion: pair.pair.pair_2_activeRegion, birthDate: pair.pair.pair_2_birthDate,selection: selection, selfNum: 1, namespace: namespace)
                        }
                        .padding(.trailing, 16)
                    }
                    
                    ZStack(alignment: selection == 0 ? .leading: .trailing) {
                        Rectangle()
                            .foregroundColor(.gray.opacity(0.8))
                            .frame(width: UIScreen.main.bounds.width, height: 2)
                        Rectangle()
                            .foregroundColor(.pink.opacity(0.7))
                            .frame(width: (UIScreen.main.bounds.width/2), height: 2)
                    }
                }
                .frame(height: 80)
                .padding(.bottom, 8)
                
                TabView(selection: $selection){
                    ForEach(userInfos.indices, id: \.self) { index in
                        EasyUserProfileView(user: userInfos[index], offset: $height)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
            }
            .padding(.top, 32)
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("相手のプロフィール")
    }
}

struct ModalGroupProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ModalGroupProfileView(pair: .init(pairModel: .init()))
    }
}
