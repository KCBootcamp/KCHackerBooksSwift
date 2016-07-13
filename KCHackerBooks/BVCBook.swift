//
//  BVCBook.swift
//  KCHackerBooks
//
//  Created by Bhavish Chandnani on 8/7/16.
//  Copyright © 2016 BVC. All rights reserved.
//

import Foundation
import UIKit

class BVCBook : Comparable {
    
    //MARK: - Stored properties
    let title       :   String
    let authors     :   [String]?
    let tags        :   [String]?
    let image       :   UIImage?
    let pdfURL      :   NSURL
    let isFavourite :   Bool
    
    
    //MARK: - Initializers
    init(title: String, authors: [String]?,
         tags: [String]?, image: UIImage?,
         pdfURL: NSURL, isFavourite: Bool){
        
        self.title          =   title
        self.authors        =   authors
        self.tags           =   tags
        self.image          =   image
        self.pdfURL         =   pdfURL
        self.isFavourite    =   isFavourite
        
    }
    
    convenience init (title: String, authors: [String]?,
                      tags: [String]?, image: UIImage?,
                      pdfURL: NSURL){
        
        self.init (title: title, authors: authors,
                   tags: tags, image: image,
                   pdfURL: pdfURL, isFavourite:false)
        
    }
    
 
    
    
    //MARK: - Proxies
    var proxyForComparison : String{
        get{
            let authorString = convertArrayToString(authors)
            guard (authorString == nil) else{
                return "\(title)\(authorString)\(pdfURL)"
            }

            return "\(title)\(pdfURL)"
        }
    }
    
    var proxyForSorting : String{
        get{
            return "\(title)"
        }
    }
}

//MARK: - Extensions
extension BVCBook: CustomStringConvertible{
    
    
    //MARK: - CustomStringConvertible
    var description: String {
        get{
            let authorsString = convertArrayToString(authors)
            
            
            guard (authorsString == nil) else{
                return "<\(self.dynamicType)> Book: \(title) - written by \(authorsString)"
            }
            
            return "<\(self.dynamicType)> Book: \(title)"
        }
    }
    
}

//MARK: - Equatable and Comparable
func == (lhs: BVCBook, rhs: BVCBook) -> Bool{
    guard (lhs !== rhs) else{
        return true
    }
    
    return lhs.proxyForComparison == rhs.proxyForComparison
}

func <(lhs: BVCBook, rhs: BVCBook) -> Bool{
    return lhs.proxyForSorting < rhs.proxyForSorting
}