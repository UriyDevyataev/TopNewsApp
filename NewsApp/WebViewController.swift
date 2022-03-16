//
//  WebViewController.swift
//  NewsApp
//
//  Created by Юрий Девятаев on 14.03.2022.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var toolBar: UIToolbar!
    
    var url: URL?
        
    //MARK: - App life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configToolBar()
        configWebView()
    }
    
    //MARK: - Funcs configurations
    
    private func configToolBar(){
        configNavigationButton()
        configViewToolBar()
    }
    
    private func configWebView(){
        webView.navigationDelegate = self
        guard let url = url else {return}
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    private func configViewToolBar(){
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.backgroundColor = .red.withAlphaComponent(0.1)
        blurredEffectView.frame = CGRect(x: 0,
                                         y: 0,
                                         width: toolBar.bounds.width,
                                         height: toolBar.bounds.height + 100)
        
        toolBar.addSubview(blurredEffectView)
        toolBar.sendSubviewToBack(blurredEffectView)
    }
    
    private func configNavigationButton(){
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "arrowshape.turn.up.left.fill"),
            style: .plain,
            target: self,
            action: #selector(actionBack))
        
        let forwardButton = UIBarButtonItem(
            image: UIImage(systemName: "arrowshape.turn.up.right.fill"),
            style: .plain,
            target: self,
            action: #selector(actionForward))
        
        let reloadButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.clockwise"),
            style: .plain,
            target: self,
            action: #selector(actionReload))
        
        let stopButton = UIBarButtonItem(
            image: UIImage(systemName: "clear.fill"),
            style: .plain,
            target: self,
            action: #selector(actionStop))
        
        let flexButton = UIBarButtonItem.flexibleSpace()
        
        let buttonArray = [backButton, flexButton,
                           forwardButton, flexButton,
                           reloadButton, flexButton,
                           stopButton]
        
        toolBar.items = buttonArray
    }
    
    //MARK: - Actions
    
    @objc func actionReload(){
        webView.reload()
    }
    
    @objc func actionStop(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func actionBack(){
        webView.goBack()
    }
    
    @objc func actionForward(){
        webView.goForward()
    }
}

extension WebViewController: WKNavigationDelegate {
}
