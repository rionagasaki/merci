//
//  ContentViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/02.
//

import SwiftUI
import Combine

class ContentViewModel: ObservableObject {
    
    let fetchFromFirestore = FetchFromFirestore()
    let setToFirestore = SetToFirestore()
    
    @Published var isLoginModal: Bool = false
    @Published var isRequiredOnboarding: Bool = false
    @Published var isUserInfoSetupRequired: Bool = false
    @Published var selectedTab: Tab = .home
    @Published var navigationTitle:String = ""
    @Published var navigationStyle:Bool = true
    @Published var searchWord = ""
    @Published var isLoading: Bool = false
    @Published var cancellable = Set<AnyCancellable>()
    @Published var isErrorAlert = false
    @Published var errorMessage: String = ""
    @Published var isPairSetUpRequired = false
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    
    func resetUserInfo(userModel: UserObservableModel,pairModel: PairObservableModel, appState: AppState){
        AuthenticationService.shared.signOut()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    appState.messageListViewInit = true
                    appState.notLoggedInUser = true
                    userModel.initial()
                    pairModel.initial()
                    self.isFirstLaunch = false
                    self.fetchFromFirestore.deleteUserListener()
                    self.fetchFromFirestore.deletePairListener()
                    self.fetchFromFirestore.deleteChatListener()
                    self.isLoading = false
                case let .failure(error):
                    print("Error",error)
                    self.isLoading = false
                }
            }, receiveValue: { _ in
                print("Recieve Value!")
            })
            .store(in: &cancellable)
    }
    
    
    func initialUserInfo(userModel: UserObservableModel, pairModel: PairObservableModel, appState: AppState){
        isLoading = true
        guard let uid = AuthenticationManager.shared.uid else { return }
        self.fetchFromFirestore.monitorUserUpdates(uid: uid)
            .flatMap { user -> AnyPublisher<Pair, AppError> in
                userModel.user = user.adaptUserObservableModel()
                // ユーザー登録を最後まで完了していない場合
                if userModel.user.nickname.isEmpty || userModel.user.gender.isEmpty || userModel.user.activeRegion.isEmpty || userModel.user.birthDate.isEmpty || userModel.user.profileImageURL.isEmpty {
                    print(user.nickname)
                    print(user.gender)
                    print(user.activityRegion)
                    print(user.birthDate)
                    print(user.profileImageURL)
                    self.isUserInfoSetupRequired = true
                    self.isLoading = false
                    appState.messageListViewInit = true
                    return Empty(completeImmediately: true).eraseToAnyPublisher()
                }
                
                // オンボーディングを最後まで完了していない場合
                
                if !user.onboarding {
                    self.isRequiredOnboarding = true
                    self.isLoading = false
                    return Empty(completeImmediately: true).eraseToAnyPublisher()
                }
                
                // 未既読なチャットがある場合
                if userModel.user.unreadMessageCount.values.contains(where: { $0 > 0 }) {
                    appState.messageListNotification = true
                }
                
                // ペアを組んでいない場合
                if userModel.user.pairID.isEmpty {
                    self.isLoading = false
                    return Empty(completeImmediately: true).eraseToAnyPublisher()
                } else {
                    return self.fetchFromFirestore.monitorPairInfoUpdate(pairID: userModel.user.pairID)
                }
            }
            .flatMap { pair -> AnyPublisher<User?, AppError> in
                pairModel.pair = pair.adaptPairModel()
                return self.fetchFromFirestore.fetchUserInfoFromFirestoreByUserID(uid: userModel.user.pairUid)
            }
            .sink { completion in
                switch completion {
                case .finished:
                    print("remove listener when application is not active")
                case let .failure(error):
                    print(error)
                    self.isErrorAlert = true
                    self.isLoading = false
                }
            } receiveValue: { user in
                if let user = user {
                    appState.pairUserModel.user =
                    user.adaptUserObservableModel()
                    appState.messageListViewInit = true
                    self.isLoading = false
                }
            }
            .store(in: &self.cancellable)
    }
    
    func updateUserTokenAndInitialUserInfo(token: String){
        guard let uid = AuthenticationManager.shared.uid else { return }
        setToFirestore.userFcmTokenUpdate(uid: uid, token: token)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("token successfully update")
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
