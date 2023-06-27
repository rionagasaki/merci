//
//  MyMainInfoView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/04.
//

import SwiftUI
import SDWebImageSwiftUI

struct MyMainInfoView: View {
    
    @State var pictureSelectedViewVisible: Bool = false
    @ObservedObject  var messageAlert = MessageBalloon()
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
                    WebImage(url: URL(string: userModel.profileImageURL))
                        .resizable()
                        .frame(width: 150, height: 150)
                        .cornerRadius(10)
                }
                .fullScreenCover(isPresented: $pictureSelectedViewVisible) {
                    ChangeImageView()
                }
                
                VStack(alignment: .center){
                    VStack {
                        Text(userModel.nickname)
                            .font(.system(size: 16))
                        
                            .bold()
                        if let age = CalculateAge().calculateAge(from: userModel.birthDate) {
                            Text("\(age)歳・\(userModel.activeRegion)")
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
                                Text(userModel.uid)
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
                                    UIPasteboard.general.string = userModel.uid
                                    messageAlert.isPreview = true
                                    messageAlert.vanishMessage()
                                } label: {
                                    Image(systemName: "square.on.square")
                                        .resizable()
                                        .frame(width: 20, height:20)
                                        .foregroundColor(.gray.opacity(0.8))
                                }
                                .padding()
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
                                Text("\(userModel.coins)")
                                    .font(.system(size: 16, weight: .light))
                                    .lineLimit(1)
                            }
                        }
                    }
                    NavigationLink {
                        PurchaseCardsView()
                            .onAppear {
                                UIIFGeneratorMedium.impactOccurred()
                            }
                    } label: {
                        Image("PurchaseBanner")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width-32)
                            .cornerRadius(20)
                    }
                }
            }
            CustomDivider()
        }
        .padding(.top, 16)
    }
}


