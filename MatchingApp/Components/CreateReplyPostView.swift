//
//  CreateReplyPostView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/10.
//

import SwiftUI
import SDWebImageSwiftUI

struct CreateReplyPostView: View {
    let post: PostObservableModel
    let fromUser: UserObservableModel
    @StateObject var viewModel = CreateReplyPostViewModel()
    @FocusState var focus: Bool
    @Environment(\.dismiss) var dismiss
    @ObservedObject var reloadPost = ReloadPost.shared
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .heavy)
    var body: some View {
        NavigationView {
            VStack {
                PostView(post: post)
                VStack {
                    HStack(alignment: .top){
                        Image(fromUser.user.profileImageURLString)
                            .resizable()
                            .scaledToFill()
                            .frame(width:20, height: 20)
                            .padding(.all, 8)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(Circle())
                        
                        VStack {
                            ZStack(alignment: .topLeading){
                                TextEditor(text: $viewModel.text)
                                    .scrollContentBackground(.hidden)
                                    .foregroundColor(.customBlack)
                                    .frame(width: UIScreen.main.bounds.width/1.3)
                                    .font(.system(size: 18))
                                    .multilineTextAlignment(.leading)
                                    .focused($focus)
                                    .padding(.top, 16)
                                    .padding(.leading, 8)
                                if viewModel.text.isEmpty {
                                    Text("今日のつぶやき...")
                                        .font(.system(size: 18))
                                        .foregroundColor(.gray)
                                        .padding(.top, 23)
                                        .padding(.leading, 13)
                                }
                            }
                            if !viewModel.contentImages.isEmpty {
                                ScrollView(.horizontal){
                                    HStack {
                                        ForEach(viewModel.contentImages.indices, id: \.self) { index in
                                            ZStack(alignment: .topTrailing){
                                                Image(uiImage: viewModel.contentImages[index])
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 100, height: 100)
                                                    .cornerRadius(20)
                                                    .onTapGesture {
                                                        
                                                    }
                                                
                                                Image(systemName: "xmark.circle.fill")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 30, height: 30)
                                                    .background(Color.white)
                                                    .clipShape(Circle())
                                                    .onTapGesture {
                                                        withAnimation {
                                                            _ = viewModel.contentImages.remove(at: index)
                                                        }
                                                    }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    Spacer()
                }
                .padding(.leading, 8)
                .padding(.top, 8)
                .onAppear {
                    self.focus = true
                    self.viewModel.initial(uid: post.posterUid)
                }
                Spacer()
            }
            .onReceive(viewModel.$isPostSuccess){
                if $0 {
                    self.reloadPost.isRequiredReload = true
                    dismiss()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    Button {
                        Task {
                            UIIFGeneratorMedium.impactOccurred()
                            await viewModel.addPost(post: post, fromUser: fromUser)
                            self.reloadPost.isRequiredReload = true
                        }
                    } label: {
                        Text("投稿する")
                            .foregroundColor(.white)
                                .font(.system(size: 14, weight: .medium))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(viewModel.text.isEmpty || viewModel.isLoading ? Color.gray.opacity(0.3): Color.customRed)
                            .cornerRadius(25)
                    }
                    .disabled(viewModel.text.isEmpty || viewModel.isLoading)
                }
                
                ToolbarItem(placement: .navigationBarLeading){
                    Button {
                        self.focus = false
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.4) {
                            dismiss()
                        }
                    } label: {
                        Text("キャンセル")
                            .foregroundColor(.customBlack)
                            .font(.system(size: 16, weight: .medium))
                    }
                }
            }
        }
    }
}

