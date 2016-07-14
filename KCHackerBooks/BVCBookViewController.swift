//
//  BVCBookViewController.swift
//  KCHackerBooks
//
//  Created by Bhavish Chandnani on 13/7/16.
//  Copyright © 2016 BVC. All rights reserved.
//

import UIKit

class BVCBookViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var favImageView: UIScrollView!
    
    let model : BVCBook
    
    //MARK: - Initialization
    init(model: BVCBook){
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    @IBAction func readBtnClicked(sender: AnyObject) {
        navigationController?.pushViewController(BVCBookPDFViewController(model: model), animated: true)
    }
    
    //MARK: - Sync
    func syncModelWithView(){
       
        
        title =  Const.App.appName
        imageView.image = model.image
        titleLabel.text = model.title
        authorsLabel.text = convertArrayToString(model.authors)
        tagsLabel.text = convertArrayToString(model.tags)
        
        if (model.isFavourite){
            favImageView.image = UIImage(named: Const.FilesName.favouriteImage)
        }else{
            favImageView.image = UIImage(named: Const.FilesName.noFavouriteImage)
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        syncModelWithView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
