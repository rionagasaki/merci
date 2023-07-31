//
//  DetailIntroductionCell.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/06.
//

import SwiftUI

struct ProfileAttributeEditorView: View {
    
    @ObservedObject var user: UserObservableModel
    let selectedDetailProfile: ProfileDetailItem
    
    func noSetView() -> some View {
        return (
            HStack(spacing: 4){
                Image("Coin")
                    .resizable()
                    .scaledToFit()
                    .frame(width:20, height: 20)
                Text("+10")
                    .foregroundColor(.yellow)
                    .font(.system(size: 14, weight: .medium))
            }
            
        )
    }
    
    private func detailView(detail: String) -> some View {
        if detail.isEmpty {
            return AnyView(noSetView())
        } else if detail == "-" {
            return AnyView(
                Text("タップして設定")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.pink)
            )
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
            Divider()
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
                Image(systemName: "chevron.right")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray.opacity(0.8))
                    .frame(width: 15, height: 15)
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 16)
        }
    }
}
