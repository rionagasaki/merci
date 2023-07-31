//
//  SwiftUIView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/21.
//

import SwiftUI

struct FriendsSectionView: View {
    @EnvironmentObject var userModel: UserObservableModel
    @Binding var snsShareHalfSheet: Bool
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .medium)
    var body: some View {
        HStack {
            NavigationLink {
                PairSettingView()
            } label: {
                    VStack {
                        Text("友達を探す")
                            .foregroundColor(.customBlack)
                            .font(.system(size: 20, weight: .bold))
                        
                        Image(systemName: "person.3.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 50)
                            .foregroundColor(.customBlack)
                    }
                    .frame(width: (UIScreen.main.bounds.width/2)-16, height: 120)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(20)
            }

            Button {
                snsShareHalfSheet = true
            } label: {
                VStack {
                    Text("SNSで共有")
                        .foregroundColor(.customBlack)
                        .font(.system(size: 20, weight: .bold))
                    
                    Image(systemName: "link")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.customBlack)
                }
                .frame(width: (UIScreen.main.bounds.width/2)-16, height: 120)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(20)
            }

        }
    }
}
