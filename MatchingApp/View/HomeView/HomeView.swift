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
            ScrollView(showsIndicators: false) {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20){
                        ForEach(viewModel.pairs) { pair in
                            
                            NavigationLink {
                                GroupProfileView(
                                    pair: pair
                                )
                            } label: {
                                RecruitmentView(pairModel: pair)
                            }
                        }
                    }
                    .padding(.vertical,8)
                }
            }
            .refreshable {
                viewModel.pairs = []
                FetchFromFirestore().fetchPairInfo { pairs in
                    pairs.forEach { pair in
                        viewModel.pairs.append(.init(
                            pairModel: pair.adaptPairModel()
                        )
                        )
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem {
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(.customBlack)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Text("🐰NiNi")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.pink)
            }
        }
        .onAppear {
            viewModel.pairs = []
            FetchFromFirestore().fetchPairInfo { pairs in
                pairs.forEach { pair in
                    
                    viewModel.pairs.append(.init(
                        pairModel: pair.adaptPairModel()
                    ))
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


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
