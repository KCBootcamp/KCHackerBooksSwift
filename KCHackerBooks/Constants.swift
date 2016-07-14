//
//  Constants.swift
//  KCHackerBooks
//
//  Created by Bhavish Chandnani on 11/7/16.
//  Copyright © 2016 BVC. All rights reserved.
//

import Foundation

struct Const {
    
    struct App {
        static let appName      =   "Geek Reader"
    }
    struct UserDefaultKeys {
        static let jsonFile     =   "json"
    }
    struct RelativePathValues{
        static let imagesPath   =   "images/"
        static let pdfsPath     =   "pdfs/"
    }
    
    struct FilesName {
        static let booksFile    =   "books_readable.json"
        
    }
    
    struct DownloadUrls {
        static let jsonUrl  =   "https://t.co/K9ziV0z3SJ"
    }
    struct Json {
        static let titleKey     =   "title"
        static let authorsKey   =   "authors"
        static let tagsKey      =   "tags"
        static let imageURLKey  =   "image_url"
        static let pdfURLKey    =   "pdf_url"
    }
    
}
