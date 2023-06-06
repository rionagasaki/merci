//
//  SendGoodsListView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/02.
//

import SwiftUI

struct MessageListView: View {
    @State var selection: Int = 0
    @StateObject var viewModel = GoodsListViewModel()
    @EnvironmentObject var pairModel: PairObservableModel
    @EnvironmentObject var appState: AppState
    @State var deleteScreen: Bool = false
    @State var offset: CGFloat = 200
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: .zero){
                    ForEach(viewModel.messageList) { pair in
                        HStack {
                            if deleteScreen {
                                CheckBoxView()
                                    .padding(.leading, 16)
                            }
                            MessageListCellView(pair: pair)
                        }
                    }
                }
            }
            Spacer()
            GeometryReader { geometry in
                HStack {
                    Spacer()
                    Button {
                        print("aaa")
                    } label: {
                        Text("削除")
                    }
                    .foregroundColor(.white)
                    .frame(width: (geometry.frame(in: .global).width/2)-20, height: 50)
                    .background(Color.red.opacity(0.8))
                    .cornerRadius(5)
                    
                    Button {
                        print("aaa")
                    } label: {
                        Text("取り消し")
                    }
                    .foregroundColor(.white)
                    .frame(width: (geometry.frame(in: .global).width/2)-20, height: 50)
                    .background(Color.orange.opacity(0.8))
                    .cornerRadius(5)
                    Spacer()
                }
                .offset(y: offset)
            }
            .frame(height: 60)
        }
        .onAppear {
            print("messageListViewInit: \(appState.messageListViewInit)")
            if appState.messageListViewInit {
                viewModel.messageList = []
                viewModel.matchingPairIDs = pairModel.chatPairIDs
                viewModel.fetch()
                appState.messageListViewInit = false
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing){
                Button {
                    withAnimation {
                        deleteScreen.toggle()
                        if deleteScreen {
                            offset = 0
                        } else {
                            offset = 200
                        }
                    }
                } label: {
                    Image(systemName: "trash")
                    
                }
                .foregroundColor(.black)
            }
        }
        .navigationBarTitle("メッセージルーム")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SendGoodsListView_Previews: PreviewProvider {
    static var previews: some View {
        MessageListView()
    }
}
