//
//  AttributedText.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/09/04.
//
import SwiftUI
import UIKit

struct AttributedTextWrapper: UIViewRepresentable {
    var text: NSAttributedString

    func makeUIView(context: UIViewRepresentableContext<AttributedTextWrapper>) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }

    func updateUIView(_ uiView: UILabel, context: UIViewRepresentableContext<AttributedTextWrapper>) {
        uiView.attributedText = text
    }
}

struct AttributedText: View {
    let nickname: String
    var body: some View {
        let attributedString = NSMutableAttributedString(string: nickname, attributes: [.foregroundColor: UIColor.black, .font: UIFont.boldSystemFont(ofSize: 16)])
        attributedString.append(NSAttributedString(string: "さんがあなたにいいねしました", attributes: [.foregroundColor: UIColor.gray, .font: UIFont.systemFont(ofSize: 16)]))

        return AttributedTextWrapper(text: attributedString)
    }
}
