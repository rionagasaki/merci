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
    @StateObject var viewModel = GoodsListViewModel()
    @EnvironmentObject var userModel: UserObservableModel
    @EnvironmentObject var pairModel: PairObservableModel
    // ここは今組んでるペアだが、フィルタリングで入れ替わる可能あり。
    @State var selectedPair: PairObservableModel?
    
    @EnvironmentObject var appState: AppState
    @State var selected: Bool = false
    @State var filterlingScreen: Bool = false
    @State var offset: CGFloat = 200
    
    func rowRemove(indexSet: IndexSet){
        
    }
    
    var body: some View {
        VStack {
            if viewModel.messageList.count == 0 {
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
                    ForEach(viewModel.messageList) { pair in
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
        .partialSheet(
            isPresented: $filterlingScreen,
            type: .scrollView(height: UIScreen.main.bounds.height/2, showsIndicators: false),
            content: {
                FilterlingFriendView(viewModel: viewModel, pair: $selectedPair)
        })
        .onAppear {
            
            if appState.messageListViewInit {
                viewModel.fetchFriend(friendUids: userModel.friendUids)
                viewModel.messageList = []
                if let selectedPair = selectedPair {
                    viewModel.selectedPairChatRoomIDs = selectedPair.pair.chatPairIDs
                    viewModel.fetch()
                } else {
                    viewModel.selectedPairChatRoomIDs =
                    pairModel.pair.chatPairIDs
                    viewModel.fetch()
                }
                appState.messageListViewInit = false
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing){
                Button {
                    filterlingScreen = true
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
