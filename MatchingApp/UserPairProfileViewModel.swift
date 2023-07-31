//
//  UserPairProfileViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/10.
//

import Foundation
import SwiftUI
import Combine

class UserPairProfileViewModel: ObservableObject {
    @Published var userProfiles:[UserObservableModel] = []
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    @Published var selectedImageIndex: Int = 0 {
        didSet {
            if selectedImageIndex == 0 {
                withAnimation {
                    self.offset = 0
                }
            } else if selectedImageIndex == 1 {
                withAnimation {
                    self.offset = UIScreen.main.bounds.width/2
                }
            }
        }
    }
    
    @Published var offset: CGFloat = 0
    @Published var isReportAbuseModal: Bool = false
    let fetchFromFirestore = FetchFromFirestore()
    private var cancellable = Set<AnyCancellable>()
    
    func fetchUserInfo(pair: PairObservableModel){
        self.userProfiles = []
        fetchFromFirestore.fetchConcurrentUserInfo(userIDs: [pair.pair.pair_1_uid, pair.pair.pair_2_uid])
            .sink { completion in
                switch completion {
                case .finished:
                    print("refresh完了")
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            } receiveValue: { users in
                self.userProfiles = users.map { .init(userModel: $0.adaptUserObservableModel()) }
            }
            .store(in: &self.cancellable)
    }
}
