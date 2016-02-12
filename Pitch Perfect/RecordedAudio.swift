//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Yu Qi Hao on 1/26/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}
