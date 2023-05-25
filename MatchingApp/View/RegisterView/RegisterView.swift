//
//  RegisterView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/01.
//

import SwiftUI
import AuthenticationServices

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    Text("アプリのロゴ")
                        .fontWeight(.heavy)
                        .font(.system(size: 30))
                        .padding(.top, 16)
                    
                    TextField("", text: $viewModel.email , prompt: Text("メールアドレス"))
                        .padding(.leading, 10)
                        .frame(height: 38)
                        .overlay(RoundedRectangle(cornerRadius: 3)
                            .stroke(Color.customLightGray, lineWidth: 2))
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                    
                    SecureField("", text: $viewModel.password , prompt: Text("パスワード"))
                        .padding(.leading, 10)
                        .frame(height: 38)
                        .overlay(RoundedRectangle(cornerRadius: 3)
                            .stroke(Color.customLightGray, lineWidth: 2))
                        
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                    
                    NavigationLink {
                        
                    } label: {
                        Text("パスワードを忘れた方")
                            .fontWeight(.heavy)
                            .font(.system(size: 13))
                            .foregroundColor(.customBlue)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing, 16)
                            .padding(.vertical, 8)
                    }
                    
                    
                    Button {
                        Task {
                            
                        }
                    } label: {
                        Text("新規アカウント作成")
                            .foregroundColor(.white)
                            .font(.system(size: 17))
                            .bold()
                            .frame(width: UIScreen.main.bounds.width-40, height: 50)
                            .background(Color.customBlack)
                            .cornerRadius(32)
                            .padding(.top, 8)
                            .padding(.horizontal,16)
                    }
                    
                    HStack {
                        VStack {
                            Divider()
                        }
                        Text("または")
                            .foregroundColor(.gray)
                            .font(.system(size: 17))
                            .bold()
                            .padding(.vertical, 16)
                        VStack {
                            Divider()
                        }
                    }
                    .padding(.horizontal, 8)
                    Button {
                        Task {
                            
                        }
                    } label: {
                        Text("Button")
                    }

                }
            }
            Spacer()
            Button {
                dismiss()
            } label: {
                HStack(spacing: .zero){
                    Image(systemName: "person")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.black)
                    Text("既にアカウントをお持ちの方は")
                        .foregroundColor(.black)
                        .font(.system(size: 16))
                        .padding(.leading, 8)
                    Text("こちらから")
                        .foregroundColor(.blue.opacity(0.8))
                        .font(.system(size: 16))
                }
            }
            .frame(width: UIScreen.main.bounds.width, height: 60)
            .background(.ultraThinMaterial)
        }
        .interactiveDismissDisabled()
        .navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $viewModel.modal) {
            EmailConfirmationView(viewModel: viewModel)
        }
    }
}

struct RegisterView_Preview: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
