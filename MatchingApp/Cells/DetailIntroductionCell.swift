//
//  DetailIntroductionCell.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/06.
//

import SwiftUI

struct DetailProfileCellView: View {
    
    @ObservedObject var user: UserObservableModel
    let selectedDetailProfile: DetailProfile
    
    
    func noSetView() -> some View {
        return (
            Text("タップして設定")
                .font(.system(size: 16, weight: .light))
                .foregroundColor(.red)
                .padding(.bottom, 8)
        )
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(selectedDetailProfile.rawValue)
                    .foregroundColor(.gray.opacity(0.8))
                    .font(.system(size: 14))
                    .padding(.vertical, 8)
                
                switch selectedDetailProfile {
                case .activeRegion:
                    if user.activeRegion == "" {
                        noSetView()
                    } else {
                        Text(user.activeRegion)
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(.black)
                            .padding(.bottom, 8)
                    }
                case .birthPlace:
                    if user.birthPlace == "" {
                        noSetView()
                    } else {
                        Text(user.birthPlace)
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(.black)
                            .padding(.bottom, 8)
                    }
                case .educationalBackground:
                    if user.educationalBackground == "" {
                        noSetView()
                    } else {
                        Text(user.educationalBackground)
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(.black)
                            .padding(.bottom, 8)
                    }
                    
                case .work:
                    if user.work == "" {
                        noSetView()
                    } else {
                        Text(user.work)
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(.black)
                            .padding(.bottom, 8)
                    }
                case .height:
                    if user.height == "" {
                        noSetView()
                    } else {
                        Text(user.height)
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(.black)
                            .padding(.bottom, 8)
                    }
                case .weight:
                    if user.weight == "" {
                        noSetView()
                    } else {
                        Text(user.weight)
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(.black)
                            .padding(.bottom, 8)
                    }
                case .bloodType:
                    if user.bloodType == "" {
                        noSetView()
                    } else {
                        Text(user.bloodType)
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(.black)
                            .padding(.bottom, 8)
                    }
                case .liquor:
                    if user.liquor == "" {
                        noSetView()
                    } else {
                        Text(user.liquor)
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(.black)
                            .padding(.bottom, 8)
                    }
                case .cigarettes:
                    if user.cigarettes == "" {
                        noSetView()
                    } else {
                        Text(user.cigarettes)
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(.black)
                            .padding(.bottom, 8)
                    }
                case .purpose:
                    if user.purpose == "" {
                        noSetView()
                    } else {
                        Text(user.purpose)
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(.black)
                            .padding(.bottom, 8)
                    }
                case .datingExpenses:
                    if user.datingExpenses == "" {
                        noSetView()
                    } else {
                        Text(user.datingExpenses)
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(.black)
                            .padding(.bottom, 8)
                    }
                }
            }
            
            Spacer()
            Image(systemName: "chevron.right")
                .resizable()
                .scaledToFit()
                .foregroundColor(.gray.opacity(0.8))
                .frame(width: 15, height: 15)
        }
        .padding(.horizontal, 16)
        
    }
}
