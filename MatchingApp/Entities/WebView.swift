//
//  WebView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/20.
//
typealias WebViewRepresentable = UIViewRepresentable

import SwiftUI
import WebKit

public struct WebView: WebViewRepresentable {
    
    public init(
        url: URL? = nil,
        configuration: WKWebViewConfiguration? = nil,
        webView: @escaping (WKWebView) -> Void = { _ in }) {
        self.url = url
        self.configuration = configuration
        self.webView = webView
    }
    
    private let url: URL?
    private let configuration: WKWebViewConfiguration?
    private let webView: (WKWebView) -> Void

    public func makeUIView(context: Context) -> WKWebView {
        makeView()
    }
    
    public func updateUIView(_ uiView: WKWebView, context: Context) {}
}

private extension WebView {

    func makeWebView() -> WKWebView {
        guard let configuration = self.configuration else { return WKWebView() }
        return WKWebView(frame: .zero, configuration: configuration)
    }
    
    func makeView() -> WKWebView {
        let view = makeWebView()
        webView(view)
        tryLoad(url, into: view)
        return view
    }
    
    func tryLoad(_ url: URL?, into view: WKWebView) {
        guard let url = url else { return }
        view.load(URLRequest(url: url))
    }
}
