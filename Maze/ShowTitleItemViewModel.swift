//
//  ShowTitleItemViewModel.swift
//  Maze
//
//  Created by Stefano Mondino on 25/06/17.
//  Copyright © 2017 Cristian Bellomo. All rights reserved.
//

import Foundation
import RxSwift
import Boomerang

final class ShowTitleItemViewModel : ItemViewModelType {
    var model:ItemViewModelType.Model
    var itemIdentifier:ListIdentifier = Cell.showTitle
    var title:String?
    var description:String?
    init(model: Show) {
        self.model = model
        self.title = model.name
        self.description = [model.genres?.first, model.year].flatMap {$0}.joined(separator:", ")
    }
}
