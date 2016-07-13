//
//  Constants.swift
//  KCHackerBooks
//
//  Created by Bhavish Chandnani on 11/7/16.
//  Copyright © 2016 BVC. All rights reserved.
//

import Foundation

enum UserDefaultKeys: String{
    case jsonFile = "json"
}

enum RelativePathValues: String {
    case imagesPath = "images/"
    case pdfsPath = "pdfs/"
}

enum FilesName: String {
    case booksFile = "books_readable.json"
    case appName = "Geek Reader"
}

enum DownloadUrls:  String {
    case jsonUrl = "https://t.co/K9ziV0z3SJ"
}