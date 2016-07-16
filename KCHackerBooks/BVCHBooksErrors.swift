//
//  Errors.swift
//  KCHackerBooks
//
//  Created by Bhavish Chandnani on 10/7/16.
//  Copyright © 2016 BVC. All rights reserved.
//

import Foundation
enum BVCHackersBookErrors : ErrorType {
    case wrongURLFormatForJSONResource
    case resourcePointedByURLNotReachable
    case jsonParsingError
    case wrongJSONFormat
    case nilJSONObject
    case wrongPath
    case urlConversionError
    case downloadError
    case arrayCreationError
    case resourceNotFound
}