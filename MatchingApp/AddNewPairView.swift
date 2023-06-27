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
    @FocusState var focus:Bool
    var body: some View {
        VStack(alignment: .leading){
            Text("IDを入力🚗")
                .foregroundColor(.black)
                .font(.system(size: 32, weight: .bold))
            
            TextField("userID", text: $viewModel.searchedUserId)
                .frame(height: 60)
                .padding(.horizontal, 16)
                .background(.gray.opacity(0.1))
                .cornerRadius(10)
                .focused($focus)
            
            if viewModel.noResult {
                Text("指定されたユーザーは存在しません。ご確認の上、もう一度入力してください。")
                    .foregroundColor(.red)
                    .font(.system(size: 16))
                    .fontWeight(.light)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
            }
            Spacer()
        }
        .padding(.top, 16)
        .padding(.horizontal, 16)
        .fullScreenCover(isPresented: $viewModel.isModal) {
            UserProfileView(user: viewModel.user)
        }
        
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
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button {
                    viewModel.pairSearch()
                } label: {
                    Text("検索する")
                        .foregroundColor(.white)
                        .font(.system(size: 22, weight: .bold))
                        .frame(width: UIScreen.main.bounds.width, height: 60)
                        .background(Color.pink.opacity(0.7))
                        .padding(.bottom, 16)
                }
            }
        }
    }
}

struct AddNewPairView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewPairView()
    }
}
