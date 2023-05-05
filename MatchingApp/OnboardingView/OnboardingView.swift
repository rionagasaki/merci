//
//  LoginView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/01.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var app: AppState
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Circle()
                        .frame(width: 200)
                        .blur(radius: 30)
                        .foregroundColor(.customRed1)
                        .padding(.leading, 80)
                    HStack {
                        ZStack(alignment: .bottomLeading) {
                            Circle()
                                .frame(width: 200)
                                .blur(radius: 30)
                                .foregroundColor(.yellow.opacity(0.8))
                                .padding(.trailing, 2)
                                .padding(.bottom, 120)
                            Circle()
                                .frame(width: 200)
                                .blur(radius: 30)
                                .foregroundColor(.blue.opacity(0.8))
                                .padding(.trailing, 20)
                                .padding(.bottom, 50)
                        }
                        Circle()
                            .frame(width: 200)
                            .blur(radius: 30)
                            .foregroundColor(.purple)
                            .padding(.leading, 30)
                            .padding(.top, 30)
                    }
                        
                }
                .frame(maxHeight: .infinity)
                .overlay {
                    Rectangle()
                        .foregroundColor(.white.opacity(0.7))
                        
                        .ignoresSafeArea()
                        
                }
                VStack(spacing: .zero) {
                    Text("POMPOM")
                        .bold()
                        .font(.system(size: 35))
                        .padding(.top, 20)
                    Image("Header_One")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                        .padding(.top, 20)
                    Spacer()
                    Button {
                        self.app.isLogin = true
                    } label: {
                        RichButton(buttonText: "Sign In")
                            .padding(.bottom, 16)
                    }

                    NavigationLink {
                        GenderView()
                    } label: {
                        RichButton(buttonText: "Sign Up")
                    }
                }
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}


