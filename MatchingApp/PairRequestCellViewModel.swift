//
//  PairRequestCellViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/13.
//

import Foundation
import Combine

class PairRequestCellViewModel: ObservableObject {
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    let setToFirestore = SetToFirestore()
    private var cancellable = Set<AnyCancellable>()
    
    func approve(requestUser: UserObservableModel, requestedUser: UserObservableModel){
        setToFirestore
            .pairApprove(requestUser: requestUser, requestedUser: requestedUser)
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            } receiveValue: { _ in
                print("recieve value")
            }
            .store(in: &self.cancellable)
    }
}
