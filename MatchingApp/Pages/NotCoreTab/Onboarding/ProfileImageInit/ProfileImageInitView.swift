//
//  ProfileImageInitView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/09/12.
//

import SwiftUI

struct ProfileImageInitView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var userModel: UserObservableModel
    @StateObject var viewModel = ProfileImageInitViewModel()
    @Binding var presentationMode: PresentationMode
    @Environment(\.dismiss) var dismiss
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("🦜 アイコンを\n 選択してください")
                .font(.system(size: 25))
                .fontWeight(.bold)
                .foregroundColor(Color.customBlack)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 16)
                .padding(.leading, 16)
            VStack {
                Image(userModel.user.profileImageURLString)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 128, height: 128)
                    .padding(.all, 16)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(Circle())
                    .padding(.top, 16)
                
                ScrollView {
                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 4), spacing: 16) {
                        ForEach(ProfileImages.profileImages, id: \.self) { image in
                            Image(image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 56, height: 56)
                                .padding(.all, 8)
                                .background(Color.gray.opacity(0.1))
                                .clipShape(Circle())
                                .onTapGesture {
                                    UIIFGeneratorMedium.impactOccurred()
                                    userModel.user.profileImageURLString = image
                                }
                        }
                    }
                    .padding(16)
                }
                .padding(.top, 24)
                
                Button {
                    viewModel.completeRegister(
                        userModel: userModel,
                        appState: appState) {
                            presentationMode.dismiss()
                        }
                } label: {
                    Text("アカウントを作成する")
                        .foregroundColor(!userModel.user.profileImageURLString.isEmpty ? .white: .customBlack)
                        .frame(width: UIScreen.main.bounds.width-32, height: 56)
                        .background(!userModel.user.profileImageURLString.isEmpty ? Color.customBlue: Color.customLightGray)
                        .font(.system(size: 16,weight: .bold))
                        .cornerRadius(10)
                        .padding(.top, 56)
                }
                .disabled(userModel.user.profileImageURLString.isEmpty)
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal){
                VStack(spacing: 4){
                    Text("アイコン選択")
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                        .foregroundColor(Color.customBlack)
                }
            }
        }
    }
}

