//
//  PopupView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/26.
//

import SwiftUI

struct PopupView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                PopupBackgroundView(isPresented: isPresented)
                    .transition(.opacity)
                PopupContentsView(isPresented:$isPresented, width: geometry.size.width * 0.8)
                    .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.3)
                    .background(Color.white.brightness(Double(1.0)))
                    .cornerRadius(10)
            }
        }
    }
}

struct PopupBackgroundView: View {
    @State var isPresented: Bool
    
    var body: some View {
        Color.black.opacity(0.5)
            .onTapGesture {
                self.isPresented = false
            }
            .frame(
                width: UIScreen.main.bounds.width,
                height: UIScreen.main.bounds.height
            )
            .edgesIgnoringSafeArea(.all)
    }
}

struct PopupContentsView: View {
    @Binding var isPresented: Bool
    let width: CGFloat
    var body: some View {
        VStack {
            Text("ペアを組んでいる場合のみ表示できます。")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.black)
                .padding(.all, 8)
            Spacer()
            Button {
                withAnimation {
                    isPresented = false
                }
            } label: {
                Text("閉じる")
                    .foregroundColor(Color.white)
                    .frame(width: width, height: 50)
                    .background(Color.pink)
                    .font(.system(size: 16, weight: .bold))
            }

        }
        
    }
}
