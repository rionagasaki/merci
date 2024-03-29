//
//  PostDetailView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/11.
//

import SwiftUI

struct PostDetailView: View {
    @StateObject var viewModel = PostDetailViewModel()
    @Environment(\.dismiss) var dismiss
    @ObservedObject var reloadPost = ReloadPost.shared
    @Binding var savedScrollDocumentID: String?
    let postId: String
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .heavy)
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: .zero){
                        if viewModel.parentPosts.count != 0 {
                            ForEach(viewModel.parentPosts) { post in
                                PostView(post: post)
                            }
                            .padding(.top, 8)
                        }
                        
                        if let selfPost = viewModel.selfPost {
                            PostView(post: selfPost)
                                .padding(.top, 8)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(20)
                        }
                        
                        ForEach(viewModel.childPosts) { post in
                            PostView(post: post)
                                .padding(.top, 8)
                        }
                        .padding(.top, 8)
                    }
                }
                .refreshable {
                    UIIFGeneratorMedium.impactOccurred()
                    self.viewModel.initial(postId: postId)
                }
            }
        }
        .onAppear {
            self.viewModel.initial(
                postId: postId
            )
        }
        .toolbar {
            ToolbarItem(placement: .principal){
                Text("関連つぶやき")
                    .foregroundColor(.customBlack)
                    .font(.system(size: 16, weight: .bold))
            }
        }
        .onDisappear {
            self.savedScrollDocumentID = postId
        }
    }
}
