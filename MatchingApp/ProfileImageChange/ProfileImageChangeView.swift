//
//  ChangeImageView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/01.
//

import SwiftUI
import Combine

struct ProfileImageChangeView: View {
    @StateObject var viewModel = ProfileImageChangeViewModel()
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var userModel: UserObservableModel
    
    @Environment(\.dismiss) var dismiss
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                VStack {
                    Image(viewModel.selectedImage.isEmpty ? userModel.user.profileImageURLString: viewModel.selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 128, height: 128)
                        .padding(.all, 16)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Circle())
                        .padding(.top, 16)
                    
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 4), spacing: 16) {
                            ForEach(ProfileImages.profileImages.shuffled(), id: \.self) { image in
                                Image(image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 56, height: 56)
                                    .padding(.all, 8)
                                    .background(Color.gray.opacity(0.1))
                                    .clipShape(Circle())
                                    .onTapGesture {
                                        UIIFGeneratorMedium.impactOccurred()
                                        viewModel.selectedImage = image
                                    }
                            }
                        }
                        .padding(16)
                    }
                    .padding(.top, 24)
                    
                    Button {
                        UIIFGeneratorMedium.impactOccurred()
                        self.viewModel.updateUserProfileImage(userModel: userModel)
                    } label: {
                        Text("登録する")
                            .foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width-32, height: 50)
                            .background(viewModel.registerButtonEnabled ? Color.customBlue.opacity(0.8): .gray.opacity(0.4))
                            .font(.system(size: 16,weight: .bold))
                            .cornerRadius(10)
                            .padding(.top, 56)
                    }
                    .disabled(!viewModel.registerButtonEnabled)
                    
                    Button {
                        dismiss()
                    } label: {
                        Text("キャンセル")
                            .foregroundColor(.customBlue.opacity(0.8))
                            .frame(width: UIScreen.main.bounds.width-32, height: 50)
                            .background(.white)
                            .font(.system(size: 16,weight: .bold))
                            .cornerRadius(10)
                            .padding(.top, 8)
                    }
                }
            }
            .navigationBarBackButtonHidden()
            .onReceive(viewModel.$isSuccessImageUpdate) { if $0 { dismiss() } }
            .alert(isPresented: $viewModel.isErrorAlert){
                Alert(title: Text("エラー"), message: Text(viewModel.errorMessage))
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                    VStack(spacing: 4){
                        Text("アイコン選択")
                            .font(.system(size: 25))
                            .fontWeight(.bold)
                            .foregroundColor(Color.customBlack)
                            .padding(.top, 16)
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.customBlue.opacity(0.5))
                            .frame(height: 3)
                    }
                }
            }
        }
    }
}

