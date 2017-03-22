import Foundation
import RxCocoa
import RxSwift
import Action
import Boomerang

typealias Selection = Action<SelectionInput, SelectionOutput>

struct ViewModelFactory {
    
    static func showDetailViewModel(of show: TVMaze.Show) -> ViewModelType {
        return DetailsViewModel(of: show)
    }
    
    static func showDetailItemViewModel(withModel model: TVMaze.Show) -> ItemViewModelType {
        return DetailItemViewModel(model: model)
    }
    
    
    static func showDescriptionItemViewModel(withModel model: TVMaze.Show) -> ItemViewModelType {
        return DescriptionItemViewModel(model: model)
    }
    
    static func showsViewModel() -> ViewModelType {
        return ShowsViewModel()
    }
    
    static func showItemViewModel(withModel model: TVMaze.Show) -> ItemViewModelType {
        return ShowItemViewModel(model: model)
    }
    
    static func genresViewModel(forShow show: TVMaze.Show) -> ViewModelType {
        return GenresViewModel(withShow:show)
    }
    
    static func genreItemViewModel(withModel model: Genre) -> ItemViewModelType {
        return GenreItemViewModel(model: model)
    }
    
    static func actorItemViewModel(withModel model: TVMaze.Actor) -> ItemViewModelType {
        return ShowActorItemViewModel(model: model)
    }
    
    static func actorsViewModel(forShow show: TVMaze.Show) -> ViewModelType {
        return ShowActorsViewModel(withModel: show)
    }
    
}
