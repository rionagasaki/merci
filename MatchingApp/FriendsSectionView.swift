//
//  SwiftUIView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/21.
//

import SwiftUI

struct FriendsSectionView: View {
    @EnvironmentObject var userModel: UserObservableModel
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .medium)
    var body: some View {
        HStack {
            NavigationLink {
                FriendsListView()
                    .onAppear {
                        UIIFGeneratorMedium.impactOccurred()
                    }
            } label: {
                VStack(alignment: .leading){
                    Text("友達")
                        .foregroundColor(.gray.opacity(0.5))
                        .font(.system(size: 24, weight: .bold))
                    HStack {
                        Text("\(userModel.friendUids.count)")
                            .foregroundColor(.customBlack)
                            .font(.system(size: 35, weight: .bold))
                        Image(systemName: "person.3.fill")
                            .resizable()
                            .frame(width: 90, height: 50)
                            .scaledToFill()
                            .foregroundColor(.gray.opacity(0.5))
                    }
                }
                .frame(width: (UIScreen.main.bounds.width/2)-16, height: 120)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(20)
            }

            NavigationLink {
                RequestedPairView()
                    .onAppear {
                        UIIFGeneratorMedium.impactOccurred()
                    }
            } label: {
                VStack(alignment: .leading){
                    Text("リクエスト")
                        .foregroundColor(.gray.opacity(0.5))
                        .font(.system(size: 24, weight: .bold))
                    HStack {
                        Text("\(userModel.requestedUids.count + userModel.pairRequestedUids.count)")
                            .foregroundColor(.customBlack)
                            .font(.system(size: 35, weight: .bold))
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .frame(width: 70, height: 50)
                            .scaledToFill()
                            .foregroundColor(.gray.opacity(0.5))
                    }
                }
                .frame(width: (UIScreen.main.bounds.width/2)-16, height: 120)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(20)
            }

        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsSectionView()
    }
}
