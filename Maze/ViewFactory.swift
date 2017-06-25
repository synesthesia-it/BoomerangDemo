import UIKit
import Boomerang

enum Storyboard : String {
    case main = "Main"
    
    func scene<Type: UIViewController>(_ identifier: SceneIdentifier) -> Type {
        return UIStoryboard(name: self.rawValue, bundle: nil).instantiateViewController(withIdentifier: identifier.rawValue).setup() as! Type
    }
}

enum SceneIdentifier : String, ListIdentifier {
    case showList = "list"
    case showDetail = "showDetail"
    case genres = "genres"
    case actors = "actors"
    case schedule = "schedule"
    var name: String { return self.rawValue }
    var type: String? { return nil }
}

extension ListViewModelType {
    var listIdentifiers: [ListIdentifier] { return Cell.all() }
}
enum CellType : String, ListIdentifier {
    case poster = "poster"
     var name: String { return self.rawValue }
    var type: String? { return nil }
    var isEmbeddable: Bool { return false}
}
enum Cell: String, ListIdentifier {
    case showItem = "ShowItemCollectionViewCell"
    case actorItem = "ShowActorItemCollectionViewCell"
    case genre = "GenreItemCollectionViewCell"
    case summary = "DescriptionItemCollectionViewCell"
    case episode = "EpisodeItemView"
    case poster = "PosterItemView"
    case showTitle = "ShowTitleItemView"
    static func all() -> [Cell] {
        return [
            .showItem,
            .actorItem,
            .summary,
            .genre,
            .episode,
            .poster,
            .showTitle
        ]
    }
    
    static func headers() -> [Cell] {
        return self.all().filter{ $0.type == UICollectionElementKindSectionHeader}
    }
    
    var name: String { return self.rawValue }
    var isEmbeddable: Bool {
        switch self {
        case .episode, .poster, .showTitle : return true
        default : return false
        }
    }
    var type: String? {
        switch self {
        case .poster : return CellType.poster.name
        case .genre : return UICollectionElementKindSectionHeader
        default : return nil
        }
    }
}

enum View: String {
    case filtersView = "FiltersView"
    
    var loadView:UIView?  {
        return Bundle.main.loadNibNamed(self.rawValue, owner: nil, options: nil)?.first as? UIView
    }
}

extension Cell {
    func cell<T: UICollectionViewCell>() -> T {
        return UINib(nibName: self.rawValue, bundle: nil).instantiate(withOwner: nil, options: nil).first as! T
    }
}
