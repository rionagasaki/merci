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
    let pair: PairObservableModel
    
    var body: some View {
        VStack {
            Image(systemName: "")
            ScrollView {
                VStack {
                    HStack {
                        Button {
                            withAnimation {
                                selection = 0
                            }
                        } label: {
                            SelectUserComponent(nickname: pair.pair_1_nickname, profileImageURL: pair.pair_1_profileImageURL, activeRegion: pair.pair_1_activeRegion, birthDate: pair.pair_1_birthDate,selection: selection, selfNum: 0, namespace: namespace)
                        }
                        .padding(.leading, 8)
                        Spacer()
                        Button {
                            withAnimation {
                                selection = 1
                            }
                        } label: {
                            SelectUserComponent(nickname: pair.pair_2_nickname, profileImageURL: pair.pair_2_profileImageURL, activeRegion: pair.pair_2_activeRegion, birthDate: pair.pair_2_birthDate,selection: selection, selfNum: 1, namespace: namespace)
                        }
                        .padding(.trailing, 16)
                    }
                    
                    ZStack(alignment: selection == 0 ? .leading: .trailing) {
                        Rectangle()
                            .foregroundColor(.gray.opacity(0.8))
                            .frame(width: UIScreen.main.bounds.width, height: 2)
                        Rectangle()
                            .foregroundColor(.customGreen)
                            .frame(width: (UIScreen.main.bounds.width/2), height: 2)
                            
                    }
                }
                .padding(.bottom, 8)
                
                TabView(selection: $selection){
                    ForEach(0..<2) { index in
                        if index == 0 {
                            EasyUserProfileView(nickname: pair.pair_1_nickname, profileImageURL: pair.pair_1_profileImageURL, activeRegion: pair.pair_1_activeRegion, birthDate: pair.pair_1_birthDate)
                        } else {
                            EasyUserProfileView(nickname: pair.pair_2_nickname, profileImageURL: pair.pair_2_profileImageURL, activeRegion: pair.pair_2_activeRegion, birthDate: pair.pair_2_birthDate)
                        }
                    }
                }
                .frame(height: UIScreen.main.bounds.height)
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
        ModalGroupProfileView(pair: .init())
    }
}
