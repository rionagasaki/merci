//
//  PrefectureTextView.swift
//  MatchingApp
//
//  Created by 荒木太一 on 2023/05/08.
//
import SwiftUI

struct PrefectureTextView: View {
    @StateObject private var viewModel = PrefectureTextViewModel()
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ScrollView {
            VStack {
                Text("住んでいる都道府県を教えてね！")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 16)
                    .padding(.horizontal, 16)
                TextField("都道府県", text: $viewModel.prefectureText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.top, 8)
                    .padding(.horizontal, 16)
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

struct PrefectureTextView_Previews: PreviewProvider {
    static var previews: some View {
        PrefectureTextView()
    }
}
