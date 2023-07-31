//
//  ProfileAttributeView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/05.
//

import SwiftUI

struct ProfileAttributeView: View {
    @ObservedObject var user: UserObservableModel
    let selectedDetailProfile: ProfileDetailItem
    
    func noSetView() -> some View {
        return (
            Text("未設定")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.gray.opacity(0.5))
        )
    }
    
    private func detailView(detail: String) -> some View {
        if detail.isEmpty || detail == "-" {
            return AnyView(noSetView())
        } else {
            return AnyView(
                Text(detail)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.customBlack)
            )
        }
    }
    
    var body: some View {
        VStack{
            HStack {
                Text(selectedDetailProfile.rawValue)
                    .foregroundColor(.gray.opacity(0.8))
                    .font(.system(size: 14))
                    .padding(.vertical, 8)
                
                Spacer()
                
                switch selectedDetailProfile {
                case .activeRegion:
                    detailView(detail: user.user.activeRegion)
                case .birthPlace:
                    detailView(detail: user.user.birthPlace)
                case .educationalBackground:
                    detailView(detail: user.user.educationalBackground)
                case .work:
                    detailView(detail: user.user.work)
                case .height:
                    detailView(detail: user.user.height)
                case .weight:
                    detailView(detail: user.user.weight)
                case .bloodType:
                    detailView(detail: user.user.bloodType)
                case .liquor:
                    detailView(detail: user.user.liquor)
                case .cigarettes:
                    detailView(detail: user.user.cigarettes)
                case .purpose:
                    detailView(detail: user.user.purpose)
                case .datingExpenses:
                    detailView(detail: user.user.datingExpenses)
                }
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 16)
            Divider()
        }
    }
}
