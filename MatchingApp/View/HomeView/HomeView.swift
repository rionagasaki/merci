//
//  HomeView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/01.
//

import SwiftUI
import Supabase

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject var userModel: UserObservableModel
    @EnvironmentObject var pairModel: PairObservableModel
    
    var body: some View {
        
        VStack(spacing: .zero) {
            Text("相手をさがす")
                .foregroundColor(.black)
                .bold()
                .font(.system(size: 25))
                .padding(.all,16)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(showsIndicators: false) {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20){
                        ForEach(viewModel.pairs) { pair in
                            NavigationLink {
                                    GroupProfileView(
                                        myPair: pairModel,
                                        pairModel: pair
                                    )
                            } label: {
                                RecruitmentView(pairModel: pair)
                            }
                        }
                    }
                    .padding(.top,8)
                }
            }
            .refreshable {
                viewModel.pairs = []
                FetchFromFirestore().fetchPairInfo { pairs in
                    pairs.forEach { pair in
                        viewModel.pairs.append(.init(
                            id: pair.id,
                            gender: pair.gender,
                            pair_1_uid: pair.pair_1_uid,
                            pair_1_nickname: pair.pair_1_nickname,
                            pair_1_profileImageURL: pair.pair_1_profileImageURL,
                            pair_1_activeRegion: pair.pair_1_activeRegion,
                            pair_1_birthDate: pair.pair_1_birthDate,
                            pair_2_uid: pair.pair_2_uid,
                            pair_2_nickname: pair.pair_2_nickname,
                            pair_2_profileImageURL: pair.pair_2_profileImageURL,
                            pair_2_activeRegion: pair.pair_2_activeRegion,
                            pair_2_birthDate: pair.pair_2_birthDate
                        )
                        )
                    }
                }
            }
        }
        .onAppear {
            viewModel.pairs = []
            FetchFromFirestore().fetchPairInfo { pairs in
                pairs.forEach { pair in
                    
                    viewModel.pairs.append(.init(
                        id: pair.id,
                        gender: pair.gender,
                        pair_1_uid: pair.pair_1_uid,
                        pair_1_nickname: pair.pair_1_nickname,
                        pair_1_profileImageURL: pair.pair_1_profileImageURL,
                        pair_1_activeRegion: pair.pair_1_activeRegion,
                        pair_1_birthDate: pair.pair_1_birthDate,
                        pair_2_uid: pair.pair_2_uid,
                        pair_2_nickname: pair.pair_2_nickname,
                        pair_2_profileImageURL: pair.pair_2_profileImageURL,
                        pair_2_activeRegion: pair.pair_2_activeRegion,
                        pair_2_birthDate: pair.pair_2_birthDate
                    )
                    )
                }
            }
        }
    }
}

struct CityModel: Identifiable {
    let id: Int
    let name: String
    let country_id:Int
}

private func makeHeader(headerTitle: String, contentImage: Image) -> some View {
    return contentImage
        .resizable()
        .frame(width: UIScreen.main.bounds.width-30,height:200)
        .scaledToFill()
        .modifier(HeaderImageModifier(headerTitle: headerTitle))
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
