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
    case genres = "genres"
    var name: String { return self.rawValue }
    var type: String? { return nil }
}

extension ListViewModelType {
    var listIdentifiers: [ListIdentifier] { return Cell.all() }
}

enum Cell: String, ListIdentifier {
    case showItem = "ShowItemCollectionViewCell"
    case genre = "GenreItemCollectionViewCell"
    static func all() -> [Cell] {
        return [
            .showItem,
            .genre
        ]
    }
    
    static func headers() -> [Cell] {
        return self.all().filter{ $0.type == UICollectionElementKindSectionHeader}
    }
    
    var name: String { return self.rawValue }
    var type: String? { return nil }
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
