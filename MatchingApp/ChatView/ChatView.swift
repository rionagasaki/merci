//
//  ChatView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/01.
//

import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                TextField(text: $viewModel.text) {
                    Text("メッセージ")
                }
                .padding(.leading, 16)
                .background{
                    RoundedRectangle(cornerRadius: 20)
                        .frame(height: 40)
                        .foregroundColor(.gray.opacity(0.2))
                }
                Button {
                    if viewModel.trigger == nil {
                        viewModel.trigger = true
                    } else {
                        viewModel.trigger?.toggle()
                    }
                } label: {
                    Image(systemName: "arrowtriangle.right.fill").resizable()
                        .foregroundColor(.blue.opacity(0.8))
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                .task(id: viewModel.trigger) {
                    guard viewModel.trigger != nil else { return }
                    await viewModel.tappedSendButton()
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
