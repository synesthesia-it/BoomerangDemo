//
//  ShowsViewModel.swift
//  Maze
//
//  Created by Cristian Bellomo on 15/03/2017.
//  Copyright © 2017 Cristian Bellomo. All rights reserved.
//

import Foundation
import RxSwift
import Action
import Boomerang

enum ShowSelectionInput : SelectionInput {
    case item(IndexPath)
}

enum ShowSelectionOutput : SelectionOutput {
    case viewModel(ViewModelType)
}

final class ShowsViewModel : ListViewModelType, ViewModelTypeSelectable {
    
    var dataHolder: ListDataHolderType = ListDataHolder()
    
    func itemViewModel(fromModel model: ModelType) -> ItemViewModelType? {
        guard let item = model as? TVMaze.Show else {
            return model as? ItemViewModelType
        }
        return ShowItemViewModel(model:item)
    }
    
    lazy var selection:Action<ShowSelectionInput,ShowSelectionOutput> = Action { input in
        switch input {
        case .item(let indexPath):
            guard let model = (self.model(atIndex: indexPath) as? TVMaze.Show) else {
                return .empty()
            }
            //return Observable<ShowSelectionOutput>
            return TVMaze.getShow(id: model.id).flatMapLatest { model in
                return Observable<ShowSelectionOutput>.just(.viewModel(ViewModelFactory.showDetailViewModel(of: model)))
            }
        }
    }
    
    init() {
        let shows = TVMaze.searchShow(withQuery: "Alias").structured()
        self.dataHolder = ListDataHolder(data: shows)
    }
    
}
