//
//  ProfileChangeView.swift
//  Merci
//
//  Created by Rio Nagasaki on 2023/09/17.
//

import SwiftUI

struct ProfileChangeView: View {
    @EnvironmentObject var userModel: UserObservableModel
    @StateObject var viewModel = ProfileChangeViewModel()
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
            ScrollView {
                VStack {
                    Button {
                        UIIFGeneratorMedium.impactOccurred()
                        viewModel.isSelectedPicture = true
                    } label: {
                        Image(userModel.user.profileImageURLString)
                            .resizable()
                            .frame(width: 120, height: 120)
                            .padding(.all, 16)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(Circle())
                    }
                    
                    NavigationLink {
                        NickNameView()
                    } label: {
                        VStack(spacing: .zero){
                            HStack {
                                Text("ニックネーム")
                                    .padding(.vertical, 8)
                                    .foregroundColor(.customBlack)
                                    .font(.system(size: 20, weight: .bold))
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            HStack {
                                Text(userModel.user.nickname.replacingOccurrences(of: "\n", with: " "))
                                    .foregroundColor(.customBlack)
                                    .multilineTextAlignment(.leading)
                                    .font(.system(size: 18))
                                    .padding(.horizontal, 18)
                                Spacer()
                            }
                        }
                    }
                    NavigationLink {
                        UserIntroductionEditorView()
                    } label: {
                        VStack(alignment: .leading, spacing: .zero) {
                            HStack {
                                Text("ひとこと")
                                    .foregroundColor(.customBlack)
                                    .font(.system(size: 20))
                                    .bold()
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            
                            if userModel.user.introduction.isEmpty {
                                Text("未設定")
                                    .foregroundColor(.gray.opacity(0.8))
                                    .fontWeight(.light)
                                    .font(.system(size: 18))
                                    .padding(.horizontal, 18)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            } else {
                                Text(userModel.user.introduction.replacingOccurrences(of: "\n", with: " "))
                                    .foregroundColor(.customBlack)
                                    .padding(.horizontal, 18)
                                    .multilineTextAlignment(.leading)
                                    .font(.system(size: 18))
                            }
                        }
                    }
                    NavigationLink {
                        UserHobbiesEditorView()
                    } label: {
                        VStack(spacing: .zero) {
                            Text("すきなこと")
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.customBlack)
                                .font(.system(size: 20, weight: .bold))
                            
                            HStack {
                                TagViewGenerator.generateTags(UIScreen.main.bounds.width-32, tags: userModel.user.hobbies)
                                Spacer()
                            }
                        }
                        .padding(.leading, 16)
                        .padding(.bottom, 16)
                    }
                }
            }
        .fullScreenCover(isPresented: $viewModel.isSelectedPicture) {
            ProfileImageChangeView()
        }
    }
}

struct ProfileChangeView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileChangeView()
    }
}
