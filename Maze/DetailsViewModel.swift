//
//  DetailsViewModel.swift
//  Maze
//
//  Created by Synesthesia on 21/03/2017.
//  Copyright © 2017 Synesthesia. All rights reserved.
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

final class DetailsViewModel : ListViewModelType, ViewModelTypeSelectable, ListViewModelTypeSectionable {
    
    var dataHolder: ListDataHolderType = ListDataHolder()
    var sectionIdentifiers: [ListIdentifier] {
        return [Cell.genre, Cell.poster]
    }
    
    func itemViewModel(fromModel model: ModelType) -> ItemViewModelType? {
        switch model {
        case let season as Season:
            return ViewModelFactory.posterItem(for: season.thumbnail)
        case let genre  as Genre :
            return ViewModelFactory.genreItemViewModel(withModel: genre)
        case let actor as Actor :
            return ViewModelFactory.actorItemViewModel(withModel: actor)
        default:
        return model as? ItemViewModelType
        }
    }
    
    lazy var selection:Action<DetailSelectionInput,DetailSelectionOutput> = Action { input in
        switch input {
        case .item(let indexPath):
            guard let model = self.model(atIndex: indexPath)  else {
                return .empty()
            }
            if let destinationViewModel = ViewModelFactory.showDetailViewModel(of: model) {
                return .just(.viewModel(destinationViewModel))
            }
            return .empty()
        }
    }
    
    func hasHeader(inSection section:Int) -> Bool {
        if section == 0 { return false }
        return self.dataHolder.modelStructure.value.children?[section].sectionModel != nil
    }
    
    func itemsPerLine(atIndexPath indexPath:IndexPath) -> Int {
        //return indexPath.section == 0 ? 1 : 2
        if model(atIndex: indexPath) is Season {
            return 5
        }
        return 1
    }

    init(of show: Show) {
        let show = Observable.just(show).map { show -> ModelStructure in
            let main = ModelStructure([
                ViewModelFactory.showTitleItemViewModel(withModel: show),
                ViewModelFactory.showDescriptionItemViewModel(withModel: show)], sectionModel:ViewModelFactory.posterItem(for:show.poster))
            
            
            let seasons = ModelStructure(["Seasons"] + (show.seasons ?? [ModelType]()))
            
            let cast = ModelStructure(["Characters"] + (show.actors ?? [ModelType]()))
            return ModelStructure(children: [main, seasons, cast])
        }
        self.dataHolder = ListDataHolder(data: show)
    }
    
}
