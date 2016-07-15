//
//  LibraryTableViewController.swift
//  KCHackerBooks
//
//  Created by Bhavish Chandnani on 13/7/16.
//  Copyright © 2016 BVC. All rights reserved.
//

import UIKit

class BVCLibraryTableViewController: UITableViewController, UISplitViewControllerDelegate {
    
    
    //MARK: - Properties
    let model : BVCLibrary
    var delegate : BVCLibraryTableViewControllerDelegate?
    
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
        tableView.estimatedRowHeight = 60.0;
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            //TODO Change to number of books in favorites
            return 0
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
        
            if let tags =  model.tags,
                sectionBookArray = model.booksForTag(tags[indexPath.section-1]){
                let book = sectionBookArray[indexPath.row]
                cell?.bookImageView.image = book.image
                cell?.title.text = book.title
                if (book.isFavourite){
                    cell?.favImageView.image = UIImage(named: Const.FilesName.favoriteImage)
                }else{
                    cell?.favImageView.image = UIImage(named: Const.FilesName.noFavoriteImage)
                }
            } else {
                //TODO complete error
                BVCHackersBookErrors.wrongPath
            }

        return cell!
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section==0{
            //TODO change
            return "Favorites"
        }else{
            if let tags =  model.tags{
                 return tags[section-1]
            }else{
                return ""
            }
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.grayColor()
        
    }

    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let tags =  model.tags,
            sectionBookArray = model.booksForTag(tags[indexPath.section-1]){
            let book = sectionBookArray[indexPath.row]
            navigationController?.pushViewController(BVCBookViewController(model:book), animated: true)
        }
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


protocol BVCLibraryTableViewControllerDelegate {
    
    
    func universeViewController(vc : BVCBookViewController, didSelectBook book: BVCBook)
}