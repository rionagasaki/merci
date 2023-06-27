//
//  LoginView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/01.
//

import SwiftUI

struct OnboardingView: View {
    @State private var isPresentingLoginView:Bool = false
    
    var body: some View {
        NavigationView {
            ZStack{
                VStack(alignment:.leading ,spacing: 20){
                    Circle()
                        .size(width: 200, height: 200)
                        .foregroundColor(.yellow)
                    HStack{
                        Circle()
                            .size(width: 200, height: 200)
                            .foregroundColor(.blue)
                            .padding(.top,-120)
                        Circle()
                            .size(width: 200, height: 200)
                            .foregroundColor(.orange)
                            .padding(.top,30)
                    }
                }.ignoresSafeArea()
                VStack{
                    TabView{
                        VStack{
                            Text("学び始めよう。\n60分から。")
                                .bold()
                                .font(.system(size: 30))
                            Image("Person")
                                .resizable()
                                .frame(width: 300, height:300)
                            
                        }
                        .tag(1)
                        VStack{
                            Text("あなたの知識が\n報酬に。")
                                .bold()
                                .font(.system(size: 30))
                            Image("Person")
                                .resizable()
                                .frame(width: 300, height:300)
                            
                        }
                        .tag(2)
                        VStack{
                            Text("ひとこまを\n始めましょう！")
                                .bold()
                                .font(.system(size: 30))
                            Image("Person")
                                .resizable()
                                .frame(width: 300, height:300)
                        }
                        .tag(3)
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                    
                    Spacer()
                    
                }
            }
        }
    }
}

struct IntroduceView: View {
    let mainTitle: String
    let describeText: String
    let describeImage:String
    
    var body: some View{
        ZStack{
            VStack(alignment: .leading){
                Image(systemName: "checkmark")
                    .foregroundColor(.green)
                    .padding(.all,10)
                    .background(Color.white.opacity(1))
                    .cornerRadius(40)
                Text(mainTitle)
                    .fontWeight(.bold)
                    .font(.largeTitle)
                    .padding(.top,15)
                    .padding(.horizontal, 16)
                Text(describeText)
                    .font(.subheadline)
                    .padding(.top,10)
                    .padding(.horizontal, 16)
                Image(describeImage)
                    .resizable()
                    .frame(width: 120, height: 120, alignment: .center)
            }
        }
        .frame(width: 320, height: 500)
        .background(Color.white.opacity(0.3))
        .background(RoundedRectangle(cornerRadius: 20).stroke(Color.blue.opacity(0.5), lineWidth: 0.5))
        .background(.ultraThinMaterial).cornerRadius(20).shadow(radius: 20, x: 0, y: 0)
    }
}


struct IntroView_Previews: PreviewProvider{
    static var previews: some View {
        OnboardingView()
    }
}

