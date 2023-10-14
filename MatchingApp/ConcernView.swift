//
//  ConcernView.swift
//  Merci
//
//  Created by Rio Nagasaki on 2023/10/02.
//

import SwiftUI

struct ConcernListView: View {
    @StateObject var viewModel: HomeViewModel
    @EnvironmentObject var userModel: UserObservableModel
    @State var concern: ConcernObservableModel = .init()
    private let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .heavy)
        
    var body: some View {
        ScrollView {
            LazyVStack {
                if viewModel.concernPosts.count == 0 {
                    Text("まだお悩みがありません")
                } else {
                    ForEach(viewModel.concernPosts.indices, id: \.self) { index in
                        let count = viewModel.concernPosts.count
                        let concern = viewModel.concernPosts[index]
                        ConcernView(concern: concern, isResolveModal: $viewModel.isResolveModal, resolveConcern: $concern)
                            .onAppear {
                                Task {
                                    if index == count - 1 {
                                        if !viewModel.isConcernLastDocumentLoaded {
                                            await viewModel.getConcernNextPage(userModel: userModel)
                                        }
                                    }
                                }
                            }
                    }
                }
            }
            .padding(.vertical, 16)
        }
        .refreshable {
            Task {
                self.UIIFGeneratorMedium.impactOccurred()
                await self.viewModel.getLatestConcernPost(userModel: userModel)
            }
        }
        .background(Color.customLightGray)
        .fullScreenCover(isPresented: $viewModel.isResolveModal){
            ResolveView(concern: self.concern)
        }
    }
}

struct ConcernView: View {
    let concern: ConcernObservableModel
    @Binding var isResolveModal: Bool
    @Binding var resolveConcern: ConcernObservableModel
    var body: some View {
        VStack(spacing: .zero){
            HStack(alignment: .top){
                Image(concern.posterProfileImageUrlString)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 24, height: 24)
                    .padding(.all, 8)
                    .background(Color.customLightGray)
                    .clipShape(Circle())
                Text(concern.posterNickname)
                    .foregroundColor(.customBlack)
                    .font(.system(size: 16, weight: .medium))
                    .padding(.top, 4)
                Spacer()
                Text(concern.createdAt)
                    .foregroundColor(.gray.opacity(0.6))
                    .font(.system(size: 14))
                    .padding(.top, 4)
                    .padding(.trailing, 4)
            }
            .padding(.horizontal, 16)
            
            HStack {
                Text(concern.concernKind)
                    .foregroundColor(.customBlack)
                    .font(.system(size: 16, weight: .medium))
                
                Image(concern.concernKindImageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 24, height: 24)
                    .padding(.all, 8)
                    .background(Color.customLightGray)
                    .clipShape(Circle())
            }
            Text(concern.concernText)
                .foregroundColor(.customBlack)
                .font(.system(size: 16, weight: .regular))
                .padding(.top, 8)
                .padding(.horizontal, 16)
            
            Button {
                self.resolveConcern = concern
                self.isResolveModal = true
            } label: {
                Text("メッセージを送る")
                    .foregroundColor(.white)
                    .font(.system(size: 14, weight: .medium))
            }
            .padding(.all, 8)
            .background(Color.customRed.opacity(0.8))
            .cornerRadius(20)
            .padding(.vertical, 24)

        }
        .frame(width: UIScreen.main.bounds.width-32)
        .padding(.vertical, 16)
        .background(Color.white)
        .cornerRadius(20)
    }
}
