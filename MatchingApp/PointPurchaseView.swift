//
//  PointPurchaseView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/09.
//

import SwiftUI

struct PointPurchaseView: View {
    @StateObject var viewModel = PointPurchaseViewModel()
    @EnvironmentObject var userModel: UserObservableModel
    @Environment(\.dismiss) var dismiss
    let productPointMapping: [String: Int] = [
        "com.temporary.message_ticket_1000": 1000,
        "com.temporary.message_ticket_2000": 2000,
        "com.temporary.message_ticket_5000": 5000
    ]

    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    Label {
                        Text("ポイント残高")
                            .foregroundColor(.gray)
                            .font(.system(size: 14, weight: .bold))
                    } icon: {
                        Image("Coin")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                    Text("\(userModel.user.coins)pt")
                        .foregroundColor(.customBlack)
                        .font(.system(size: 16, weight: .medium))
                    CustomDivider()
                }
                
                VStack(alignment: .leading){
                    Text("ポイント購入")
                        .foregroundColor(.pink)
                        .font(.system(size: 16, weight: .bold))
                        .padding(.horizontal, 16)
                    Text("ご希望のポイントをお選びください。")
                        .foregroundColor(.gray.opacity(0.8))
                        .font(.system(size: 14, weight: .medium))
                        .padding(.horizontal, 16)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(spacing: 32) {
                    ForEach (viewModel.products){ product in
                        if let givenPoint = productPointMapping[product.id] {
                            Button {
                                viewModel.purchase(product: product, uid: userModel.user.uid, givenPoint: givenPoint)
                            } label: {
                                PurchaseCardsView(givenPoint: givenPoint, price: NSDecimalNumber(decimal: product.price).intValue)
                            }
                        }
                    }
                    Text("300ポイント 480円で購入")
                        .foregroundColor(.gray.opacity(0.7))
                        .font(.system(size: 20, weight: .bold))
                    Text("100ポイント 160円で購入")
                        .foregroundColor(.gray.opacity(0.7))
                        .font(.system(size: 20, weight: .bold))
                    
                    Text("※1ptを1.60円として該当ポイント数を購入した料金との比較になります。")
                        .foregroundColor(.customBlack)
                        .font(.system(size: 10, weight: .medium))
                }
                
                AboutPurchaseView()
                    .padding(.top, 40)
            }
            .padding(.horizontal, 16)
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("ポイント購入")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
            }
        }
        .alert(isPresented: $viewModel.isErrorAlert){
            Alert(title: Text("エラー"), message: Text(viewModel.errorMessage))
        }
        .onAppear {
            viewModel.fetchProduct()
        }
    }
}

struct PointPurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        PointPurchaseView()
    }
}
