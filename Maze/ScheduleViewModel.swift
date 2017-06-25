//
//  ScheduleViewModel.swift
//  Maze
//
//  Created by Stefano Mondino on 25/06/17.
//  Copyright © 2017 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift
import Boomerang
import Action

enum ScheduleSelectionInput : SelectionInput {
    case item(IndexPath)
}
enum ScheduleSelectionOutput : SelectionOutput {
    case viewModel(ViewModelType)
}

final class ScheduleViewModel : ListViewModelType, ViewModelTypeSelectable {
    var dataHolder: ListDataHolderType = ListDataHolder()
    
    func itemViewModel(fromModel model: ModelType) -> ItemViewModelType? {
        guard let item = model as? Episode else {
            return nil
        }
        return ViewModelFactory.episodeItemViewModel(withModel: item)
    }
    
    lazy var selection : Action<ScheduleSelectionInput,ScheduleSelectionOutput> = Action { input in
        switch input {
        case .item(let indexPath):
            guard let model = (self.model(atIndex:indexPath) as? Episode)?.show else {
                return .empty()
            }
            return TVMaze.getShow(id: model.id).flatMapLatest { model -> Observable<ScheduleSelectionOutput> in
                if let viewModel = ViewModelFactory.showDetailViewModel(of: model) {
                    return .just(.viewModel(viewModel))
                }
                return .empty()
            }
        }
    }
    
    
    init() {
        self.dataHolder = ListDataHolder(data: TVMaze.schedule().map { $0.flatMap { $0}}.structured())
    }
}
