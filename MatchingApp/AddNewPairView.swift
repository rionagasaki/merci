//
//  AddNewPairView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/05.
//

import SwiftUI

struct AddNewPairView: View {
    @StateObject var viewModel = AddNewPairViewModel()
    var body: some View {
        VStack {
            Text("ペアになりたい友達のUserIDを入力してください")
                .foregroundColor(.black)
                .fontWeight(.light)
                .padding(.horizontal, 16)
            TextField("userID", text: $viewModel.searchedUserId)
            
                .frame(height: 60)
                .padding(.horizontal, 16)
                .background(.gray.opacity(0.2))
                .cornerRadius(20)
                .padding(.horizontal, 16)
            
            
            Button {
                print("aaa")
            } label: {
                Text("検索する")
                    .foregroundColor(.black.opacity(0.8))
            }
            .padding(.top, 16)
            
            Spacer()
        }
        .padding(.top, 16)
    }
}

struct AddNewPairView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewPairView()
    }
}
