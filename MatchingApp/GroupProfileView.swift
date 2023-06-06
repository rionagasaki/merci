//
//  UserProfileView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/05.
//

import SwiftUI
import SDWebImageSwiftUI

struct GroupProfileView: View {
    @Environment(\.dismiss) var dismiss
    @State var selection = 0
    @Namespace var namespace
    let myPair: PairObservableModel
    let pairModel:PairObservableModel
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    HStack {
                        Button {
                            withAnimation {
                                selection = 0
                            }
                        } label: {
                            SelectUserComponent(nickname: pairModel.pair_1_nickname, profileImageURL: pairModel.pair_1_profileImageURL, activeRegion: pairModel.pair_1_activeRegion, birthDate: pairModel.pair_1_birthDate,selection: selection, selfNum: 0, namespace: namespace)
                        }
                        .padding(.leading, 8)
                        Spacer()
                        Button {
                            withAnimation {
                                selection = 1
                            }
                        } label: {
                            SelectUserComponent(nickname: pairModel.pair_2_nickname, profileImageURL: pairModel.pair_2_profileImageURL, activeRegion: pairModel.pair_2_activeRegion, birthDate: pairModel.pair_2_birthDate,selection: selection, selfNum: 1, namespace: namespace)
                        }
                        .padding(.trailing, 16)
                    }
                    
                    ZStack(alignment: selection == 0 ? .leading: .trailing) {
                        Rectangle()
                            .foregroundColor(.gray.opacity(0.8))
                            .frame(width: UIScreen.main.bounds.width, height: 2)
                        Rectangle()
                            .foregroundColor(.customGreen)
                            .frame(width: (UIScreen.main.bounds.width/2), height: 2)
                            
                    }
                }
                .padding(.bottom, 8)
                
                TabView(selection: $selection){
                    ForEach(0..<2) { index in
                        if index == 0 {
                            EasyUserProfileView(nickname: pairModel.pair_1_nickname, profileImageURL: pairModel.pair_1_profileImageURL, activeRegion: pairModel.pair_1_activeRegion, birthDate: pairModel.pair_1_birthDate)
                        } else {
                            EasyUserProfileView(nickname: pairModel.pair_2_nickname, profileImageURL: pairModel.pair_2_profileImageURL, activeRegion: pairModel.pair_2_activeRegion, birthDate: pairModel.pair_2_birthDate)
                        }
                    }
                }
                .frame(height: UIScreen.main.bounds.height)
                .tabViewStyle(PageTabViewStyle())
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
                        NavigationLink {
                            ChatView(pair: pairModel)
                        } label: {
                            Text("メッセージを送る")
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
        .onAppear {
            print("myPair   \(myPair.id)")
            print("pairModel    \(pairModel.id)")
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("相手のプロフィール")
    }
}


struct EasyUserProfileView: View {
    let nickname: String
    let profileImageURL: String
    let activeRegion: String
    let birthDate: String
    var body: some View {
        VStack {
           WebImage(url: URL(string: profileImageURL))
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
            
            if let age = CalculateAge().calculateAge(from: birthDate) {
                HStack {
                    Text(nickname)
                    Text("\(age)歳")
                    Text(activeRegion)
                }
                .foregroundColor(.black.opacity(0.8))
                .font(.system(size: 25))
                .fontWeight(.light)
                .padding(.vertical, 8)
            }
            
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
}

struct SelectUserComponent: View {
    let nickname: String
    let profileImageURL: String
    let activeRegion: String
    let birthDate: String
    let selection: Int
    let selfNum: Int
    var namespace: Namespace.ID
    
    var body: some View {
        ZStack {
            HStack(alignment: .top) {
                WebImage(url: URL(string: profileImageURL))
                    .resizable()
                    .frame(width: 80, height: 80)
                    .cornerRadius(15)
                VStack(alignment: .leading){
                    Text(nickname)
                        .foregroundColor(.black)
                        .font(.system(size: 14))
                    if let age = CalculateAge().calculateAge(from: birthDate) {
                        Text("\(age)歳・\(activeRegion)")
                            .font(.system(size: 12))
                            .foregroundColor(.gray.opacity(0.8))
                    }
                    
                    Spacer()
                }
            }
            .padding(.all, 8)
           
        }
    }
}
