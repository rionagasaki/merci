//
//  ProfileAttributeSelectorViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/06.
//

import Foundation
import Combine

class ProfileAttributeSelectorViewModel: ObservableObject {
    @Published var isFailureAlert: Bool = false
    let setToFirestore = SetToFirestore()
    private var cancellable = Set<AnyCancellable>()
    
    func storedProfileData(uid: String, fieldName: String, value: String, currentValue: String){
        setToFirestore.updateDetailProfile(uid: uid, fieldName: fieldName, value: value)
            .flatMap { _ in
                if currentValue.isEmpty {
                    return self.setToFirestore.addCoins(uid: uid, increaseCoins: 10)
                } else {
                    return Just(()).setFailureType(to: AppError.self).eraseToAnyPublisher()
                }
            }
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(_):
                    self.isFailureAlert = true
                }
            } receiveValue: { _ in
                print("Recieve Value")
            }
            .store(in: &self.cancellable)
    }
}
