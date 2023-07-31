//
//  HomeView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/01.
//

import SwiftUI
import Combine

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var userModel: UserObservableModel
    @EnvironmentObject var pairModel: PairObservableModel
    let fetchFromFirestore = FetchFromFirestore()
    @State var isFailedLoadPairInfo: Bool = false
    @State var cancellable = Set<AnyCancellable>()
    var body: some View {
        
        VStack(spacing: .zero) {
            if viewModel.pairs.count == 0 {
                ScrollView {
                    
                }
                .refreshable {
                    viewModel.refreshUsersInfo()
                }
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20){
                        ForEach(viewModel.pairs) { pair in
                            
                            NavigationLink {
                                UserPairProfileView(
                                    pair: pair
                                )
                            } label: {
                                PairCardView(pairModel: pair)
                            }
                        }
                    }
                    .padding(.vertical,8)
                    
                }
                .refreshable {
                    viewModel.refreshUsersInfo()
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
            ToolbarItem(placement: .principal) {
                Text("NiNi")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.pink)
            }
        }
        .onAppear {
            if appState.homeViewInit {
                viewModel.fetchUsersInfo()
                appState.homeViewInit = false
            }
        }
        .alert(isPresented: $viewModel.isErrorAlert) {
            Alert(title: Text("エラー"), message: Text(viewModel.errorMessage))
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
