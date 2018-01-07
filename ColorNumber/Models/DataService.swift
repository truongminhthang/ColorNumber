//
//  DataService.swift
//  ColorNumber
//
//  Created by HoangLuyen on 1/7/18.
//  Copyright © 2018 BigZero. All rights reserved.
//

import Foundation
import UIKit
typealias JSON = Dictionary<String, Any>
class DataService {
    static let shared: DataService = DataService()
    // MARK: - data Paint color
    var _dataPaintColor: [PaintColorPlist]?
    var dataPaintColor: [PaintColorPlist] {
        get {
            if _dataPaintColor == nil {
                loadPaintColor()
            }
            return _dataPaintColor ?? []
        }
        set {
            _dataPaintColor = newValue
        }
    }
    // MARK: - load data from PainColor.Plist
    func loadPaintColor() {
        guard let dictionary = PlistService().getDictionaryFrom(plist: "PaintColor.plist") else { return  }
        guard let paintDictionaries = dictionary["PaintColor"] as? [JSON] else { return  }
        _dataPaintColor = []
        for paintDictionary in paintDictionaries {
            if let paintColor = PaintColorPlist(dictionary: paintDictionary) {
                _dataPaintColor?.append(paintColor)
            }
        }
    }
}
