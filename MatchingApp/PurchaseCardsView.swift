//
//  PurchaseCardsView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/24.
//

import SwiftUI
import StoreKit

struct PurchaseCardsView: View {
    @StateObject var storeKit = StoreKitManager()
    @EnvironmentObject var userModel: UserObservableModel
    @State var items:[Product] = []
    let givenPoint: Int
    let price: Int
    
    var body: some View {
        ZStack(alignment: .leading){
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.white)
                .cornerRadius(20)
                .shadow(radius: 2)
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.clear)
                        .background(
                            LinearGradient(
                                colors: [.pink.opacity(0.4), .pink.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .cornerRadius(20)
                        ).frame(width: (UIScreen.main.bounds.width-32)/2.5)
                    VStack {
                        Text("\(givenPoint)")
                            .foregroundColor(.white)
                            .font(.system(size: 28, weight: .bold))
                        Text("ポイント")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .bold))
                    }
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4){
                    Spacer()
                    HStack {
                        Text("\(price)")
                            .foregroundColor(.pink.opacity(0.8))
                            .font(.system(size: 36, weight: .medium))
                        VStack(alignment: .leading){
                            Text("円")
                                .foregroundColor(.pink.opacity(0.7))
                                .font(.system(size: 20, weight: .medium))
                            Text("(税込)")
                                .foregroundColor(.pink.opacity(0.7))
                                .font(.system(size: 10, weight: .light))
                        }
                    }
                    Text("1000円お得!※")
                        .foregroundColor(.pink.opacity(0.7))
                        .font(.system(size: 14, weight: .medium))
                        .padding(.vertical, 4)
                        .padding(.horizontal, 16)
                        .background(Color.pink.opacity(0.1))
                        .cornerRadius(20)
                   Spacer()
                }
                Spacer()
            }
        }
        .frame(width: UIScreen.main.bounds.width-32, height: 100)
    }
}
    struct PurchaseCardsView_Previews: PreviewProvider {
        static var previews: some View {
            PurchaseCardsView(givenPoint: 1200, price: 10000)
        }
    }
