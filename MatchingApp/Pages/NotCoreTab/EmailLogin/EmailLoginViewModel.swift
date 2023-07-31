//
//  LoginViewModel.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/12/29.
//

import SwiftUI
import Combine

class EmailLoginViewModel: ObservableObject {
    let fetchFromFirestore = FetchFromFirestore()
    let setToFirestore = SetToFirestore()
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isVisibleValidateAlert: Bool = false
    @Published var isEmailEmpty: Bool = true
    @Published var isPasswordEmpty: Bool = true
    @Published var isModal: Bool = false
    @Published var registerSheet: Bool = false
    
    @Published var isInitialLoadingFailed: Bool = false
    @Published var errorMessage: String = ""
    
    @ObservedObject var tokenData = TokenData.shared
    private var cancellable = Set<AnyCancellable>()
    
    var isEnabledTappedLoginButton: Bool { !isEmailEmpty && !isPasswordEmpty }
    
    
    func validateEmail(){
        isEmailEmpty = email == ""
    }
    func validatePassword(){
        isPasswordEmpty = password == ""
    }
    
    func signInWithEmail(
        userModel: UserObservableModel,
        pairModel: PairObservableModel,
        appState: AppState
    ){
        AuthenticationService.shared.signInWithEmail(email: self.email, password: self.password)
            .flatMap { result in
                userModel.user.uid = result.user.uid
                return self.setToFirestore.userFcmTokenUpdate(uid: userModel.user.uid, token: self.tokenData.token)
            }
            .flatMap { _ -> AnyPublisher<User, AppError> in
                return self.fetchFromFirestore.monitorUserUpdates(uid: userModel.user.uid)
            }
            .flatMap { user -> AnyPublisher<Pair, AppError> in
                userModel.user = user.adaptUserObservableModel()
                if userModel.user.unreadMessageCount.values.contains(where: { $0 > 0 }) {
                    appState.messageListNotification = true
                }
                
                if userModel.user.pairID.isEmpty {
                    appState.messageListViewInit = true
                    appState.notLoggedInUser = false
                    return Empty(completeImmediately: true).eraseToAnyPublisher()
                } else {
                    return self.fetchFromFirestore.monitorPairInfoUpdate(pairID: userModel.user.pairID)
                }
            }
            .flatMap { pair -> AnyPublisher<User?, AppError> in
                return self.fetchFromFirestore.fetchUserInfoFromFirestoreByUserID(uid: userModel.user.pairID)
            }
            .sink { completion in
                switch completion {
                case .finished:
                    print("ここは呼ばれん")
                case .failure(let error):
                    self.isInitialLoadingFailed = true
                    self.errorMessage = error.errorMessage
                }
            } receiveValue: { user in
                appState.messageListViewInit = true
                appState.notLoggedInUser = false
                if let user = user {
                    appState.pairUserModel.user = user.adaptUserObservableModel()
                }
            }
            .store(in: &cancellable)
    }
    
}



