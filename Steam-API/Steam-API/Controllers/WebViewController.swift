//
//  WebViewController.swift
//  Steam-API
//
//  Created by Artem Tkachenko on 21.03.2023.
//

import UIKit
import WebKit

final class WebViewController: UIViewController, WKNavigationDelegate {
    
    // MARK: Properties
    
    private let webView: WKWebView = {
        let preferenses = WKWebpagePreferences()
        preferenses.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = preferenses
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()
    
    // MARK: Initializers
    
    init(with url: URL) {
        super.init(nibName: nil, bundle: nil)
        self.webView.load(URLRequest(url: url))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        webView.frame = view.bounds
    }
}
