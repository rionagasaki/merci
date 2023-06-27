//
//  UserProfileView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/26.
//

import SwiftUI
import SDWebImageSwiftUI
import AlertToast

struct UserProfileView: View {
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .medium)
    @StateObject var viewModel = UserProfileViewModel()
    @EnvironmentObject var userModel: UserObservableModel
    @Environment(\.dismiss) var dismiss
    @State private var showToast = false
    let user: UserObservableModel
    
    var body: some View {
        VStack{
            ScrollView {
                VStack {
                    WebImage(url: URL(string: user.profileImageURL))
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width-30, height:UIScreen.main.bounds.width-30)
                        .cornerRadius(10)
                        .padding(.top, 32)
                    
                    if let age = CalculateAge().calculateAge(from: user.birthDate) {
                        HStack {
                            VStack(alignment: .leading, spacing: .zero){
                                Text(user.nickname)
                                    .foregroundColor(.black)
                                    .font(.system(size: 25))
                                    .fontWeight(.bold)
                                    .padding(.top, 8)
                                    .padding(.leading, 16)
                                Text("\(age)歳・\(user.activeRegion)")
                                    .foregroundColor(.customBlack.opacity(0.8))
                                    .font(.system(size: 13))
                                    .fontWeight(.bold)
                                    .padding(.vertical, 2)
                                    .padding(.leading, 16)
                            }
                            Spacer()
                        }
                        .padding(.top, 8)
                    }
                    VStack(spacing: .zero){
                        Text("自己紹介")
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.customBlack)
                            .font(.system(size: 18, weight: .bold))
                            
                        HStack {
                            Text(user.introduction)
                                .foregroundColor(.customBlack)
                                .font(.system(size: 16))
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 32)
                    VStack(spacing: .zero){
                        Text("興味")
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.customBlack)
                            .font(.system(size: 18, weight: .bold))
                            
                        HStack {
                            GenerateTags.generateTags(UIScreen.main.bounds.width-32, tags: user.hobbies)
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 32)
                    
                    VStack {
                        Text("プロフィール")
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.customBlack)
                            .font(.system(size: 18, weight: .bold))
                        
                        ForEach(DetailProfile.allCases) { detailProfile in
                            DetailProfileCellView(user: user, selectedDetailProfile: detailProfile)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 32)
                }
            }
            if userModel.friendUids.contains(user.uid){
                
            } else {
                Button {
                    viewModel.pairRequest(currentUserID: userModel.uid, userID: user.uid)
                    UIIFGeneratorMedium.impactOccurred()
                    showToast = true
                } label: {
                    Text("フレンド申請")
                        .foregroundColor(.white)
                        .bold()
                        .frame(width: UIScreen.main.bounds.width-32, height: 50)
                        .background(Color.pink.opacity(0.7))
                        .cornerRadius(10)
                }
            }
        }
        .navigationBarBackButtonHidden()
        .toast(isPresenting: $showToast, duration: 1) {
            AlertToast(type: .regular, title: "リクエストを送りました！")
        } completion: {
            dismiss()
        }
        .navigationTitle("\(user.nickname)のプロフ")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
            }
        }
    }
}
