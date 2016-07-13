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
        let data =  try NSData(contentsOfURL: NSURL(string:  DownloadUrls.jsonUrl.rawValue)!, options: NSDataReadingOptions())
    
        let jsonArray = try convertDataToJSONArray(data)
        var json : JSONArray = []
        
        for var dict in jsonArray{
             DownloadResource(dict["image_url"] as? String, resourceType: RelativePathValues.imagesPath.rawValue)
             DownloadResource(dict["pdf_url"] as? String, resourceType: RelativePathValues.pdfsPath.rawValue)
            let imageStr = try relativePathForURL(dict["image_url"] as? String, resourceType: RelativePathValues.imagesPath.rawValue)
            let pdfStr = try relativePathForURL(dict["pdf_url"] as? String, resourceType: RelativePathValues.pdfsPath.rawValue)
            
            json.append(bookDictionaryForTitle(dict["title"] as? String, authors: dict["authors"] as? String, tags: dict["tags"] as? String, imageUrl: imageStr, pdfUrl: pdfStr))

        }
        
        let filePath = try PathForFile(FilesName.booksFile.rawValue, directory: nil)
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
        dic["title"] = title
    }
    if let authors = authors {
        dic["authors"] = authors
    }
    if let tags = tags {
        dic["tags"] = tags
    }
    if let imageUrl = imageUrl {
        dic["image_url"] = imageUrl
    }
    if let pdfUrl = pdfUrl {
        dic["pdf_url"] = pdfUrl
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
