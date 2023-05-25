//
//  UserProfileView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/05.
//

import SwiftUI

struct UserProfileView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            ScrollView {
                HStack {
                    HStack(alignment: .top) {
                        Image("Person")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .cornerRadius(15)
                        VStack(alignment: .leading){
                            Text("あや")
                                .font(.system(size: 14))
                            Text("22歳・渋谷")
                                .font(.system(size: 12))
                                .foregroundColor(.gray.opacity(0.8))
                            Spacer()
                        }
                    }
                    Spacer()
                    HStack(alignment: .top) {
                        Image("Person")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .cornerRadius(15)
                        VStack(alignment: .leading){
                            Text("あや")
                                .font(.system(size: 14))
                            Text("22歳・渋谷")
                                .font(.system(size: 12))
                                .foregroundColor(.gray.opacity(0.8))
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
                
                VStack {
                    Image("Person")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width, height: 350)
                        .scaledToFit()
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            Image("Person")
                                .resizable()
                                .frame(width:80, height: 80)
                            
                            Image("Person")
                                .resizable()
                                .frame(width:80, height: 80)
                            
                            Image("Person")
                                .resizable()
                                .frame(width:80, height: 80)
                            
                            Image("Person")
                                .resizable()
                                .frame(width:80, height: 80)
                            Image("Person")
                                .resizable()
                                .frame(width:80, height: 80)
                            
                        }
                    }
                    .padding(.horizontal, 8)
                    
                    HStack {
                        Text("あや")
                        Text("24歳")
                        Text("東京")
                    }
                    .foregroundColor(.black.opacity(0.8))
                    .font(.system(size: 25))
                    .fontWeight(.light)
                    .padding(.vertical, 8)
                    
                    
                    HStack {
                        Image(systemName: "ellipsis.message.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .scaledToFit()
                            .foregroundColor(.gray)
                        Text("真剣な恋愛を探しています！")
                            .fontWeight(.light)
                            .font(.system(size: 14))
                        
                    }
                    VStack {
                        HStack {
                            HStack {
                                Text("身長")
                                    .foregroundColor(.gray)
                                    .fontWeight(.light)
                                Text("161cm")
                                    .foregroundColor(.black)
                            }
                            Spacer()
                            HStack {
                                Text("身長")
                                    .foregroundColor(.gray)
                                    .fontWeight(.light)
                                Text("161cm")
                                    .foregroundColor(.black)
                            }
                            
                        }
                        HStack {
                            HStack {
                                Text("身長")
                                    .foregroundColor(.gray)
                                    .fontWeight(.light)
                                Text("161cm")
                                    .foregroundColor(.black)
                            }
                            Spacer()
                            HStack {
                                Text("同居人")
                                    .foregroundColor(.gray)
                                    .fontWeight(.light)
                                Text("161cm")
                                    .foregroundColor(.black)
                            }
                            
                        }
                    }
                    .padding(.horizontal, 16)
                    CustomDivider()
                    Text("")
                    Text("")
                    
                    Spacer()
                }
                
            }
            HStack {
                GeometryReader { geometry in
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            DismissButtonView()
                        }
                        .padding(.leading, 16)
                        Spacer()
                        Button {
                            print("aaa")
                        } label: {
                            Text("さそってみる")
                                .frame(width: geometry.frame(in: .global).width - 90, height: 60)
                                .background(Color.customGreen)
                                .foregroundColor(.white)
                                .bold()
                                .font(.system(size: 16))
                                .cornerRadius(10)
                        }
                        .padding(.trailing, 16)
                    }
                    .padding(.top, 16)
                }
                .background(.ultraThinMaterial)
                .frame(height: 70)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("相手のプロフィール")
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}
