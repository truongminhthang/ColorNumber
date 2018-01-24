//
//  VideoExportServiceDelegate.swift
//  MGAnimation
//
//  Created by Admin on 1/18/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

protocol VideoExportServiceDelegate: class {
    func videoExportServiceExportSuccess()
    func videoExportServiceExportFailedWithError(error: NSError)
    func videoExportServiceExportProgress(progress: Float)
}

