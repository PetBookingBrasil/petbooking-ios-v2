//
//  WebviewViewController.swift
//  petbooking-ios-v2
//
//  Created by David Batista on 10/02/2018.
//  Copyright © 2018 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import ALLoadingView

struct WebviewRequest {
    let title: String
    let url: URL?
}

class WebviewViewController: UIViewController, WebviewViewProtocol {
    
    @IBOutlet weak var webview: UIWebView!
    
    var webviewRequest: WebviewRequest?
    var presenter: WebviewPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = webviewRequest?.title
        webview.delegate = self
        
        setBackButton()
        open(url: webviewRequest?.url)
    }

    func open(url: URL?) {
        guard let url = url else { return }
        
        ALLoadingView.manager.showLoadingView(ofType: .basic, windowMode: .fullscreen)

        let request = URLRequest(url: url)
        webview.loadRequest(request)
    }
}

extension WebviewViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        ALLoadingView.manager.hideLoadingView(withDelay: 1) { }
    }
}
