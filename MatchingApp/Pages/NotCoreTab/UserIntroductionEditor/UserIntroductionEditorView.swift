//
//  DetailUserIntroductionView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/06.
//

import SwiftUI
import Combine

struct UserIntroductionEditorView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = UserIntroductionEditorViewModel()
    @EnvironmentObject var userModel: UserObservableModel
    @FocusState var focus: Bool

    var body: some View {
        ScrollView {
            VStack {
                TextEditor(text: $viewModel.userIntroduction)
                    .frame(width: UIScreen.main.bounds.width-60, height: 300)
                    .font(.system(size: 22))
                    .focused($focus)
                    .padding(.all, 8)
                Spacer()
            }
        }
        .onAppear{
            focus = true
            viewModel.userIntroduction = userModel.user.introduction
        }
        .onReceive(viewModel.$isSuccess){
            if $0 {
                self.focus = false
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal){
                Text("ひとこと")
                    .foregroundColor(.customBlack)
                    .font(.system(size: 16, weight: .medium))
            }
            
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Text("\(viewModel.userIntroduction.count)/1000")
                        .foregroundColor(.customBlack.opacity(0.8))
                        .font(.system(size: 14))
                    Spacer()
                    Button {
                        viewModel.storeUserIntroductionToFirestore(userModel: userModel)
                    } label: {
                        Text("保存する")
                            .foregroundColor(.white)
                            .bold()
                            .font(.system(size: 14))
                            .padding(.all, 8)
                            .background(Color.pink.opacity(0.8))
                            .cornerRadius(10)
                    }
                }
            }
        }
        .alert(isPresented: $viewModel.isErrorAlert) {
            Alert(
                title: Text("エラー"),
                message: Text(viewModel.errorMessage)
            )
        }
    }
}

struct DetailuserIntroductionView_Preview: PreviewProvider {
    static var previews: some View {
        UserIntroductionEditorView()
    }
}
