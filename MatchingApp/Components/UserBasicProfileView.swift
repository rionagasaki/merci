//
//  MyMainInfoView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/04.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserBasicProfileView: View {
    
    @State var pictureSelectedViewVisible: Bool = false
    @ObservedObject  var messageAlert = VanishAlert()
    @StateObject var userModel: UserObservableModel
    @Environment(\.presentationMode) var presentationMode
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .medium)
    var body: some View {
        VStack {
            VStack {
                Button {
                    UIIFGeneratorMedium.impactOccurred()
                    pictureSelectedViewVisible = true
                } label: {
                    WebImage(url: URL(string: userModel.user.profileImageURL))
                        .resizable()
                        .frame(width: 150, height: 150)
                        .cornerRadius(10)
                }
                .fullScreenCover(isPresented: $pictureSelectedViewVisible) {
                    ProfileImageChangeView()
                }
                
                VStack(alignment: .center){
                    VStack {
                        Text(userModel.user.nickname)
                            .font(.system(size: 16))
                        
                            .bold()
                        if let age = CalculateAge.calculateAge(from: userModel.user.birthDate) {
                            Text("\(age)歳・\(userModel.user.activeRegion)")
                                .foregroundColor(.customBlack.opacity(0.8))
                                .font(.system(size: 13,weight: .bold))
                        }
                    }
                    HStack {
                        HStack {
                            VStack(alignment: .leading,spacing: .zero){
                                Text("ユーザーID")
                                    .foregroundColor(.gray.opacity(0.6))
                                    .font(.system(size: 13))
                                    .fontWeight(.light)
                                Text(userModel.user.uid)
                                    .frame(maxWidth: 100)
                                    .font(.system(size: 16, weight: .light))
                                    .lineLimit(1)
                            }
                            ZStack {
                                if (messageAlert.isPreview){
                                    Text("Copied")
                                        .font(.system(size: 8))
                                        .padding(3)
                                        .background(Color(red: 0.3, green: 0.3 ,blue: 0.3))
                                        .foregroundColor(.white)
                                        .opacity(messageAlert.castOpacity())
                                        .cornerRadius(5)
                                        .offset(x: -5, y: -20)
                                }
                                Button {
                                    UIIFGeneratorMedium.impactOccurred()
                                    UIPasteboard.general.string = userModel.user.uid
                                    messageAlert.isPreview = true
                                    messageAlert.vanishMessage()
                                } label: {
                                    Image(systemName: "square.on.square")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height:20)
                                        .foregroundColor(.gray.opacity(0.8))
                                        .padding(.all, 16)
                                }
                            }
                        }
                        Divider()
                        VStack(spacing: .zero){
                            Text("ポイント")
                                .foregroundColor(.gray.opacity(0.6))
                                .font(.system(size: 13))
                                .fontWeight(.light)
                            HStack(spacing: 4){
                                Image("Coin")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                Text("\(userModel.user.coins)")
                                    .font(.system(size: 16, weight: .light))
                                    .lineLimit(1)
                            }
                        }
                    }
                    NavigationLink {
                        PointPurchaseView()
                            .onAppear {
                                UIIFGeneratorMedium.impactOccurred()
                            }
                    } label: {
                        Image("PurchaseBanner")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width-32)
                            .cornerRadius(10)
                    }
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ProfileHeaderBottom_2()
                        ProfileHeaderBottom_2()
                        ProfileHeaderBottom_2()
                        ProfileHeaderBottom_2()
                    }
                    .padding(.horizontal, 16)
                }
            }
            CustomDivider()
        }
        .padding(.top, 16)
    }
}


