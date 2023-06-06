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
    
    var body: some View {
        VStack {
            HStack {
                ZStack(alignment: .bottomTrailing) {
                    WebImage(url: URL(string: userModel.profileImageURL))
                        .resizable()
                        .frame(width: 140, height: 140)
                        .cornerRadius(10)
                    
                    Button {
                        self.pictureSelectedViewVisible = true
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .padding(.all, 12)
                            .foregroundColor(.white)
                            .background(Color.black)
                            .frame(width: 48, height: 48)
                            .overlay(content: {
                                Circle().stroke(lineWidth: 4).foregroundColor(.white)
                            })
                            .clipShape(Circle())
                    }
                    .sheet(isPresented: $pictureSelectedViewVisible) {
                        ChangeImageView()
                    }
                }
                .padding(.leading, 16)
               
                VStack(alignment: .leading){
                    HStack {
                        Text(userModel.nickname)
                            .font(.system(size: 16))
                            .bold()
                        if let age = CalculateAge().calculateAge(from: userModel.birthDate) {
                            Text("\(age)歳")
                        }
                        
                    }
                    VStack(alignment: .leading,spacing: .zero){
                        Text("ユーザ-ID")
                            .foregroundColor(.gray.opacity(0.6))
                            .font(.system(size: 13))
                            .fontWeight(.light)
                        HStack {
                            Text(userModel.uid)
                                .frame(maxWidth: 100)
                                .font(.system(size: 16))
                                .fontWeight(.light)
                                .lineLimit(1)
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
                    }
                }
                .padding(.leading, 16)
            }
            CustomDivider()
        }
        .padding(.top, 16)
    }
}


