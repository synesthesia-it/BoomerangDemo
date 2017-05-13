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

final class ShowsViewModel : ListViewModelType, ViewModelTypeSelectable, ViewModelTypeLoadable {
    
    var dataHolder: ListDataHolderType = ListDataHolder()
    var query = Variable("Alias")
    func itemViewModel(fromModel model: ModelType) -> ItemViewModelType? {
        guard let item = model as? TVMaze.Show else {
            return model as? ItemViewModelType
        }
        return ShowItemViewModel(model:item)
    }
    var loading: Observable<Bool> = .just(false)
    lazy var selection:Action<ShowSelectionInput,ShowSelectionOutput> = Action { input in
        switch input {
        case .item(let indexPath):
            guard let model = (self.model(atIndex: indexPath) as? TVMaze.Show) else {
                return .empty()
            }
            //return Observable<ShowSelectionOutput>
            return TVMaze.getShow(id: model.id).flatMapLatest { model -> Observable<ShowSelectionOutput> in
                if let viewModel = ViewModelFactory.showDetailViewModel(of: model) {
                    return .just(.viewModel(viewModel))
                }
                return .empty()
            }
        }
    }
    
    init() {
        let shows =
            self.query.asObservable()
                .throttle(1, scheduler: MainScheduler.instance)
                .flatMapLatest {
                TVMaze.searchShow(withQuery: $0).structured()
            }
        self.dataHolder = ListDataHolder(data: shows)
    }
    
}
