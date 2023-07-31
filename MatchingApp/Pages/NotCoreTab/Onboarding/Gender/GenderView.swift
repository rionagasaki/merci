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
            Text("性別を\n選択してください")
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
                            .foregroundColor(userModel.user.gender == gender ? Color.customBlack: .gray.opacity(0.6))
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
                    ActiveRegionInitView(presentationMode: $presentationMode)
                        .onAppear {
                            UIIFGeneratorMedium.impactOccurred()
                        }
                } label: {
                    Text("次へ")
                        .foregroundColor(.white)
                        .bold()
                        .frame(width: UIScreen.main.bounds.width-32, height: 50)
                        .background(Color.pink)
                        .cornerRadius(10)
                }
            } else {
                Text("次へ")
                    .foregroundColor(.white)
                    .bold()
                    .frame(width: UIScreen.main.bounds.width-32, height: 50)
                    .background(Color.gray.opacity(0.8))
                    .cornerRadius(10)
            }
        }
        .navigationTitle("性別")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .background(Color.white)
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
