//
//  ReportPostView.swift
//  Merci
//
//  Created by Rio Nagasaki on 2023/10/11.
//

import SwiftUI
import SDWebImageSwiftUI

struct ReportPostView: View {
    @StateObject var viewModel = ReportPostViewModel()
    @EnvironmentObject var userModel: UserObservableModel
    @FocusState var focus: Bool
    let post: PostObservableModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            VStack {
                HStack(alignment: .top){
                    Image(post.posterProfileImageUrlString)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .padding(.all, 8)
                        .background(Color.customLightGray)
                        .clipShape(Circle())
                    VStack(alignment: .leading) {
                        HStack {
                            Text(post.posterNickName)
                                .foregroundColor(.customBlack)
                                .font(.system(size: 18, weight: .bold))
                            Spacer()
                            Text(post.createdAt)
                                .foregroundColor(.gray.opacity(0.6))
                                .font(.system(size: 14))
                            
                            Text("")
                                .frame(width: 24, height: 24)
                                .padding(.leading, 4)
                        }
                        
                        if !post.mentionUserNickName.isEmpty {
                            Text("Re:\(post.mentionUserNickName)")
                                .foregroundColor(.white)
                                .font(.system(size: 12))
                                .padding(.vertical, 4)
                                .padding(.horizontal, 8)
                                .background(Color.customBlue.opacity(0.5))
                                .cornerRadius(10)
                        }
                        
                        ScrollView {
                            VStack(alignment: .leading){
                                Text(post.text)
                                    .foregroundColor(.customBlack)
                                    .font(.system(size: 16))
                                    .multilineTextAlignment(.leading)
                                
                                if !post.contentImageUrlStrings.isEmpty {
                                    LazyVStack {
                                        HStack {
                                            LazyVGrid(columns: Array(repeating: .init(.fixed((UIScreen.main.bounds.width / 4)), spacing: 8), count: 2)) {
                                                ForEach(post.contentImageUrlStrings, id: \.self) { contentImageString in
                                                    WebImage(url: URL(string: contentImageString))
                                                        .resizable()
                                                        .indicator(.activity)
                                                        .transition(.fade(duration: 0.5))
                                                        .scaledToFill()
                                                        .frame(width: (UIScreen.main.bounds.width)/4, height: (UIScreen.main.bounds.width)/4)
                                                        .background(Color.gray.opacity(0.1))
                                                        .cornerRadius(10)
                                                }
                                            }
                                            Spacer()
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.leading, 16)
                    Spacer()
                }
                .padding(.horizontal, 16)
                Spacer()
                HStack {
                    Text("問題点")
                        .foregroundColor(.customBlack)
                        .font(.system(size: 20, weight: .medium))
                    Spacer()
                }
                .padding(.horizontal, 16)
                VStack(alignment: .leading){
                    Spacer()
                    TextEditor(text: $viewModel.reportText)
                    .padding(.all, 16)
                    .focused(self.$focus)
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width-48)
                .background(Color.customRed.opacity(0.2))
                .cornerRadius(20)
                .padding(.top, 8)
                Spacer()
            }
            .onAppear {
                self.focus = true
            }
            .onReceive(viewModel.$isSuccessPostReport){
                if $0 { dismiss() }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    Button {
                        Task {
                            await viewModel.addReportToPost(
                                from: userModel.user.uid,
                                to: post.posterUid,
                                postID: post.id,
                                postText: post.text
                            )
                        }
                    } label: {
                        Text("通報する")
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .medium))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(viewModel.reportText.isEmpty || viewModel.isLoading ? Color.gray.opacity(0.3): Color.customRed)
                            .cornerRadius(25)
                    }
                    .disabled(viewModel.reportText.isEmpty || viewModel.isLoading)
                }
                
                ToolbarItem(placement: .principal) {
                    Text("通報")
                        .foregroundColor(.customBlack)
                        .font(.system(size: 16, weight: .medium))
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
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
