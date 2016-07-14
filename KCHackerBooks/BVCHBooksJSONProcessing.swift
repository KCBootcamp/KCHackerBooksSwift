//
//  BVCBooksJSONProcessing.swift
//  KCHackerBooks
//
//  Created by Bhavish Chandnani on 10/7/16.
//  Copyright © 2016 BVC. All rights reserved.
//

import Foundation
import UIKit
//{
//    "authors": "Scott Chacon, Ben Straub",
//    "image_url": "http://hackershelf.com/media/cache/b4/24/b42409de128aa7f1c9abbbfa549914de.jpg",
//    "pdf_url": "https://progit2.s3.amazonaws.com/en/2015-03-06-439c2/progit-en.376.pdf",
//    "tags": "version control, git",
//    "title": "Pro Git"
//}

//MARK: - Aliases
typealias JSONObject        =   AnyObject
typealias JSONDictionary    =   [String : JSONObject]
typealias JSONArray         =   [JSONDictionary]

//MARK: - Decoding
func decode (hackerBook  json: JSONDictionary) throws -> BVCBook{
    
    //Validation
    let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    
    guard let imageStr = json[Const.Json.imageURLKey] as? String,
        imageUrlStr =  (NSURL (fileURLWithPath: documentsPath).URLByAppendingPathComponent(imageStr)).path,
        image = UIImage(named: imageUrlStr)
    else{
        throw BVCHackersBookErrors.resourcePointedByURLNotReachable
    }

    guard let pdfStr = json[Const.Json.pdfURLKey] as? String,
        urlStr = (NSURL (fileURLWithPath: documentsPath).URLByAppendingPathComponent(pdfStr)).path, url = NSURL(string: urlStr) else{
        throw BVCHackersBookErrors.wrongURLFormatForJSONResource
    }
    
    guard let authors = json[Const.Json.authorsKey] as? String,
    authorsArray : [String]? = convertStringToArray(authors, separator: ", ") else {
            throw BVCHackersBookErrors.wrongJSONFormat
    }
    
    guard let tags = json[Const.Json.tagsKey] as? String,
        tagsArray : [String]? = convertStringToArray(tags, separator: ", ")
        else {
            throw BVCHackersBookErrors.wrongJSONFormat
    }
    
    if let title = json[Const.Json.titleKey] as? String {
        return BVCBook(title: title, authors: authorsArray, tags: tagsArray, image: image, pdfURL: url)
    }else{
        throw BVCHackersBookErrors.wrongJSONFormat
    }
    

}

func decode(hackerBook json: JSONDictionary?) throws -> BVCBook{
    if case .Some(let jsonDict) = json{
        return try decode(hackerBook: jsonDict)
    }else{
        throw BVCHackersBookErrors.nilJSONObject
    }
}
