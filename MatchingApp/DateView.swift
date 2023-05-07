//
//  DateView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/05.
//

import SwiftUI

struct DateView: View {
    @StateObject var viewModel = DateViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("日程を決めてください")
                    .foregroundColor(.black.opacity(0.7))
                    .font(.system(size: 25))
                    .fontWeight(.heavy)
                    .padding(.top, 16)
                    .padding(.leading, 16)
                ForEach(viewModel.menu, id: \.self) { menu in
                    Button {
                        viewModel.selectedMenu = menu
                    } label: {
                        Text(menu)
                            .foregroundColor(
                                viewModel.selectedMenu == menu ? .black.opacity(0.7): .gray.opacity(0.6)
                            )
                            .fontWeight(.semibold)
                            .font(.system(size: 23))
                            .padding(.top, 8)
                    }
                }
                
                if viewModel.selectedMenu == "日時を指定" {
                    DatePicker("", selection: $viewModel.selectedDate)
                        .labelsHidden()
                        
                        
                }
                Spacer()
                NavigationLink {
                    SelectPairView()
                } label: {
                    NextButtonView()
                }

            }
        }
    }
}

struct DateView_Previews: PreviewProvider {
    static var previews: some View {
        DateView()
    }
}
