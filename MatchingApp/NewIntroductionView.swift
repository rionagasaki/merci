import SwiftUI
struct NewIntroductionView: View {
    
    var body: some View {
        VStack(spacing: .zero){
            Text("詳細なプロフィール")
                .padding(.leading, 16)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.black.opacity(0.8))
                .font(.system(size: 18))
                .bold()
            
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
                HomeView()
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

