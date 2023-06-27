//
//  TextEditorWithPlaceholder.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/25.
//

import SwiftUI

struct TextEditorWithPlaceholder: View {

    @FocusState private var focusedField: Field?
    
    enum Field {
        case textEditor
        case placeholder
    }

    @Binding var text: String
    private let placeholderText: String

    init(_ placeholder: String, text: Binding<String>) {
        self._text = text
        self.placeholderText = placeholder
    }

    var body: some View {
        ZStack {

            // テキストが空の時にプレースホルダーを表示する
            if text.isEmpty {

                ZStack {
                    Rectangle()
                        .fill(Color(uiColor: .systemBackground))
                        .onTapGesture {
                            focusedField = .placeholder
                        }

                    VStack {
                        HStack {
                            TextField(placeholderText, text: $text)
                                
                                .onAppear {
                                    focusedField = .placeholder
                                }

                            Spacer()
                        }
                        .padding(.leading, 6)
                        .padding(.top, 8)

                        Spacer()
                    }
                }

                // テキストが空ではない時にTextEditorを表示する
            } else {
                TextEditor(text: $text)
                    .onAppear {
                        focusedField = .textEditor
                    }
            }
        }
    }
}
