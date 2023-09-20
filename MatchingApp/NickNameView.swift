//
//  NickNameView.swift
//  Merci
//
//  Created by Rio Nagasaki on 2023/09/17.
//

import SwiftUI

struct NickNameView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var userModel: UserObservableModel
    @State var isEnabled: Bool = false
    @Environment(\.dismiss) var dismiss
    @FocusState var focus: Bool
    @StateObject var viewModel = NickNameViewModel()
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .medium)
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: .zero){
                    TextField(text: $viewModel.nickname) {
                        Text(userModel.user.nickname)
                    }
                    .foregroundColor(.customBlack)
                    .font(.system(size: 25))
                    .focused($focus)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 4)
                    .cornerRadius(10)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .onChange(of: viewModel.nickname) { newValue in
                        if newValue.count > 20 {
                            viewModel.nickname = String(newValue.prefix(20))
                        }
                        if newValue != "" {
                            isEnabled = true
                        } else {
                            isEnabled = false
                        }
                    }
                    .onTapGesture {
                        focus = true
                    }
                    Rectangle()
                        .foregroundColor(.gray.opacity(0.3))
                        .frame(height: 2)
                        .padding(.horizontal, 16)
                        .padding(.top, -8)
                }
            }
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("自己紹介")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(
                    action: {
                        focus = false
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                            dismiss()
                        }
                    }, label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                    }
                )
            }
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Text("\(viewModel.nickname.count)/20")
                        .foregroundColor(.customBlack.opacity(0.8))
                        .font(.system(size: 14))
                    Spacer()
                    Button {
                        viewModel.storeUserNickname(uid: userModel.user.uid)
                    } label: {
                        Text("保存する")
                            .foregroundColor(.white)
                            .bold()
                            .font(.system(size: 14))
                            .padding(.all, 8)
                            .background(Color.pink.opacity(0.8))
                            .cornerRadius(10)
                    }
                }
            }
        }
        .onAppear {
            focus = true
        }
    }
}


