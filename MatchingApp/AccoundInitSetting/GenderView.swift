//
//  GenderView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/04.
//

import SwiftUI

struct GenderView: View {
    @StateObject private var viewModel = GenderViewModel()
    var body: some View {
        VStack(alignment: .center) {
            ScrollView {
                Text("性別を選択してください")
                    .font(.system(size: 25))
                    .fontWeight(.heavy)
                    .padding(.top, 16)
                    .padding(.leading, 16)
                VStack {
                    ForEach(viewModel.gender, id: \.self) { gender in
                        Button {
                            viewModel.selectedGender = gender
                        } label: {
                            Text(gender)
                                .foregroundColor(viewModel.selectedGender == gender ? .black: .gray.opacity(0.6))
                                .fontWeight(.semibold)
                                .font(.system(size: 23))
                                .padding(.top, 8)
                                .padding(.leading, 16)
                        }
                    }
                }
            }
            Spacer()
            NavigationLink {
                PrefectureView()
            } label: {
                NextButtonView()
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

struct GenderView_Previews: PreviewProvider {
    static var previews: some View {
        GenderView()
    }
}
