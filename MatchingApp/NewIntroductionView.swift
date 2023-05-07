//
//  NewIntroductionView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/06.
//

import SwiftUI

struct NewIntroductionView: View {
    
    var body: some View {
        VStack(spacing: .zero){
            
            NavigationLink {
                SchoolTextView()
            } label: {
                DetailIntroductionCell(title: "学校名", introductionText: "東京大学")
            }

            Divider()
            DetailIntroductionCell(title: "都道府県", introductionText: "千葉県")
            Divider()
            DetailIntroductionCell(title: "活動地域", introductionText: "東京都")
        }
    }
}

struct NewIntroductionView_Previews: PreviewProvider {
    static var previews: some View {
        NewIntroductionView()
    }
}