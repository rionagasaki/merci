//
//  PairAddInitView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/26.
//

import SwiftUI

struct PairAddInitView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var presentationMode: PresentationMode
    
    var body: some View {
        VStack {
            Text("(任意)招待IDがあれば\n入力してください。")
                .font(.system(size: 25))
                .fontWeight(.bold)
                .foregroundColor(Color.customBlack)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 16)
                .padding(.leading, 16)
            
            Spacer()
            Button {
                
            } label: {
                Text("NiNiを始める")
                    .foregroundColor(.white)
                    .bold()
                    .frame(width: UIScreen.main.bounds.width-32, height: 50)
                    .background(Color.pink)
                    .cornerRadius(10)
            }
        }
        .navigationBarBackButtonHidden()
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

