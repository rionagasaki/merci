import SwiftUI
import AuthenticationServices
import Foundation
import FirebaseAuth
import CryptoKit

struct LoginView: View {
    @EnvironmentObject var userModel: UserObservableModel
    @StateObject private var viewModel = EmailLoginViewModel()
    @EnvironmentObject var appState: AppState
    @Binding var isShow: Bool
    @Binding var noAccountAlert: Bool
    @Binding var alertText: String
    var body: some View {
        VStack {
            AppleAuthView()
            GoogleAuthView()
            EmailAuthButton(isLoginShow: $isShow)
        }
        .navigationBarBackButtonHidden(true)
    }
}
