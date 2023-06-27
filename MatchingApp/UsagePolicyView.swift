//
//  UsagePolicyView.swift
//  MatchingApp
//
//  Created by 荒木太一 on 2023/05/08.
//
import SwiftUI

struct UsagePolicyView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ScrollView {
            VStack {
                
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

struct UsagePolicyView_Previews: PreviewProvider {
    static var previews: some View {
        UsagePolicyView()
    }
}
