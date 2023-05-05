//
//  PrefectureView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/04.
//

import SwiftUI

struct PrefectureView: View {
    @StateObject private var viewModel = PrefectureViewModel()
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(alignment: .center){
            ScrollView (showsIndicators: false){
                Text("都道府県を選択してください")
                    .font(.system(size: 25))
                    .fontWeight(.heavy)
                    .foregroundColor(.black.opacity(0.7))
                    .padding(.top, 16)
                    .padding(.leading, 16)
                
                
                ForEach(viewModel.prefecture, id: \.self) { prefecture in
                    Button {
                        viewModel.selectedPrefecture = prefecture
                    } label: {
                        Text(prefecture)
                            .foregroundColor(
                                viewModel.selectedPrefecture == prefecture ? .black: .gray.opacity(0.6)
                            )
                            .fontWeight(.semibold)
                            .font(.system(size: 23))
                            .padding(.top, 8)
                    }
                }
            }
            Button {
                if viewModel.selectedPrefecture != "" {
                    self.appState.isLogin = true
                }
            } label: {
                NextButtonView()
            }
        }
    }
}

struct PrefectureView_Previews: PreviewProvider {
    static var previews: some View {
        PrefectureView()
    }
}
