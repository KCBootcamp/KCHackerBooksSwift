//
//  BVCBookViewController.swift
//  KCHackerBooks
//
//  Created by Bhavish Chandnani on 13/7/16.
//  Copyright © 2016 BVC. All rights reserved.
//

import UIKit

class BVCBookViewController: UIViewController, UISplitViewControllerDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var favImageView: UIImageView!
    
    
    
    
    let model : BVCBook
    var isFavorite : Bool
    
    //MARK: - Initialization
    init(model: BVCBook){
        self.model = model
        self.isFavorite=model.isFavourite
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
        displayFavoriteImage()
        
    }
    
    func displayFavoriteImage(){
        if (isFavorite){
            favImageView.image = UIImage(named: Const.FilesName.favoriteImage)
        }else{
            favImageView.image = UIImage(named: Const.FilesName.noFavoriteImage)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(BVCBookViewController.imageTapped(_:)))
        favImageView.userInteractionEnabled = true
        favImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func imageTapped(img: AnyObject)
    {
        isFavorite = !isFavorite
        //Change status in persistence
        displayFavoriteImage()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        syncModelWithView()
        if (splitViewController?.displayMode == UISplitViewControllerDisplayMode.PrimaryHidden){
            
            if let splitViewController = splitViewController{
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Library", style: (splitViewController.displayModeButtonItem().style), target:splitViewController.displayModeButtonItem().target, action: splitViewController.displayModeButtonItem().action)
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: -UISplitViewControllerDelegate
    func splitViewController(svc: UISplitViewController, willChangeToDisplayMode displayMode: UISplitViewControllerDisplayMode) {
        if (displayMode == UISplitViewControllerDisplayMode.PrimaryHidden) {
            if let splitViewController = splitViewController{
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Library", style: (splitViewController.displayModeButtonItem().style), target:splitViewController.displayModeButtonItem().target, action: splitViewController.displayModeButtonItem().action)
            }
        }else{
            navigationItem.rightBarButtonItem = nil;
        }
    }
    
    


}
