import Foundation
import RxCocoa
import RxSwift
import Action
import Boomerang

typealias Selection = Action<SelectionInput, SelectionOutput>

struct ViewModelFactory {
    
    static func showDetailViewModel(of model: ModelType) -> ViewModelType? {
        switch model {
        case is Show :
            return DetailsViewModel(of: model as! Show)
        
        default : return nil
        }
    }
    
    static func showDetailItemViewModel(withModel model: Show) -> ItemViewModelType {
        return DetailItemViewModel(model: model)
    }
    
    
    static func showDescriptionItemViewModel(withModel model: Show) -> ItemViewModelType {
        return DescriptionItemViewModel(model: model)
    }
    
    static func showsViewModel() -> ViewModelType {
        return ShowsViewModel()
    }
    static func scheduleViewModel() -> ViewModelType {
        return ScheduleViewModel()
    }
    
    static func showItemViewModel(withModel model: Show) -> ItemViewModelType {
        return ShowItemViewModel(model: model)
    }
    
    static func genresViewModel(forShow show: Show) -> ViewModelType {
        return GenresViewModel(withShow:show)
    }
    
    static func genreItemViewModel(withModel model: Genre) -> ItemViewModelType {
        return GenreItemViewModel(model: model)
    }
    
    static func actorItemViewModel(withModel model: Actor) -> ItemViewModelType {
        return ShowActorItemViewModel(model: model)
    }
    
    static func actorsViewModel(forShow show: Show) -> ViewModelType {
        return ShowActorsViewModel(withModel: show)
    }
    
}
