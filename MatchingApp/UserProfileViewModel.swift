//
//  UserProfileViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/26.
//

import Foundation
import Combine

class UserProfileViewModel: ObservableObject {
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    @Published var isReportAbuseModal: Bool = false
    @Published var pairStatus: PairStatus = .noPair
    let setToFirestore = SetToFirestore()
    private var cancellable = Set<AnyCancellable>()
    
    
    func createPairRequest(requestingUser: UserObservableModel, requestedUser: UserObservableModel){
        setToFirestore
            .requestPair(requestingUser: requestingUser, requestedUser: requestedUser)
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            } receiveValue: { _ in
                print("revieve value")
            }
            .store(in: &self.cancellable)
    }
}
