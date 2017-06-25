//
//  EpisodeItemViewModel.swift
//  Maze
//
//  Created by Stefano Mondino on 25/06/17.
//  Copyright © 2017 Cristian Bellomo. All rights reserved.
//

import Foundation
import RxSwift
import Boomerang

final class EpisodeItemViewModel : ItemViewModelType {
    var model:ItemViewModelType.Model
    var itemIdentifier:ListIdentifier = Cell.episode
    var title:String?
    var subtitle:String?
    var poster:ObservableImage
    init(model: Episode) {
        self.model = model
        self.subtitle = model.title
        self.title = model.show?.name
        poster = model.show?.thumbnail?.get().shareReplay(1) ?? .just(nil)
    }
}
