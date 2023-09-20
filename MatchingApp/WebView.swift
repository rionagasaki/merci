//
//  WebView.swift
//  Merci
//
//  Created by Rio Nagasaki on 2023/09/17.
//
import SwiftUI
import WebKit
import SafariServices

struct WebView: UIViewControllerRepresentable {
   
    let loadUrl: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<WebView>) -> SFSafariViewController {
        return SFSafariViewController(url: loadUrl)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<WebView>) {
        // SFSafariViewControllerにはURLの更新が直接的にはサポートされていないため、ここに特別な処理は不要
    }
}
