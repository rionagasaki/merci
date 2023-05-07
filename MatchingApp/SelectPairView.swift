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
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            Text("ペアを選択してください")
                .foregroundColor(.black.opacity(0.7))
                .font(.system(size: 25))
                .fontWeight(.heavy)
                .padding(.top, 16)
                .padding(.leading, 16)
            
            ForEach(users, id: \.self) { user in
                Toggle(isOn: $isOn) {
                    Text(user)
                }
                .toggleStyle(.switch)
                .padding(.horizontal, 16)
            }
            CustomDivider()
            AddNewPairView()
            
            Spacer()
            Button {
                dismiss()
            } label: {
                Text("保存する")
                    .foregroundColor(.black
                    )
                    .frame(width: 300, height: 50)
                    .background(.yellow)
                    .cornerRadius(20)
            }
        }
    }
}

struct SelectPairView_Previews: PreviewProvider {
    static var previews: some View {
        SelectPairView()
    }
}
