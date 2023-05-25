//
//  BirthDateView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct BirthDateView: View {
    @StateObject var viewModel: UserObservableModel
    @Environment(\.dismiss) var dismiss
    @Binding var presentationMode: PresentationMode
    
    var body: some View {
        VStack(alignment: .leading){
            ScrollView {
                Text("生年月日を\n入力してください")
                    .font(.system(size: 25))
                    .fontWeight(.bold)
                    .foregroundColor(Color.customBlack)
                    .padding(.top, 16)
                    .padding(.leading, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TextField(text: $viewModel.birthDate) {
                    Text("2000/01/31")
                }
                .foregroundColor(.customBlack)
                .font(.system(size: 25))
                .padding(.vertical, 16)
                .padding(.horizontal, 4)
                .cornerRadius(10)
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .keyboardType(.numberPad)
                .onChange(of: viewModel.birthDate) { text in
                    
                }
                
                Rectangle()
                    .foregroundColor(.gray.opacity(0.3))
                    .frame(height: 2)
                    .padding(.horizontal, 16)
                    .padding(.top, -8)
                    
                VStack(alignment: .leading){
                    Text("※誤った生年月日を入力されますと、メッセージのやり取り等に制限が生まれる場合がございますので、ご注意ください")
                    Text("※生年月日の編集は登録時のみ可能です。一度登録された生年月日は変更できませんので、あらかじめご了承ください")
                }
                .foregroundColor(.gray)
                .padding(.horizontal, 16)
                .font(.system(size: 13))
            }
            Spacer()
            Button {
                SetToFirestore.shared.registerUserInfoFirestore(uid: Authentication().currentUid, nickname: viewModel.nickname, email: Authentication().userEmail, gender: viewModel.gender, activityRegion: viewModel.activeRegion, birthDate: "aa") {
                    presentationMode.dismiss()
                }
            } label: {
                Text("決定する")
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width-60, height: 60)
                    .background(Color.customBlack)
            }
            .frame(maxWidth: .infinity, alignment: .center)

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
