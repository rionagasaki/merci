//
//  NotificationView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/06.
//

import SwiftUI

struct NotificationView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            VStack{
                
            }
            .navigationTitle("お知らせ")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                }
            }
        }
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
