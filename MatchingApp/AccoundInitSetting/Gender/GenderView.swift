//
//  GenderView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/04.
//

import SwiftUI

struct GenderView: View {
    @StateObject var viewModel: UserObservableModel
    @Binding var presentationMode: PresentationMode
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            ScrollView {
                Text("性別を\n選択してください")
                    .font(.system(size: 25))
                    .fontWeight(.bold)
                    .foregroundColor(Color.customBlack)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 16)
                    .padding(.leading, 16)
                    
                VStack(alignment: .leading){
                    ForEach(viewModel.genders, id: \.self) { gender in
                        Button {
                            viewModel.gender = gender
                        } label: {
                            Text(gender)
                                .foregroundColor(viewModel.gender == gender ? Color.customBlack: .gray.opacity(0.6))
                                .fontWeight(.semibold)
                                .font(.system(size: 23))
                                .padding(.horizontal, 32)
                                .padding(.top, 8)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()
            NavigationLink {
                ActiveRegionTextView(viewModel: viewModel, presentationMode: $presentationMode)
            } label: {
                NextButtonView()
            }
        }
        .navigationBarBackButtonHidden()
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

