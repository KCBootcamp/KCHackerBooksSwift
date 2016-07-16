//
//  LibraryTableViewController.swift
//  KCHackerBooks
//
//  Created by Bhavish Chandnani on 13/7/16.
//  Copyright © 2016 BVC. All rights reserved.
//

import UIKit

class BVCLibraryTableViewController: UITableViewController, LibraryTableViewControllerDelegate {
    
    
    //MARK: - Properties
    let model : BVCLibrary
    var delegate : LibraryTableViewControllerDelegate?
    
    //MARK: - Initialization
    init(model: BVCLibrary){
        self.model = model
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib( UINib (nibName: "BVCBookTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "BookCell")
         
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 50.0;
        title =  Const.App.appName
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let nCenter = NSNotificationCenter.defaultCenter()
        nCenter.addObserver(self, selector:#selector(bookFavouriteStatusDidChange), name: Const.App.notificationBookFavoriteStatusChanged, object: nil)

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func bookFavouriteStatusDidChange(notification: NSNotification) {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        if let tags = model.tags{
            return tags.count + 1
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            return model.books.filter({$0.isFavourite == true}).count
        }else{
            if let tags = model.tags{
                return model.booksCountForTag(tags[section-1])
            } else {
                return 0
            }
        }
    }
    
    
    //MARK: - TableViewDelegate
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cellId = "BookCell"
        
            var cell  =
                tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as? BVCBookTableViewCell
    
        if cell == nil{
            cell = BVCBookTableViewCell()
        }
        var book : BVCBook
        if (indexPath.section == 0){
            let favBooks = model.books.filter({$0.isFavourite == true})
            book = favBooks[indexPath.row]
        } else {
            
            if let tags =  model.tags,
                sectionBookArray = model.booksForTag(tags[indexPath.section-1]){
                
                book = sectionBookArray[indexPath.row]

            } else {
                book = BVCBook(title: "", authors: nil, tags: nil, image: nil, pdfURL: NSURL(string: "" )!)
            }
        }
        
            cell?.bookImageView.image = book.image
            cell?.title.text = book.title
            if (book.isFavourite){
                cell?.favImageView.image = UIImage(named: Const.FilesName.favoriteImage)
            }else{
                cell?.favImageView.image = UIImage(named: Const.FilesName.noFavoriteImage)
            }
            
        

        return cell!
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section==0{
            //TODO change
            return Const.App.favorite.uppercaseString
        }else{
            if let tags =  model.tags{
                 return tags[section-1].uppercaseString
            }else{
                return ""
            }
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.grayColor()
        
    }

    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let book : BVCBook
        if indexPath.section == 0 {
            let favBooks = model.books.filter({$0.isFavourite == true})
            book = favBooks[indexPath.row]
        }else{
            if let tags =  model.tags,
                sectionBookArray = model.booksForTag(tags[indexPath.section-1]){
                book = sectionBookArray[indexPath.row]
            }else{
                book = BVCBook (title: "", authors: nil, tags: nil, image: nil, pdfURL: NSURL(string:"")!)
            }
        }
        delegate?.libraryViewController(self, didSelectBook: book)
            
        NSNotificationCenter.defaultCenter().postNotificationName(Const.App.notificationBookChanged, object: self, userInfo: [Const.App.bookKey: book])

        
    }
    
    
    //MARK: - LibraryTableViewControllerDelegate
    
    func libraryViewController(vc: BVCLibraryTableViewController, didSelectBook book: BVCBook) {
        navigationController?.pushViewController(BVCBookViewController(model:book), animated: true)
    }
       /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
}


protocol LibraryTableViewControllerDelegate {
    
    func libraryViewController(vc : BVCLibraryTableViewController, didSelectBook book: BVCBook)
    
}
