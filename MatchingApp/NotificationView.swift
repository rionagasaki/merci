//
//  NotificationView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/09/08.
//

import SwiftUI

struct NotificationView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            VStack {
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.customBlack)
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    Text("お知らせ")
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
