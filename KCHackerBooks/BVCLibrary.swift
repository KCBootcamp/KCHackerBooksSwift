//
//  BVCLibrary.swift
//  KCHackerBooks
//
//  Created by Bhavish Chandnani on 8/7/16.
//  Copyright © 2016 BVC. All rights reserved.
//

import Foundation

class BVCLibrary  {
    
    //MARK: - Initializers
    init (books : [BVCBook], tags: [String]?, favoriteBooks: [String]?){
        self.books  =   books
        self.tags   =   tags
        defineFavoriteBooks(favoriteBooks)
    }
    
    //MARK: - Stored properties
    var books   :   [BVCBook]
    let tags    :   [String]?
    
    //MARK: - Computed properties
    var booksCount : Int{
        get{
            let count : Int = self.books.count
            return count
        }
    }
    
    //MARK: - Utility types
    typealias BVCBookArray     =   [BVCBook]

    
    //MARK: - Sorting
    func  sortByName() -> BVCBookArray{
        return books.sort({$0<$1})
    }
    
    func sortByTags() -> BVCBookArray{
        var sortedBooks : BVCBookArray = []
        if let tags = tags{
        for tagElement in tags{
            if let booksForTagArray = booksForTag(tagElement){
                sortedBooks.appendContentsOf(booksForTagArray.sort({$0<$1}))
            }
        }
        }
        return sortedBooks
    }
    
    //MARK: - Counting and Clasification
    
    func booksCountForTag(tag:String?) -> Int {
        if let count = booksForTag(tag)?.count{
            return count
        }else {
            return 0
        }
    }
    
    func booksForTag(tag : String?) -> BVCBookArray? {
        var booksForTagArray : BVCBookArray = []
        if let tag = tag {
            for book in books {
                if let bookTags=book.tags{
                if ((bookTags.contains(tag))){
                    booksForTagArray.append(book)
                }
                }
            }
            return booksForTagArray
        }else{
            return nil
        }
    }
    
    //MARK: - Utilities
    
    func bookAtIndexForTag(index: Int, tag : String?) -> BVCBook? {
        if let tag = tag{
            return booksForTag(tag)?[index]
        }else{
            return books[index]
        }
    }
    
    func bookIndexForDescription(description: String) -> Int?{
        //TODO modify
        for book in books {
            if book.description == description{
                if let index = books.indexOf(book){
                    return index
                }
            }
        }
        return nil
    }
    
    //MARK: - Favorite Books
    func defineFavoriteBooks(favoritesBooks: [String]?){
        if let favoritesBooks = favoritesBooks{
            
            for book in favoritesBooks {
                if let index = bookIndexForDescription(book){
                    books[index].isFavourite = true
                }
            }
        }
    }

    
}
