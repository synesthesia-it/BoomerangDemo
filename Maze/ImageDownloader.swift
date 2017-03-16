//
//  Image.swift
//  Maze
//
//  Created by Cristian Bellomo on 16/03/2017.
//  Copyright © 2017 Cristian Bellomo. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Gloss
import AlamofireImage

struct SYNImageDownloader {
    
    private static let downloader = {
        // AlamofireImage's downloader
        return ImageDownloader()
    }()
    
    static func download(from urlString: String?) -> Observable<UIImage?> {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return .just(nil)
        }
        return SYNImageDownloader.download(url)
    }
    
    static func  download(_ url: URL) -> Observable<UIImage?> {
        return Observable.create { observer in
            let urlRequest = URLRequest(url: url)
            let receipt = downloader.download(urlRequest) { response in
                if let error =  response.result.error {
                    observer.onError(error)
                }
                if let image = response.result.value {
                    observer.onNext(image)
                    observer.onCompleted()
                }
            }
            return Disposables.create {
                if receipt != nil {
                    downloader.cancelRequest(with: receipt!)
                }
            }
        }
    }
    
}

extension UIImageView {
    
    func download(from urlString: String?) {
    }
    
}
