//
//  HomeViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/01.
//

import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    
    let daysCategory = ["すべての日付","今すぐ","今日", "明日", "明後日", "その他の日付"]
    
    @Published var selection: Int = 0
    @Published var pairs:[PairObservableModel] = []
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    
    private let fetchFromFirestore = FetchFromFirestore()
    private var cancellable = Set<AnyCancellable>()
    
    
    func fetchUsersInfo(){
        fetchFromFirestore.fetchPairInfo(source: .default)
            .sink { completion in
                switch completion {
                case .finished:
                    print("refresh完了")
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            } receiveValue: { pairs in
                self.pairs = pairs.map {
                    .init(pairModel: $0.adaptPairModel())
                }
            }
            .store(in: &self.cancellable)
    }
    
    func refreshUsersInfo(){
        fetchFromFirestore.fetchPairInfo(source: .server)
            .sink { completion in
                switch completion {
                case .finished:
                    print("refresh完了")
                case .failure(let error):
                    DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {
                        self.isErrorAlert = true
                        self.errorMessage = error.errorMessage
                    }
                }
            } receiveValue: { pairs in
                self.pairs = pairs.map { .init(pairModel: $0.adaptPairModel()) }
            }
            .store(in: &self.cancellable)
    }
}
