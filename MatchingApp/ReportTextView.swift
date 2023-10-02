//
//  ReportTextView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/16.
//

import SwiftUI

struct ReportTextView: View {
    @Binding var reportText: String
    @Environment(\.dismiss) var dismiss
    @FocusState var focus: Bool
    private let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .heavy)
    var body: some View {
        VStack {
            TextEditor(text: $reportText)
                .foregroundColor(.customBlack)
                .frame(width: UIScreen.main.bounds.width-32)
                .focused($focus)
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("問題を報告する")
        .toolbar {
            ToolbarItem(placement: .keyboard){
                Button {
                    dismiss()
                } label: {
                    Text("決定")
                        .foregroundColor(.white)
                        .font(.system(size: 22, weight: .bold))
                        .frame(width: UIScreen.main.bounds.width, height: 60)
                        .background(Color.customBlue.opacity(0.8))
                        .padding(.bottom, 16)
                }
            }
            ToolbarItem(placement: .navigationBarLeading){
                Button {
                    UIIFGeneratorMedium.impactOccurred()
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.customBlack)
                }
            }
        }
        .onAppear {
            self.focus = true
        }
    }
}
