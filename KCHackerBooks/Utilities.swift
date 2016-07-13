//
//  Utilities.swift
//  KCHackerBooks
//
//  Created by Bhavish Chandnani on 13/7/16.
//  Copyright © 2016 BVC. All rights reserved.
//

import Foundation


//MARK: - String and Array Utilities
func convertStringToArray (string : String, separator: String) -> [String]{
    return string.componentsSeparatedByString(separator)
}


//MARK: - Path and URL Utilities
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

func createDirectory(directory: String) throws-> String{
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

func relativePathForURL(url : String?, resourceType: String) throws -> String?{
    if let path = try? createDirectory(resourceType), urlComponents  = url?.componentsSeparatedByString("/"), lastComponent = urlComponents.last{
        let url = NSURL (fileURLWithPath: path).URLByAppendingPathComponent(lastComponent, isDirectory: false)
        
        return url.relativePath
    }else{
        throw BVCHackersBookErrors.urlConversionError
    }
    
}
