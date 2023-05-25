//
//  ServiceContentView.swift
//  MatchingApp
//
//  Created by 荒木太一 on 2023/05/07.
//
import SwiftUI

struct ServiceContentView: View {
    @Environment(\.dismiss) var dismiss 
    var body: some View {
        ScrollView {
            
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

struct ServiceContentView_Previews: PreviewProvider {
    static var previews: some View {
        ServiceContentView()
    }
}
