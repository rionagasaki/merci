//
//  SchoolTextView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/07.
//

import SwiftUI

struct SchoolTextView: View {
    @StateObject private var viewModel = SchoolTextViewModel()
    var body: some View {
        ScrollView {
            VStack{
                Text("大学名を教えてね！")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                
                TextField("大学名", text: $viewModel.schoolText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
            }
        }
    }
}

struct SchoolTextView_Previews: PreviewProvider {
    static var previews: some View {
        SchoolTextView()
    }
}
