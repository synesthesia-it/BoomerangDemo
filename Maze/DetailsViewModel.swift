//
//  DetailsViewModel.swift
//  Maze
//
//  Created by Cristian Bellomo on 21/03/2017.
//  Copyright © 2017 Cristian Bellomo. All rights reserved.
//

import Foundation
import RxSwift
import Boomerang
import Action

enum DetailSelectionInput : SelectionInput {
    case item(IndexPath)
}

enum DetailSelectionOutput : SelectionOutput {
    case viewModel(ViewModelType)
}

final class DetailsViewModel : ListViewModelType, ViewModelTypeSelectable, ListViewModelTypeHeaderable {
    
    var dataHolder: ListDataHolderType = ListDataHolder()
    var headerIdentifiers: [ListIdentifier] {
        return [Cell.genre]
    }
    
    func itemViewModel(fromModel model: ModelType) -> ItemViewModelType? {
        if let genre = model as? Genre {
            return ViewModelFactory.genreItemViewModel(withModel: genre)
        }
        if let actor = model as? TVMaze.Actor {
            return ViewModelFactory.actorItemViewModel(withModel: actor)
        }
        return model as? ItemViewModelType
    }
    
    lazy var selection:Action<DetailSelectionInput,DetailSelectionOutput> = Action { input in
        switch input {
        case .item(let indexPath):
            guard let model = (self.model(atIndex: indexPath) as? TVMaze.Show) else {
                return .empty()
            }
            let destinationViewModel = ViewModelFactory.showDetailViewModel(of: model)
            return .just(.viewModel(destinationViewModel))
        }
    }
    
    func hasHeader(inSection section:Int) -> Bool {
        return self.dataHolder.modelStructure.value.children?[section].sectionModel != nil
    }
    
    func itemsPerLine(atIndexPath indexPath:IndexPath) -> Int {
        return indexPath.section == 0 ? 1 : 2
    }
    
    init(of show: TVMaze.Show) {
        let show = TVMaze.getShow(id: show.id).map { show -> ModelStructure in
            let s1 = ModelStructure([ ViewModelFactory.showItemViewModel(withModel: show), ViewModelFactory.showDescriptionItemViewModel(withModel: show)])
            let s2 = ModelStructure([])
            let s3 = ModelStructure(show.genres ?? [ModelType](), sectionModel: "Genres")
            let s4 = ModelStructure(show.actors ?? [ModelType](), sectionModel: "Actors")
            return ModelStructure(children: [s1, s2, s3, s4])
        }
        self.dataHolder = ListDataHolder(data: show)
    }
    
}
