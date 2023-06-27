//
//  PairRequestWayView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/21.
//

import SwiftUI

struct PairRequestWayView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        List {
            NavigationLink {
                FriendsListView()
            } label: {
                HStack {
                    Image(systemName: "person.3.fill")
                        .resizable()
                        .frame(width: 30, height:30)
                        .foregroundColor(.white)
                        .padding(.all, 16)
                        .background(Color.customBlack.opacity(0.7))
                        .cornerRadius(20)
                    Text("友達からペアを選択する")
                        .foregroundColor(.customBlack)
                        .bold()
                        .padding(.leading, 16)
                }
            }
            
            NavigationLink {
                SelectAddPairWayView()
            } label: {
                HStack {
                    Image(systemName: "person.badge.plus.fill")
                        .resizable()
                        .frame(width: 30, height:30)
                        .foregroundColor(.white)
                        .padding(.all, 16)
                        .background(Color.customBlack.opacity(0.7))
                        .cornerRadius(20)
                    Text("新しく友達を追加する")
                        .foregroundColor(.customBlack)
                        .bold()
                        .padding(.leading, 16)
                }
            }
        }
        .navigationBarBackButtonHidden()
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
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("ペア設定")
                    .foregroundColor(.customBlack)
                    .font(.system(size: 22, weight: .bold))
            }
        }
    }
}

struct PairRequestWayView_Previews: PreviewProvider {
    static var previews: some View {
        PairRequestWayView()
    }
}
