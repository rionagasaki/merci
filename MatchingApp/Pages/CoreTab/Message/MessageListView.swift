//
//  SendGoodsListView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/02.
//

import SwiftUI
import SDWebImageSwiftUI
import PartialSheet

struct MessageListView: View {
    @State var selection: Int = 0
    @StateObject var viewModel = MessageListViewModel()
    @EnvironmentObject var userModel: UserObservableModel
    @EnvironmentObject var pairModel: PairObservableModel
    
    @EnvironmentObject var appState: AppState
    @State var selected: Bool = false
    @State var offset: CGFloat = 200
    
    func rowRemove(indexSet: IndexSet){
        
    }
    
    var body: some View {
        VStack {
            if viewModel.selectedChatPartnerMessageList.count == 0 {
                Spacer()
                VStack(spacing: 8){
                    Text("💬")
                        .font(.system(size: 30, weight: .bold))
                    Text("表示できるメッセージがありません")
                        .foregroundColor(.customBlack)
                        .font(.system(size: 18, weight: .bold))
                }
                Spacer()
            } else {
                List {
                    ForEach(viewModel.selectedChatPartnerMessageList) { pair in
                        NavigationLink {
                            ChatView(pair: pair)
                        } label: {
                            MessageListCellView(pair: pair)
                        }
                    }
                    .onDelete(perform: rowRemove)
                }
                .listStyle(.plain)
            }
        }
        .halfModal(
            isPresented: $viewModel.isSelectChatPairHalfModal){
            FilterlingFriendView(userModel: userModel, viewModel: viewModel)
        }
        .onAppear {
            if appState.messageListViewInit {
                viewModel.selectedChatPartnerMessageList = []
                viewModel.fetchChatPartnerInfo(chatPartnerUsersMapping: userModel.user.pairMapping)
                appState.messageListViewInit = false
            }
        }
        .alert(isPresented: $viewModel.isErrorAlert){
            Alert(title: Text("エラー"), message: Text(viewModel.errorMessage))
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing){
                Button {
                    viewModel.isSelectChatPairHalfModal = true
                } label: {
                    Image(systemName: "line.3.horizontal.decrease")
                }
                .foregroundColor(.black)
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("メッセージルーム")
                    .foregroundColor(.black)
                    .font(.system(size: 22, weight: .bold))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MessageListView_Previews: PreviewProvider {
    static var previews: some View {
        MessageListView()
    }
}
