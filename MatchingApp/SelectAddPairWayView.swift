//
//  SelectAddPairWayView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/20.
//

import SwiftUI

struct SelectAddPairWayView: View {
    @FocusState var focus: Bool
    @Environment(\.dismiss) var dismiss
    var body: some View {
        List {
            NavigationLink {
                AddNewPairView(focus: _focus)
            } label: {
                HStack {
                    Image(systemName: "person")
                        .resizable()
                        .frame(width: 30, height:30)
                        .foregroundColor(.white)
                        .padding(.all, 16)
                        .background(Color.customBlack.opacity(0.7))
                        .cornerRadius(20)
                    Text("IDで友達追加")
                        .foregroundColor(.customBlack)
                        .bold()
                        .padding(.leading, 16)
                }
            }
            
            NavigationLink {
                SNSShareView()
            } label: {
                HStack {
                    Image(systemName: "arrowshape.turn.up.forward.fill")
                        .resizable()
                        .frame(width: 30, height:30)
                        .foregroundColor(.white)
                        .padding(.all, 16)
                        .background(Color.customBlack.opacity(0.7))
                        .cornerRadius(20)
                    Text("SNSでIDをシェア")
                        .foregroundColor(.customBlack)
                        .bold()
                        .padding(.leading, 16)
                }
            }
        }.onAppear {
            focus = true
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
                Text("友達を追加")
                    .foregroundColor(.customBlack)
                    .font(.system(size: 22, weight: .bold))
            }
        }
    }
}

struct SelectAddPairWayView_Previews: PreviewProvider {
    static var previews: some View {
        SelectAddPairWayView()
    }
}
