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

struct Image: Decodable, ImageType {
    
    static let downloader = {
        return ImageDownloader()
    }()
    
    static func  download(url:String?) -> Observable<UIImage?> {
        guard let url = url else {
            return .just(nil)
        }
        return Observable.create({ observer in
            if let url = URL(string: url) {
                let urlRequest = URLRequest(url: url)
                let receipt = downloader.download(urlRequest, completion: { response in
                    if let error =  response.result.error{
                        observer.onError(error)
                    }
                    if let image = response.result.value {
                        observer.onNext(image)
                        observer.onCompleted()
                    }
                    
                })
                return Disposables.create {
                    if receipt != nil {
                        downloader.cancelRequest(with: receipt!)
                    }
                }
            }
            return Disposables.create()
        })
    }
    let medium: String?
    let original: String?
    
    func get() -> Observable<UIImage?> {
        return Image.download(url: medium)
    }
    
    init(json: JSON) {
        self.medium = "medium" <~~ json
        self.original = "original" <~~ json
    }
    
}

protocol ImageType {
    func get() -> Observable<UIImage?>
}

extension UIImage: ImageType {
    
    func get() -> Observable<UIImage?> {
        return .just(self)
    }
    
}
