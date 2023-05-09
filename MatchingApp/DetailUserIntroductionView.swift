//
//  DetailUserIntroductionView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/06.
//

import SwiftUI


struct DetailUserIntroductionView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = DetailUserIntroductionViewModel()
    var body: some View {
        VStack {
            Text("自己紹介を書いてください。")
                .fontWeight(.bold)
                .font(.system(size: 16))
            TextEditor(text: $viewModel.introductionText)
                .frame(width: UIScreen.main.bounds.width-60, height: 300)
                .cornerRadius(20)
                .padding(.all, 8)
                .overlay {
                    RoundedRectangle(cornerRadius: 20).stroke(.gray, lineWidth: 1)
                    
                    
                }
            Button {
                dismiss()
            } label: {
                Text("保存する")
                    .bold()
                    .foregroundColor(.black
                    )
                    .frame(width: UIScreen.main.bounds.width-60, height: 50)
                    .background(.yellow)
                    .cornerRadius(20)
                    .padding(.top, 16)
            }

            Spacer()
        }
    }
}

struct DetailuserIntroductionView_Preview: PreviewProvider {
    static var previews: some View {
        DetailUserIntroductionView()
    }
}
