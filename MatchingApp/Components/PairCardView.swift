//
//  RecruitmentView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/03.
//

import SwiftUI
import SDWebImageSwiftUI

struct PairCardView: View {
    let pairModel:PairObservableModel
    var localImageName_1: String? = nil
    var localImageName_2: String? = nil
    var body: some View {
        VStack {
            HStack(alignment: .top){
                HStack(spacing: 10){
                    VStack {
                        if let localImageName_1 = localImageName_1 {
                            Image(localImageName_1)
                                .resizable()
                                .scaledToFill()
                                .frame(width: (UIScreen.main.bounds.width/2)-30, height: (UIScreen.main.bounds.width/2)-30)
                                .cornerRadius(20)
                        } else {
                            WebImage(url: URL(string: pairModel.pair.pair_1_profileImageURL))
                                .resizable()
                                .frame(width: (UIScreen.main.bounds.width/2)-30, height: (UIScreen.main.bounds.width/2)-30)
                                .cornerRadius(20)
                        }
                        
                        if let age = CalculateAge.calculateAge(from: pairModel.pair.pair_1_birthDate) {
                            Text("\(age)歳 \(pairModel.pair.pair_1_activeRegion)")
                                .foregroundColor(.black.opacity(0.8))
                                .bold()
                                .font(.system(size: 14))
                        }
                    }
                    VStack {
                        if let localImageName_2 = localImageName_2 {
                            Image(localImageName_2)
                                .resizable()
                                .scaledToFill()
                                .frame(width: (UIScreen.main.bounds.width/2)-30, height: (UIScreen.main.bounds.width/2)-30)
                                .cornerRadius(20)
                        } else {
                            WebImage(url: URL(string: pairModel.pair.pair_2_profileImageURL))
                                .resizable()
                                .frame(width: (UIScreen.main.bounds.width/2)-30, height: (UIScreen.main.bounds.width/2)-30)
                                .cornerRadius(20)
                        }
                        if let age = CalculateAge.calculateAge(from: pairModel.pair.pair_2_birthDate) {
                            Text("\(age)歳 \(pairModel.pair.pair_2_activeRegion)")
                                .foregroundColor(.black.opacity(0.8))
                                .bold()
                                .font(.system(size: 14))
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 8)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.white)
                .shadow(radius: 2)
        }
        .padding(.horizontal, 8)
    }
}
