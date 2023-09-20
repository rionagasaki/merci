//
//  CallBottomBar.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/20.
//

import SwiftUI

struct CallBottomBar: View {
    let isMuted: Bool
    let isMutedAction: () -> Void
    let isSpeaker: Bool
    let isOutputRouterAction: () -> Void
    let leaveAction: () -> Void
    
    var body: some View {
        HStack {
            VStack(spacing: .zero){
                Image(systemName: self.isMuted ? "mic.slash.fill": "mic.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .foregroundColor(.white)
                    .background(Color.customBlack)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                
                Text(self.isMuted ? "ミュート中": "ミュートする")
                    .foregroundColor(.white)
                    .font(.system(size: 12))
            }
            .onTapGesture {
                self.isMutedAction()
            }
            
            Spacer()
            Rectangle()
                .foregroundColor(.white)
                .frame(width: 0.2, height: 56)
            Spacer()
            VStack(spacing: .zero){
                Image(systemName: self.isSpeaker ? "speaker.wave.2.fill": "speaker.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .foregroundColor(.white)
                    .background(Color.customBlack)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                
                Text("マイク")
                    .foregroundColor(.white)
                    .font(.system(size: 12))
            }
            .onTapGesture {
                self.isOutputRouterAction()
            }
            
            Spacer()
            Rectangle()
                .foregroundColor(.white)
                .frame(width: 0.2, height: 56)
            Spacer()
            VStack(spacing: .zero){
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .foregroundColor(.red)
                    .background(Color.customBlack)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                
                Text("終了")
                    .foregroundColor(.red)
                    .font(.system(size: 12))
            }
            .onTapGesture {
                self.leaveAction()
            }
        }
        .padding(.horizontal, 30)
        .frame(width: UIScreen.main.bounds.width-48 ,height: 64)
        .background(Color.customBlack)
        .padding(.bottom, 24)
        .cornerRadius(30)
    }
}
