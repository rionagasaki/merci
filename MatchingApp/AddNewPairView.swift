//
//  AddNewPairView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/05.
//

import SwiftUI

struct AddNewPairView: View {
    @StateObject var viewModel = AddNewPairViewModel()
    
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ScrollView {
            VStack{
                Text("ペアになりたい友達のUserIDを入力してください")
                    .foregroundColor(.black)
                    .fontWeight(.light)
                    .padding(.horizontal, 16)
                TextField("userID", text: $viewModel.searchedUserId)
                    .frame(height: 60)
                    .padding(.horizontal, 16)
                    .background(.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal, 16)
                
                if viewModel.noResult {
                    Text("指定されたユーザーは存在しません。ご確認の上、もう一度入力してください。")
                        .foregroundColor(.red)
                        .font(.system(size: 16))
                        .fontWeight(.light)
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                }
                Button {
                    if viewModel.searchedUserId != "" {
                        viewModel.pairSearch()
                    }
                } label: {
                    Text("検索する")
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width-32, height: 60)
                        .background(Color.customGreen)
                        .cornerRadius(10)
                }
                .padding(.top, 16)
                
                Spacer()
            }
        }
        .sheet(isPresented: $viewModel.isModal){
            UserProfileView(currentUserID: viewModel.currentUserID, userID: viewModel.userID, nickname: viewModel.nickname, profileImageURL: viewModel.profileImageURL, birthDate: viewModel.birthDate, activeRegion: viewModel.activeRegion)
        }
        .padding(.top, 16)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(
                    action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                    }
                )
            }
        }
    }
}

struct AddNewPairView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewPairView()
    }
}
