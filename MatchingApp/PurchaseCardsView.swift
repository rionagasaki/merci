//
//  PurchaseCardsView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/24.
//

import SwiftUI

struct PurchaseCardsView: View {
    @StateObject var storeKit = StoreKitManager()
    @EnvironmentObject var userModel: UserObservableModel
    var body: some View {
        VStack {
            ForEach(storeKit.storeProducts) { ticket in
                Button {
                    Task { try await storeKit.purchase(product: ticket, completion: {
                        SetToFirestore.shared.purchaseCoins(uid: userModel.uid, increaseCoins: 10)
                    }) }
                } label: {
                    HStack {
                        Text(ticket.displayName)
                        Text(ticket.displayPrice)
                    }
                }
            }
        }
        
    }
}
    struct PurchaseCardsView_Previews: PreviewProvider {
        static var previews: some View {
            PurchaseCardsView()
        }
    }
