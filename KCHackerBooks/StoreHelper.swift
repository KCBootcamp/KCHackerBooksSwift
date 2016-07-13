//
//  StoreHelper.swift
//  KCHackerBooks
//
//  Created by Bhavish Chandnani on 11/7/16.
//  Copyright © 2016 BVC. All rights reserved.
//

import Foundation


func loadJSONFromLocalFile(path: String) throws -> JSONArray {
   
    if let data =  NSData(contentsOfFile: path){
        return try convertDataToJSONArray(data)
    }else{
        throw BVCHackersBookErrors.jsonParsingError
    }
}

func convertDataToJSONArray(data: NSData) throws -> JSONArray{
    if let maybeArray = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? JSONArray,
        array = maybeArray{
        return array
        
    }else{
        throw BVCHackersBookErrors.jsonParsingError
    }
}


func DownloadJSON() throws -> JSONArray {
    
    //TODO change to NSURLRequest and NSURLConnection with asynchronous download (completion block)
    do{
        let data =  try NSData(contentsOfURL: NSURL(string:  DownloadUrls.jsonUrl.rawValue)!, options: NSDataReadingOptions())
    
        let jsonArray = try convertDataToJSONArray(data)
        var json : JSONArray = []
        
        for var dict in jsonArray{
             DownloadResource(dict["image_url"] as? String, resourceType: RelativePathValues.imagesPath.rawValue)
             DownloadResource(dict["pdf_url"] as? String, resourceType: RelativePathValues.pdfsPath.rawValue)
            let imageStr = try localRelativeURLForURL(dict["image_url"] as? String, resourceType: RelativePathValues.imagesPath.rawValue)
            let pdfStr = try localRelativeURLForURL(dict["pdf_url"] as? String, resourceType: RelativePathValues.pdfsPath.rawValue)
            
            json.append(bookDictionary(dict["title"] as? String, authors: dict["authors"] as? String, tags: dict["tags"] as? String, imageUrl: imageStr, pdfUrl: pdfStr))

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
        data =  try? NSData(contentsOfURL: url, options: NSDataReadingOptions()), relativePath = try localRelativeURLForURL(url.absoluteString, resourceType: resourceType),
        filePath = localUrl.URLByAppendingPathComponent(relativePath).path
          {
        data.writeToFile(filePath, atomically: true)
    }
        
    }catch{
        print("Error al descargar \(resourceUrl)")

    }
    
    
    
}

func PathForFile(fileName: String, directory: String?) throws-> String{
    var documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    if let directory = directory {
        documentsPath.appendContentsOf(directory)
    }
    let url = NSURL(fileURLWithPath: documentsPath)
    
    guard let filePath = url.URLByAppendingPathComponent(fileName).path else{
        throw BVCHackersBookErrors.resourcePointedByURLNotReachable
    }
    return filePath
}

func PathForDirectory(directory: String) throws-> String{
    let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    let url = NSURL(fileURLWithPath: documentsPath)
    if let directoryPath = url.URLByAppendingPathComponent(directory).path {
        if NSFileManager.defaultManager().fileExistsAtPath(directoryPath)==false {
        try NSFileManager.defaultManager().createDirectoryAtPath(directoryPath, withIntermediateDirectories: true, attributes: nil)
        }
        return directory
    }else{
        
        throw BVCHackersBookErrors.wrongPath
        
    }
}

func localRelativeURLForURL(url : String?, resourceType: String) throws -> String?{
    if let path = try? PathForDirectory(resourceType), urlComponents  = url?.componentsSeparatedByString("/"), lastComponent = urlComponents.last{
        let url = NSURL (fileURLWithPath: path).URLByAppendingPathComponent(lastComponent, isDirectory: false)
        
        return url.relativePath
    }else{
        throw BVCHackersBookErrors.urlConversionError
    }
    
}


func bookDictionary (title:String?, authors:String?, tags:String?, imageUrl: String?, pdfUrl: String?)->JSONDictionary{
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

//func dataOfType(resourceType: String, url: NSURL) throws -> NSData{
//    switch resourceType {
//    case RelativePathValues.imagesPath.rawValue:
//        
//    default:
//        return try NSData(contentsOfURL: url, options: NSDataReadingOptions())
//    }
//}
