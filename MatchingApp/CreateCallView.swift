//
//  SettingCallTopicView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/03.
//

import SwiftUI
import SDWebImageSwiftUI

struct CreateCallView: View {
    @Environment(\.dismiss) var dismiss
    @FocusState var focus: Bool
    @StateObject var viewModel = CreateCallViewModel()
    @Binding var channelTitle: String
    @Binding var isActive: Bool
    let userModel: UserObservableModel
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading){
                    Text("何について話す？")
                        .foregroundColor(.customBlack)
                        .font(.system(size: 24, weight: .bold))
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 32)
                    Text("オープン通話")
                        .foregroundColor(.pink)
                        .font(.system(size: 12))
                        .padding(.top, 2)
                }
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width-32)
            
            HStack {
                
                Image(userModel.user.profileImageURLString)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 42, height: 42)
                    .padding(.all, 4)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(Circle())
                
                VStack(spacing: .zero){
                    TextField("トピック入力", text: $channelTitle)
                        .frame(height: 50)
                        .font(.system(size: 16))
                        .foregroundColor(.customBlack)
                        .focused($focus)
                    RoundedRectangle(cornerRadius: 20)
                        .frame(height: 2)
                        .foregroundColor(.pink)
                }
                .padding(.leading, 4)
            }
            .frame(width: UIScreen.main.bounds.width-32)
            
            VStack {
                HStack {
                    Text("会話タグ")
                        .foregroundColor(.customBlack)
                        .font(.system(size: 24, weight: .bold))
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 32)
                    Spacer()
                }
                
                ScrollView {
                    VStack {
                        GeometryReader { geometry in
                            TagViewGenerator.generateEditTags(allTags: TagNames.callTags, selectedTags: $viewModel.channelTags, geometry)
                        }
                        .padding()
                    }
                }
            }
            .frame(maxWidth: UIScreen.main.bounds.width)
            
            Spacer()
            Button {
                if !userModel.user.isCallingChannelId.isEmpty {
                    viewModel.errorMessage = "現在、他の通話に参加中です"
                    viewModel.isErrorAlert = true
                    return
                }
                self.focus = false
                dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                    self.isActive = true
                }
            } label: {
                Text("通話を始める")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .bold))
                    .frame(width: UIScreen.main.bounds.width-32, height: 50)
                    .background(channelTitle.isEmpty ? Color.gray.opacity(0.3): Color.customRed)
                    .disabled(channelTitle.isEmpty)
                    .cornerRadius(25)
                    .padding(.bottom, 8)
            }
            .disabled(channelTitle.isEmpty)
        }
        .padding(.horizontal, 16)
        .alert(isPresented: $viewModel.isErrorAlert) {
            Alert(
                title: Text("エラー"),
                message: Text(viewModel.errorMessage)
            )
        }
    }
}
