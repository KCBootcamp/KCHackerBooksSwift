//
//  BVCBookPDFViewController.swift
//  KCHackerBooks
//
//  Created by Bhavish Chandnani on 13/7/16.
//  Copyright © 2016 BVC. All rights reserved.
//

import UIKit

class BVCBookPDFViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    let model : BVCBook
    
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
        title = model.title
        let req = NSURLRequest(URL: model.pdfURL)
        webView.loadRequest(req)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
