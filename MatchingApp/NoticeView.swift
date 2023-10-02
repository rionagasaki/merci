//
//  NoticeView.swift
//  Merci
//
//  Created by Rio Nagasaki on 2023/09/30.
//

import SwiftUI

struct NoticeView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
               Text("まだお知らせはないよ。")
                Spacer()
            }
            .onAppear {
                
            }
            .foregroundColor(.customBlack)
            .toolbar {
                ToolbarItem(placement: .principal){
                    Text("お知らせ")
                        .foregroundColor(.customBlack)
                        .font(.system(size: 16, weight: .medium))
                }
                ToolbarItem(placement: .navigationBarLeading){
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark.app.fill")
                            .foregroundColor(.customBlack)
                    }
                }
            }
        }
    }
}

struct NoticeView_Previews: PreviewProvider {
    static var previews: some View {
        NoticeView()
    }
}
