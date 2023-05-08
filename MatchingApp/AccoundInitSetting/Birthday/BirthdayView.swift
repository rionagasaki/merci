//
//  BirthdayView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/04.
//

import SwiftUI

struct BirthdayView: View {
    @StateObject var viewModel = BirthdayViewModel()
    var body: some View {
        VStack {
            Text("生年月日を入力してください")
                .font(.system(size: 25))
                .fontWeight(.heavy)
                .padding(.top, 16)
                .padding(.leading, 16)
            DatePicker("", selection: $viewModel.selectedBirthday)
                .labelsHidden()
                .padding(.top, 8)
            Spacer()
            HStack {
                DismissButtonView()
                Spacer()
                NextButtonView()
            }
            .padding(.horizontal, 32)
        }
    }
}

struct BirthdayView_Previews: PreviewProvider {
    static var previews: some View {
        BirthdayView()
    }
}
