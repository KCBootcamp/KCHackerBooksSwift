//
//  BVCBookPDFViewController.swift
//  KCHackerBooks
//
//  Created by Bhavish Chandnani on 13/7/16.
//  Copyright © 2016 BVC. All rights reserved.
//

import UIKit

class BVCBookPDFViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    var model : BVCBook
    
    init(model: BVCBook){
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let nCenter = NSNotificationCenter.defaultCenter()
        nCenter.addObserver(self, selector:#selector(bookDidChange), name: Const.App.notificationBookChanged, object: nil)
        sycModelWithView()
        
    }
    

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //MARK: - Sync
    func sycModelWithView(){
        title = model.title
        activityView.startAnimating()
        let req = NSURLRequest(URL: model.pdfURL)
        webView.delegate = self
        webView.loadRequest(req)
    }

    //MARK: - UIWebViewDelegate
    func webViewDidFinishLoad(webView: UIWebView) {
        activityView.stopAnimating()
        activityView.hidden = true
    }
    
    func bookDidChange(notification : NSNotification) {
   
        
        let info = notification.userInfo!
        
        let book = info[Const.App.bookKey] as! BVCBook
        
        model = book
        
        sycModelWithView()
     
        
    }
    
}
