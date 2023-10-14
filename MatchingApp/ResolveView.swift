//
//  ResolveView.swift
//  Merci
//
//  Created by Rio Nagasaki on 2023/10/07.
//

import SwiftUI

struct ResolveView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userModel: UserObservableModel
    let concern: ConcernObservableModel
    @StateObject var viewModel = ResolveViewModel()
    @FocusState var focus: Bool
    var body: some View {
        NavigationStack {
            VStack {
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
                ScrollView {
                    Text(concern.concernText)
                        .foregroundColor(.customBlack)
                        .font(.system(size: 16, weight: .regular))
                        .padding(.top, 8)
                        .padding(.horizontal, 16)
                }
                .frame(maxHeight: 80)
                
                HStack {
                    Text("メッセージ")
                        .foregroundColor(.customBlack)
                        .font(.system(size: 20, weight: .medium))
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                
                VStack(alignment: .leading) {
                    Spacer()
                    TextEditor(text: $viewModel.resolveText)
                    .padding(.all, 16)
                    .focused(self.$focus)
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width-48)
                .background(Color.customRed.opacity(0.2))
                .cornerRadius(20)
                .padding(.bottom, 16)
                Spacer()
            }
            .onAppear {
                self.focus = true
                Task {
                    await viewModel.getUserData(userID: concern.posterUid)
                }
            }
            .onDisappear {
                self.focus = false
            }
            .onReceive(viewModel.$isSuccessfullyAddReply){
                if $0 {
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.4){
                        dismiss()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal){
                    Text(concern.posterNickname)
                        .foregroundColor(.customBlack)
                        .font(.system(size: 16, weight: .medium))
                }
                
                ToolbarItem(placement: .navigationBarTrailing){
                    Button {
                        self.focus = false
                    } label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 16, height: 16)
                            .foregroundColor(.customBlack)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing){
                    Button {
                        Task {
                            await viewModel.addResolveChat(
                                fromUser: userModel,
                                concernID:concern.id.debugDescription,
                                concernKind: concern.concernKind,
                                concernText: concern.concernText,
                                concernKindImageName: concern.concernKindImageName
                            )
                        }
                    } label: {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView()
                            }
                            Text("返信する")
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .medium))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .disabled(viewModel.resolveText.isEmpty)
                                .background(viewModel.resolveText.isEmpty || viewModel.isLoading ? Color.gray.opacity(0.3): Color.customRed)
                                .cornerRadius(25)
                        }
                    }
                    .disabled(viewModel.resolveText.isEmpty || viewModel.isLoading)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
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
