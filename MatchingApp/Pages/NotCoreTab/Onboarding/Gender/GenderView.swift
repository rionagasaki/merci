import SwiftUI

struct GenderView: View {
    @Binding var presentationMode: PresentationMode
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userModel: UserObservableModel
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .medium)
    var isEnabled: Bool {
        userModel.user.gender != ""
    }
    var body: some View {
        VStack {
            Text("🐶 性別を\n 選択してください")
                .font(.system(size: 25))
                .fontWeight(.bold)
                .foregroundColor(Color.customBlack)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 16)
                .padding(.leading, 16)
            
            VStack(alignment: .leading){
                ForEach(userModel.genders, id: \.self) { gender in
                    Button {
                        userModel.user.gender = gender
                    } label: {
                        Text(gender)
                            .foregroundColor(
                                userModel.user.gender == gender ? Color.customBlack: .gray.opacity(0.6))
                            .fontWeight(.semibold)
                            .font(.system(size: 23))
                            .padding(.horizontal, 32)
                            .padding(.top, 8)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            if isEnabled {
                NavigationLink {
                    ProfileImageInitView(presentationMode: $presentationMode)
                } label: {
                    Text("次へ")
                        .foregroundColor(.white)
                        .bold()
                        .frame(width: UIScreen.main.bounds.width-32, height: 60)
                        .background(Color.customBlue)
                        .cornerRadius(10)
                }
            } else {
                Text("次へ")
                    .foregroundColor(.customBlack)
                    .bold()
                    .frame(width: UIScreen.main.bounds.width-32, height: 60)
                    .background(Color.customLightGray)
                    .cornerRadius(10)
            }
        }
        .navigationTitle("性別")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.white)
    }
}
