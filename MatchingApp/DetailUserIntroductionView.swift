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
    @EnvironmentObject var userModel: UserObservableModel
    var body: some View {
        ScrollView {
            VStack {
                TextEditor(text: $viewModel.introductionText)
                    .frame(width: UIScreen.main.bounds.width-60, height: 300)
                    .font(.system(size: 22))
                    .padding(.all, 8)
                    
                Button {
                    SetToFirestore.shared.updateMyIntroduction(currentUid: userModel.uid, introduction: viewModel.introductionText)
                    dismiss()
                } label: {
                    Text("保存する")
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width-40, height: 60)
                        .background(Color.customGreen)
                        .cornerRadius(10)
                }
                
                Spacer()
            }
        }
        .onAppear{
            viewModel.introductionText = userModel.introduction
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("自己紹介")
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

struct DetailuserIntroductionView_Preview: PreviewProvider {
    static var previews: some View {
        DetailUserIntroductionView()
    }
}
