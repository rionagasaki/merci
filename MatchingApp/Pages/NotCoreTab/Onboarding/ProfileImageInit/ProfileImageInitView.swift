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
    @Binding var presentationMode: PresentationMode
    @Environment(\.dismiss) var dismiss
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        VStack(alignment: .leading) {
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
                
                NavigationLink {
                    HobbiesInitView(
                        presentationMode: $presentationMode
                    )
                } label: {
                    Text("次へ")
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width-32, height: 56)
                        .background(!userModel.user.profileImageURLString.isEmpty ? Color.customBlue: .gray.opacity(0.4))
                        .font(.system(size: 16,weight: .bold))
                        .cornerRadius(10)
                        .padding(.top, 56)
                }
                .disabled(userModel.user.profileImageURLString.isEmpty)
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading){
                VStack(spacing: 4){
                    Text("プロフィール画像の選択")
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

