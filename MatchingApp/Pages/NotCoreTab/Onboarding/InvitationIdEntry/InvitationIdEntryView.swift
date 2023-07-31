//
//  PairAddInitView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/26.
//

import SwiftUI
    
struct InvitationIdEntryView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var presentationMode: PresentationMode
    @EnvironmentObject var userModel: UserObservableModel
    @FocusState var focus: Bool
    
    var body: some View {
        VStack {
            Text("アプリに招待されていれば\nそのユーザーのNiNi IDを入力してください。")
                .font(.system(size: 25))
                .fontWeight(.bold)
                .foregroundColor(Color.customBlack)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 16)
                .padding(.leading, 16)
            
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
            Button {
                
            } label: {
                Text("NiNiを始める")
                    .foregroundColor(.white)
                    .bold()
                    .frame(width: UIScreen.main.bounds.width-32, height: 50)
                    .background(Color.pink)
                    .cornerRadius(10)
            }
        }
        .navigationBarBackButtonHidden()
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

