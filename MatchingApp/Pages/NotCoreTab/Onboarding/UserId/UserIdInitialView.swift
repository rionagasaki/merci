//
//  UserIdInitialView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/04.
//

import SwiftUI

struct UserIdInitialView: View {
    @StateObject var viewModel = UserIdInitialViewModel()
    @EnvironmentObject var userModel: UserObservableModel
    @FocusState var focus: Bool
    var isEnabled: Bool  {
        return userModel.user.niniId != ""
    }
    var body: some View {
        VStack {
            VStack(alignment: .leading){
                Text("NiNi ID\nを入力してください")
                    .foregroundColor(.customBlack)
                    .fontWeight(.bold)
                    .font(.system(size: 25))
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                
                VStack(alignment: .leading, spacing: .zero){
                    TextField(text: $userModel.user.niniId) {
                        Text("入力してください")
                    }
                    .foregroundColor(.customBlack)
                    .font(.system(size: 25))
                    .focused($focus)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 4)
                    .cornerRadius(10)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .onTapGesture {
                        focus = true
                    }
                    
                    Rectangle()
                        .foregroundColor(.gray.opacity(0.3))
                        .frame(height: 2)
                        .padding(.horizontal, 16)
                        .padding(.top, -8)
                }
                VStack(alignment: .leading){
                    Text("※")
                    Text("※ニックネームはあとから変更できます。")
                }
                .foregroundColor(.gray)
                .padding(.horizontal, 16)
                .font(.system(size: 13))
            }
            Spacer()
        }
        
    }
}

struct UserIdInitialView_Previews: PreviewProvider {
    static var previews: some View {
        UserIdInitialView()
    }
}
