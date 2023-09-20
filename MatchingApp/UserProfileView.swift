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


struct UserProfileView: View {
    let userId: String
    let isFromHome: Bool
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = UserProfileViewModel()
    @EnvironmentObject var userModel: UserObservableModel
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .heavy)
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                if let user = viewModel.user {
                    UserBaseProfileView(user: user)
                        .padding(.top, 32)
                    LazyVStack {
                        if viewModel.isLoading {
                            ProgressView()
                        } else {
                            ForEach(viewModel.usersPost.indices, id: \.self) { index in
                                let post = viewModel.usersPost[index]
                                NavigationLink {
                                    PostDetailView(savedScrollDocumentID: .constant(nil), postId: post.id)
                                } label: {
                                    PostView(post: post)
                                        .background(Color.white)
                                        .cornerRadius(20)
                                        .onAppear {
                                            if index == viewModel.usersPost.count - 1 {
                                                if !viewModel.isLastDocumentLoaded {
                                                    viewModel.getNextPage(userID: userId)
                                                }
                                            }
                                        }
                                }
                            }
                        }
                    }
                    .padding(.bottom, 16)
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width)
        .background(Color.gray.opacity(0.1))
        .navigationBarBackButtonHidden(true)
        .refreshable {
            UIIFGeneratorMedium.impactOccurred()
            viewModel.getLatestPosts()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading){
                if !isFromHome {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.customBlack)
                            Text("戻る")
                                .foregroundColor(.customBlack)
                                .font(.system(size: 16, weight: .bold))
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.initial(userId: self.userId)
        }
        .alert(isPresented: $viewModel.isDeleteAccount){
            Alert(
                title: Text("削除されたアカウント"),
                message: Text("このアカウントは現在存在しません。"),
                dismissButton: .default(
                    Text("戻る"), action: {
                        presentationMode.wrappedValue.dismiss()
                    }
                )
            )
        }
    }
}

struct UserBaseProfileView: View {
    let user: UserObservableModel
    @EnvironmentObject var userModel: UserObservableModel
    var body: some View{
        VStack(spacing: .zero){
            Image(user.user.profileImageURLString)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .background(Color.gray.opacity(0.1))
                .clipShape(Circle())
            
            Text(user.user.nickname)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.customBlack)
                .padding(.top, 5)
            
            Spacer()
            Image(user.user.gender == "男性" ? "Man": "Woman")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
            Text(user.user.introduction)
                .font(.caption)
                .padding(.horizontal,16)
                .padding(.top, 8)
            HStack {
                TagViewGenerator.generateTags(
                    UIScreen.main.bounds.width-32,
                    tags: user.user.hobbies
                )
                Spacer()
            }
            .padding(.top, 8)
            if userModel.user.uid == user.user.uid {
                CurrentUserProfileBottomView()
            } else {
                UserProfileBottomView(user: user)
            }
        }
        .padding(.all, 16)
        .frame(width: UIScreen.main.bounds.width-32)
        .background(Color.white)
        .cornerRadius(20)
    }
}
