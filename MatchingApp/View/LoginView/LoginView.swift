import SwiftUI
import AuthenticationServices
import Foundation
import FirebaseAuth
import CryptoKit

struct LoginView: View {
    @EnvironmentObject var userModel: UserObservableModel
    @EnvironmentObject var pairModel: PairObservableModel
    @StateObject private var viewModel = EmailLoginViewModel()
    @EnvironmentObject var appState: AppState
    @Binding var isShow: Bool
    @Binding var noAccountAlert: Bool
    @Binding var alertText: String
    var body: some View {
        VStack {
            AppleAuthView()
            GoogleAuthView(noAccountAlert: $noAccountAlert, alertText: $alertText)
            EmailAuthButton(isLoginShow: $isShow)
        }
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $viewModel.isVisibleValidateAlert) {
            Alert(
                title: Text("入力内容が間違っています")
                    .bold(),
                message: Text("メールアドレス、またはパスワードが違います。再度正しく入力してください。")
                    .fontWeight(.medium)
                ,
                dismissButton: .cancel(
                    Text("閉じる")
                        .fontWeight(.light)
                        .foregroundColor(.customBlue)
                )
            )
        }
    }
}


extension View {
    public func gradientForegroundColor() -> some View {
        self.overlay(.linearGradient(Gradient(colors: [.white, .white]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .mask(self)
    }
}
