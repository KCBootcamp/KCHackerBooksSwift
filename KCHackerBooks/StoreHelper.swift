//
//  StoreHelper.swift
//  KCHackerBooks
//
//  Created by Bhavish Chandnani on 11/7/16.
//  Copyright © 2016 BVC. All rights reserved.
//

import Foundation

//MARK: - Load
func loadJSONFromLocalFile(path: String) throws -> JSONArray {
   
    if let data =  NSData(contentsOfFile: path){
        return try convertDataToJSONArray(data)
    }else{
        throw BVCHackersBookErrors.jsonParsingError
    }
}


//MARK: - Download
func DownloadJSON() throws -> JSONArray {
    
    //TODO change to NSURLRequest and NSURLConnection with asynchronous download (completion block)
    do{
        let data =  try NSData(contentsOfURL: NSURL(string:  Const.DownloadUrls.jsonUrl)!, options: NSDataReadingOptions())
    
        let jsonArray = try convertDataToJSONArray(data)
        var json : JSONArray = []
        
        for var dict in jsonArray{
             DownloadResource(dict[Const.Json.imageURLKey] as? String, resourceType: Const.RelativePathValues.imagesPath)
             DownloadResource(dict[Const.Json.pdfURLKey] as? String, resourceType: Const.RelativePathValues.pdfsPath)
            let imageStr = try relativePathForURL(dict[Const.Json.imageURLKey] as? String, resourceType: Const.RelativePathValues.imagesPath)
            let pdfStr = try relativePathForURL(dict[Const.Json.pdfURLKey] as? String, resourceType: Const.RelativePathValues.pdfsPath)
            
            json.append(bookDictionaryForTitle(dict[Const.Json.titleKey] as? String, authors: dict[Const.Json.authorsKey] as? String, tags: dict[Const.Json.tagsKey] as? String, imageUrl: imageStr, pdfUrl: pdfStr))

        }
        
        let filePath = try PathForFile(Const.FilesName.booksFile, directory: nil)
        print(filePath)
        if let dataModified = try? NSJSONSerialization.dataWithJSONObject(json, options: NSJSONWritingOptions.PrettyPrinted){
            dataModified.writeToFile(filePath, atomically: true)
        }
        
        return json
        
    }catch{
        print("Files download error")
        throw BVCHackersBookErrors.downloadError
    }

}

func DownloadResource(resourceUrl: String?, resourceType: String) {
    do {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let localUrl = NSURL(fileURLWithPath: documentsPath)
    if let urlStr = resourceUrl, url = NSURL(string:urlStr),
        data =  try? NSData(contentsOfURL: url, options: NSDataReadingOptions()), relativePath = try relativePathForURL(url.absoluteString, resourceType: resourceType),
        filePath = localUrl.URLByAppendingPathComponent(relativePath).path
          {
        data.writeToFile(filePath, atomically: true)
    }
        
    }catch{
        print("Error al descargar \(resourceUrl)")

    }
    
    
    
}


//MARK: Utilities
func bookDictionaryForTitle (title:String?, authors:String?, tags:String?, imageUrl: String?, pdfUrl: String?)->JSONDictionary{
    var dic : JSONDictionary = [:]
    if let title = title {
        dic[Const.Json.titleKey] = title
    }
    if let authors = authors {
        dic[Const.Json.authorsKey] = authors
    }
    if let tags = tags {
        dic[Const.Json.tagsKey] = tags
    }
    if let imageUrl = imageUrl {
        dic[Const.Json.imageURLKey] = imageUrl
    }
    if let pdfUrl = pdfUrl {
        dic[Const.Json.pdfURLKey] = pdfUrl
    }
    return dic
}

func convertDataToJSONArray(data: NSData) throws -> JSONArray{
    if let maybeArray = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? JSONArray,
        array = maybeArray{
        return array
        
    }else{
        throw BVCHackersBookErrors.jsonParsingError
    }
}

//MARK: - Favorites

func loadFavoritesBooks()  -> [String]? {
    var favorites : [String] = []
    let defaults = NSUserDefaults.standardUserDefaults()
    if let favs = defaults.objectForKey(Const.UserDefaultKeys.favorites) as? [String]{
        favorites = favs
    }
    return favorites
}

func saveFavoriteBook(book: BVCBook){
    let defaults = NSUserDefaults.standardUserDefaults()
    if var favorites = defaults.objectForKey(Const.UserDefaultKeys.favorites) as? [String]{
        favorites.append(book.description)
        defaults.setObject(favorites, forKey: Const.UserDefaultKeys.favorites)
    }else{
        let favorites = [book.description]
        defaults.setObject(favorites, forKey: Const.UserDefaultKeys.favorites)
    }
    
}

func deleteFavoriteBook(book: BVCBook) {
    let defaults = NSUserDefaults.standardUserDefaults()
    if var favorites = defaults.objectForKey(Const.UserDefaultKeys.favorites) as? [String], let index = favorites.indexOf(book.description){
        favorites.removeAtIndex(index)
        defaults.setObject(favorites, forKey: Const.UserDefaultKeys.favorites)
    }
}

func changeFavoriteStatusforBook(book: BVCBook){
    if (!book.isFavourite){
        saveFavoriteBook(book)
    } else {
        deleteFavoriteBook(book)
    }
    
}