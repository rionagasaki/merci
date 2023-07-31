//
//  UserProfileView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/26.
//

import SwiftUI
import SDWebImageSwiftUI
import AlertToast
import Popovers

enum PairStatus {
    case noPair
    case alreadyHasPair
}

struct UserProfileView: View {
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .medium)
    @StateObject var viewModel = UserProfileViewModel()
    @EnvironmentObject var userModel: UserObservableModel
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var showToast = false
    let user: UserObservableModel
    var pairStatus: PairStatus {
        if !userModel.user.pairUid.isEmpty {
            return .alreadyHasPair
        } else {
            return .noPair
        }
    }
    
    var body: some View {
        VStack{
            Text("\(user.user.nickname)さんはまだペアを組んでいません。")
                .frame(width: UIScreen.main.bounds.width-32)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .padding(.vertical, 8)
                .background(Color.orange.opacity(0.7))
                .cornerRadius(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.orange, lineWidth: 2)
                }
                .padding(.top, 16)
            
            ZStack(alignment: .top){
                ScrollView {
                    VStack {
                        WebImage(url: URL(string: user.user.profileImageURL))
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width-30, height:UIScreen.main.bounds.width-30)
                            .cornerRadius(10)
                            .padding(.top, 32)
                        
                        if let age = CalculateAge.calculateAge(from: user.user.birthDate) {
                            HStack {
                                VStack(alignment: .leading, spacing: .zero){
                                    Text(user.user.nickname)
                                        .foregroundColor(.black)
                                        .font(.system(size: 25))
                                        .fontWeight(.bold)
                                        .padding(.top, 8)
                                        .padding(.leading, 16)
                                    Text("\(age)歳・\(user.user.activeRegion)")
                                        .foregroundColor(.customBlack.opacity(0.8))
                                        .font(.system(size: 13))
                                        .fontWeight(.bold)
                                        .padding(.vertical, 2)
                                        .padding(.leading, 16)
                                }
                                Spacer()
                            }
                            .padding(.top, 8)
                        }
                        VStack(spacing: .zero){
                            Text("自己紹介")
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.customBlack)
                                .font(.system(size: 18, weight: .bold))
                            
                            HStack {
                                Text(user.user.introduction)
                                    .foregroundColor(.customBlack)
                                    .font(.system(size: 16))
                                Spacer()
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 32)
                        VStack(spacing: .zero){
                            Text("興味")
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.customBlack)
                                .font(.system(size: 18, weight: .bold))
                            
                            HStack {
                                TagViewGenerator.generateTags(UIScreen.main.bounds.width-32, tags: user.user.hobbies)
                                Spacer()
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 32)
                        
                        VStack {
                            Text("プロフィール")
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.customBlack)
                                .font(.system(size: 18, weight: .bold))
                            
                            ForEach(ProfileDetailItem.allCases) { detailProfile in
                                ProfileAttributeView(user: user, selectedDetailProfile: detailProfile)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 32)
                    }
                }
            }
            
            Button {
                viewModel.createPairRequest(requestingUser: userModel, requestedUser: user)
            } label: {
                Text("ペアリクエスト")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .bold))
                    .frame(width: UIScreen.main.bounds.width-32, height: 50)
                    .background(Color.customRed)
                    .cornerRadius(30)
                    .padding(.bottom, 16)
            }

        }
        .alert(isPresented: $viewModel.isErrorAlert){
            Alert(title: Text("エラー"), message: Text(viewModel.errorMessage))
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("\(user.user.nickname)のプロフ")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
            }
        }
        .toolbar {
            ToolbarItem {
                Menu {
                    Button("問題を報告する", action: { self.viewModel.isReportAbuseModal = true })
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.black)
                }
            }
        }
    }
}

struct PairButtonView: View {
    
    let requestingUser: UserObservableModel
    let requestedUser: UserObservableModel
    @StateObject var viewModel: UserProfileViewModel
    
    var body: some View {
        Button {
            viewModel.createPairRequest(
                requestingUser: requestingUser,
                requestedUser: requestedUser
            )
        } label: {
            Text("ペアを組む")
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .bold))
        }
        .frame(width: UIScreen.main.bounds.width-32, height: 50)
        .background(Color.customRed)
        .cornerRadius(30)

    }
}
