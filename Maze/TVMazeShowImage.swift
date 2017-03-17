//
//  TVMazeShowImage.swift
//  Maze
//
//  Created by Cristian Bellomo on 16/03/2017.
//  Copyright © 2017 Cristian Bellomo. All rights reserved.
//

import Foundation
import Gloss
import RxSwift

extension TVMaze {

    struct ShowImage:  ObservableImageType {
        
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

}
