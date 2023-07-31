//
//  BubbleView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/14.
//

import SwiftUI

struct ChatBubble: Shape {
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight, .bottomRight], cornerRadii: CGSize(width: 10, height: 10))
        
        let trianglePath = UIBezierPath()
        trianglePath.move(to: CGPoint(x: rect.midX - 10, y: rect.maxY))
        trianglePath.addLine(to: CGPoint(x: rect.midX, y: rect.maxY + 20)) // 頂点までの距離を20に増やす
        trianglePath.addLine(to: CGPoint(x: rect.midX + 10, y: rect.maxY))
        trianglePath.close()
        
        path.append(trianglePath)
        
        return Path(path.cgPath)
    }
}


struct BubbleView: View {
    var text: String
    
    var body: some View {
        Text(text)
            .foregroundColor(.white)
            .font(.system(size: 16, weight: .bold))
            .padding(10)
            .frame(width: UIScreen.main.bounds.width-48)
            .background(Color.red.opacity(0.8))
            .clipShape(ChatBubble())
            .shadow(color: .gray, radius: 1, x: 1, y: 1)
    }
}
