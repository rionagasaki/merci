//
//  NotificationListView.swift
//  MovieShare
//
//  Created by Rio Nagasaki on 2023/07/27.
//

import SwiftUI
import AlertToast

struct NotificationListView: View {
    @StateObject var viewModel = NotificationListViewModel()
    @EnvironmentObject var userModel: UserObservableModel
    @EnvironmentObject var appState: AppState
    @State var reloadPost: Bool = false
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .heavy)
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    ForEach(viewModel.noticeSections.indices, id: \.self) { index in
                        HStack {
                            if viewModel.activeNoticeType.contains(viewModel.noticeSections[index]) {
                                Circle()
                                    .foregroundColor(.pink)
                                    .frame(width: 10, height: 10)
                            }
                            Button {
                                withAnimation {
                                    viewModel.selectedCategory = index
                                }
                            } label: {
                                Text(viewModel.noticeSections[index].rawValue)
                                    .font(.system(size: 16, weight: viewModel.selectedCategory == index ? .bold: .regular))
                                    .foregroundColor(
                                        viewModel.selectedCategory == index ? .customBlack: .gray.opacity(0.5)
                                    )
                                    .padding(.top, 16)
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width/3)
                    }
                }
                .frame(width: UIScreen.main.bounds.width)
                
                ZStack(alignment: viewModel.selectedCategory == 0 ? .leading: viewModel.selectedCategory == 1 ? .center: .trailing) {
                    Rectangle()
                        .foregroundColor(.gray.opacity(0.8))
                        .frame(width: UIScreen.main.bounds.width, height: 2)
                    Rectangle()
                        .foregroundColor(.customBlack)
                        .frame(width: (UIScreen.main.bounds.width/3), height: 2)
                }
            }
            
            TabView(selection: $viewModel.selectedCategory) {
                ScrollView {
                    if viewModel.likeNotices.count == 0 {
                        VStack(spacing: 8){
                            Image("Heart")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 96, height: 96)
                            
                            Text("まだいいねが届いていないよ")
                                .foregroundColor(.customBlack)
                                .font(.system(size: 18, weight: .bold))
                        }
                        .padding(.top, 128)
                        
                    } else {
                        ForEach(viewModel.likeNotices) { notice in
                            NavigationLink {
                                PostDetailView(
                                    savedScrollDocumentID: .constant(nil),
                                    postId: notice.recieverPostId
                                )
                            } label: {
                                LikeNoticeCellView(notice: notice)
                            }
                        }
                    }
                }
                .refreshable {
                    UIIFGeneratorMedium.impactOccurred()
                    viewModel.getLikeNotice(userID: userModel.user.uid)
                }
                .tag(0)
                
                ScrollView {
                    if viewModel.commentNotices.count == 0 {
                        VStack(spacing: 8){
                            Image("Comment")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 96, height: 96)
                            
                            Text("まだコメントが届いていないよ")
                                .foregroundColor(.customBlack)
                                .font(.system(size: 18, weight: .bold))
                        }
                        .padding(.top, 128)
                    } else {
                        ForEach(viewModel.commentNotices) { notice in
                            NavigationLink {
                                PostDetailView(savedScrollDocumentID: .constant(nil), postId: notice.recieverPostId)
                                    .onAppear {
                                        viewModel
                                            .updateReadStatus(
                                                noticeType: "CommentNotice",
                                                noticeID: notice.id,
                                                userID: userModel.user.uid,
                                                appState: appState)
                                    }
                            } label: {
                                CommentNoticeCellView(notice: notice)
                            }
                        }
                    }
                }
                .refreshable {
                    UIIFGeneratorMedium.impactOccurred()
                    viewModel.getCommentNotice(userID: userModel.user.uid, appState: appState)
                }
                .tag(1)
                
                ScrollView {
                    if viewModel.followNotices.count == 0 {
                        VStack(spacing: 8){
                            Image("Request")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 96, height: 96)
                            Text("まだリクエストが届いていないよ")
                                .foregroundColor(.customBlack)
                                .font(.system(size: 18, weight: .bold))
                        }
                        .padding(.top, 128)
                    } else {
                        ForEach(viewModel.followNotices) { notice in
                            NavigationLink {
                                UserProfileView(userId: notice.triggerUserUid, isFromHome: false)
                                    .onAppear {
                                        viewModel
                                            .updateReadStatus(
                                                noticeType: "RequestNotice",
                                                noticeID: notice.id,
                                                userID: userModel.user.uid,
                                                appState: appState)
                                    }
                            } label: {
                                RequestNoticeCellView(notice: notice)
                            }
                        }
                    }
                }
                .refreshable {
                    UIIFGeneratorMedium.impactOccurred()
                    self.viewModel.getRequestNotice(userID: userModel.user.uid, appState: appState)
                }
                .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading){
                VStack(spacing: 4){
                    Text("リアクション")
                        .foregroundColor(.customBlack)
                        .font(.system(size: 24, weight: .bold))
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.customBlue.opacity(0.5))
                        .frame(height: 3)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing){
                Button {
                    viewModel.isUpdateReadStatus = true
                } label: {
                    Image("isRead")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 32, height: 32)
                }
            }
        }
        .onAppear {
            viewModel.getNotice(appState: appState, userID: userModel.user.uid)
        }
        .alert(isPresented: $viewModel.isUpdateReadStatus){
            Alert(
                    title: Text("一括で既読"),
                    message: Text("未読の通知が一括で既読に設定されます。続行しますか？"),
                    primaryButton: .default(Text("続行")) {
                        viewModel.updateAllNoticeReadStatus(userID: userModel.user.uid, appState: appState)
                    },
                    secondaryButton: .cancel(Text("キャンセル"))
                )
        }
        .toast(isPresenting: $viewModel.isLoading) {
            AlertToast(type: .loading)
        }
    }
}

struct NotificationListView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationListView()
    }
}
