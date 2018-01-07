//
//  PlistService.swift
//  ColorNumber
//
//  Created by HoangLuyen on 1/7/18.
//  Copyright © 2018 BigZero. All rights reserved.
//

import Foundation

class PlistService {
    func getDictionaryFrom(plist: String) -> JSON? {
        var result: JSON?
        let fileNameComponents = plist.components(separatedBy: ".")
        guard let filePath = Bundle.main.path(forResource: fileNameComponents.first ?? "", ofType: fileNameComponents.last ?? "") else {return nil}
        guard FileManager.default.fileExists(atPath: filePath) == true else {return nil}
        guard let data = FileManager.default.contents(atPath: filePath) else { return nil }
        do {
            guard let root = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? JSON else { return nil }
            result = root
        }
        catch {
            print("Error: PropertyListSerialization error")
        }
        return result
    }
}
