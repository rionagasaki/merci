//
//  NickNameView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/22.
//

import SwiftUI

struct NickNameView: View {
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
                    Text("ニックネームを\n入力してください")
                        .foregroundColor(.customBlack)
                        .fontWeight(.bold)
                        .font(.system(size: 25))
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                    
                    VStack(alignment: .leading, spacing: .zero){
                        TextField(text: $userModel.nickname) {
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
                        .onChange(of: userModel.nickname) { newValue in
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
                    VStack(alignment: .leading){
                        Text("※本名などあなたを特定できる情報の使用は控えてください。")
                        Text("※ニックネームはあとから変更できます。")
                    }
                    .foregroundColor(.gray)
                    .padding(.horizontal, 16)
                    .font(.system(size: 13))
                }
                Spacer()
            }
            .navigationTitle("ニックネーム")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                focus = true
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
                                .background(Color.pink)
                                .padding(.bottom, 16)
                        }
                    } else {
                        Text("次へ")
                            .foregroundColor(.white)
                            .font(.system(size: 22, weight: .bold))
                            .frame(width: UIScreen.main.bounds.width, height: 60)
                            .background(Color.gray.opacity(0.7))
                            .padding(.bottom, 16)
                    }
                }
            }
        }
    }
}

