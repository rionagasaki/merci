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
            NavigationLink {
                PrefectureTextView()
            } label: {
                DetailIntroductionCell(title: "都道府県", introductionText: "千葉県")
            }
            Divider()
            NavigationLink {
                ActiveRegionTextView()
            } label: {
                DetailIntroductionCell(title: "活動地域", introductionText: "東京都")
            }
        }
    }
}
struct NewIntroductionView_Previews: PreviewProvider {
    static var previews: some View {
        NewIntroductionView()
    }
}

