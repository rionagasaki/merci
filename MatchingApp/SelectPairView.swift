//
//  SelectPairView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/05.
//

import SwiftUI

struct SelectPairView: View {
    @State var isOn: Bool = false
    let users = ["Rio", "Kaa", "Kii", "Kuu"]
    @Binding var presentationMode: PresentationMode
    @Environment(\.dismiss) var dismiss
    var body: some View {
            VStack {
                ScrollView {
                    Text("ペアを選択してください")
                        .foregroundColor(.black.opacity(0.7))
                        .font(.system(size: 25))
                        .fontWeight(.heavy)
                        .padding(.top, 16)
                        .padding(.leading, 16)
                    
                    ForEach(users, id: \.self) { user in
                         SelectPairCell(username: user)
                    }
                    CustomDivider()
                    AddNewPairView()
                }
                Spacer()
                Button {
                    print("aaa")
                } label: {
                    Text("保存する")
                        .foregroundColor(.black
                        )
                        .bold()
                        .frame(width: 300, height: 50)
                        .background(.yellow)
                        .cornerRadius(20)
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(
                        action: {
                            dismiss()
                        }, label: {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.black)
                        }
                    )
                }
            }
    }
}
