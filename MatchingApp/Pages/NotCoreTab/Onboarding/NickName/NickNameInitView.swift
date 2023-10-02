//
//  NickNameView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/22.
//

import SwiftUI

struct NickNameInitView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var userModel: UserObservableModel
    @State var isEnabled: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @FocusState var focus: Bool
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .medium)
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading){
                    Text("🐧 ニックネームを\n 入力してください")
                        .foregroundColor(.customBlack)
                        .fontWeight(.bold)
                        .font(.system(size: 24))
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                    
                    VStack(alignment: .leading, spacing: .zero){
                        TextField(text: $userModel.user.nickname) {
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
                        .onChange(of: userModel.user.nickname) { newValue in
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
            .navigationTitle("ニックネーム")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                focus = true
                if let user = AuthenticationManager.shared.user {
                    userModel.user.uid = user.uid
                    userModel.user.email = user.email ?? ""
                }
            }
            .toolbar {
                ToolbarItem(placement: .keyboard){
                    if isEnabled {
                        NavigationLink{
                            GenderView(presentationMode: presentationMode)
                                .onAppear{
                                    UIIFGeneratorMedium.impactOccurred()
                                }
                        } label: {
                            Text("次へ")
                                .foregroundColor(.white)
                                .font(.system(size: 22, weight: .bold))
                                .frame(width: UIScreen.main.bounds.width, height: 60)
                                .background(Color.customBlue)
                                .padding(.bottom, 16)
                        }
                    } else {
                        Text("次へ")
                            .foregroundColor(.customBlack)
                            .font(.system(size: 22, weight: .bold))
                            .frame(width: UIScreen.main.bounds.width, height: 60)
                            .background(Color.customLightGray)
                            .padding(.bottom, 16)
                    }
                }
            }
        }
        .tint(.customBlack)
    }
}

