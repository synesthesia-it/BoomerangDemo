//
//  TVMazeShowImage.swift
//  Maze
//
//  Created by Synesthesia on 16/03/2017.
//  Copyright © 2017 Synesthesia. All rights reserved.
//

import Foundation
import Gloss
import RxSwift
import Boomerang


class Image:  ObservableImageType, ModelType {
    static var empty = Image(path: "")
    let path: String
    
    init(path: String) {
        self.path = path
    }
    
    init(url: URL) {
        self.path = url.absoluteString
    }
    
    func get() -> Observable<UIImage?> {
        return ImageDownloader.download(from: self.path)
    }
    
}


