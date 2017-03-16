//
//  UICollectionView.swift
//  Boomerang
//
//  Created by Stefano Mondino on 02/11/16.
//
//

import UIKit
import RxCocoa
import RxSwift


public extension UICollectionReusableView {
    
    public var isPlaceholder:Bool {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.isPlaceholder) as? Bool ?? false}
        set { objc_setAssociatedObject(self, &AssociatedKeys.isPlaceholder, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }
}

private class ViewModelCollectionViewDataSource : NSObject, UICollectionViewDataSource {
    weak var viewModel: ListViewModelType?
    init (viewModel: ListViewModelType) {
        super.init()
        self.viewModel = viewModel
        
    }
    @objc public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell  {
        let viewModel:ItemViewModelType? = self.viewModel?.viewModel(atIndex:indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel?.itemIdentifier.name ?? defaultListIdentifier, for: indexPath)
        (cell as? ViewModelBindableType)?.bindTo(viewModel:viewModel)
        return cell
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        let count =  self.viewModel?.dataHolder.modelStructure.value.children?.count ?? 1
        return count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count =  self.viewModel?.dataHolder.modelStructure.value.children?[section].models?.count
        count =  count ?? self.viewModel?.dataHolder.modelStructure.value.models?.count
        return count ?? 0
    }
    
    @objc public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let model = self.viewModel?.dataHolder.modelStructure.value.sectionModelAtIndexPath(indexPath)//self.viewModel?.dataHolder.models.value.children?[indexPath.section].sectionModel
        if nil != model {
            
            let viewModel =  self.viewModel?.itemViewModel(fromModel: model!)
            if (viewModel != nil) {
                let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: viewModel!.itemIdentifier.name, for: indexPath)
                (cell as? ViewModelBindableType)?.bindTo(viewModel:viewModel)
                return cell
            }
        }
        
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: EmptyReusableView.emptyReuseIdentifier, for: indexPath)
    }
    struct StaticCellParameters {
        var constraint:NSLayoutConstraint!
        var cell:UICollectionViewCell!
    }
    
    
    
    var staticCells = [String:StaticCellParameters]()
    
    func staticCellForSizeAtIndexPath (_ indexPath:IndexPath ,width:Float) -> UICollectionViewCell?{
        
        guard let nib = self.viewModel?.identifier(atIndex:indexPath) else {
            return nil
        }
        
        var parameters = self.staticCells[nib.name]
        
        if (parameters == nil) {
            guard let cell = Bundle.main.loadNibNamed(nib.name, owner: self, options: [:])!.first as? UICollectionViewCell else {
                return nil
            }
            cell.contentView.translatesAutoresizingMaskIntoConstraints = false
            let constraint = NSLayoutConstraint(
                item: cell.contentView,
                attribute: .width,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1.0,
                constant: CGFloat(width))
            cell.contentView.addConstraint(constraint)
            cell.isPlaceholder = true
            parameters = StaticCellParameters(constraint: constraint, cell:cell)
            
        }
        
        parameters!.constraint?.constant = CGFloat(width)
        (parameters!.cell as? ViewModelBindableType)?.bindTo(viewModel:self.viewModel?.viewModel(atIndex:indexPath))
        //        self.bindViewModelToCellAtIndexPath(parameters!.cell, indexPath: indexPath, forResize: true)
        var newCells = staticCells
        newCells[nib.name] = parameters
        
        self.staticCells = newCells
        return parameters?.cell
        
    }
    
    func autoSizeForItemAtIndexPath(_ indexPath:IndexPath, width:Float) -> CGSize {
        let cell = self.staticCellForSizeAtIndexPath(indexPath, width: width)
        cell?.contentView.setNeedsLayout()
        cell?.contentView.layoutIfNeeded()
        let size = cell?.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize) ?? CGSize.zero
        return size
    }
    
}
private struct AssociatedKeys {
    static var viewModel = "viewModel"
    static var disposeBag = "disposeBag"
    static var isPlaceholder = "isPlaceholder"
    static var collectionViewDataSource = "collectionViewDataSource"
}
public extension ListViewModelType  {
    
    var collectionViewDataSource:UICollectionViewDataSource? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.collectionViewDataSource) as? UICollectionViewDataSource}
        set { objc_setAssociatedObject(self, &AssociatedKeys.collectionViewDataSource, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }
}

fileprivate class EmptyReusableView : UICollectionViewCell {
    fileprivate static let emptyReuseIdentifier = "_emptyReusableView"
}
extension UICollectionView : ViewModelBindable {
    
    public var viewModel: ViewModelType? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.viewModel) as? ViewModelType}
        set { objc_setAssociatedObject(self, &AssociatedKeys.viewModel, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }
    
    public var disposeBag: DisposeBag {
        get {
            var disposeBag: DisposeBag
            
            if let lookup = objc_getAssociatedObject(self, &AssociatedKeys.disposeBag) as? DisposeBag {
                disposeBag = lookup
            } else {
                disposeBag = DisposeBag()
                objc_setAssociatedObject(self, &AssociatedKeys.disposeBag, disposeBag, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            
            return disposeBag
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.disposeBag, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func bindTo(viewModel: ViewModelType?) {
        guard let viewModel = viewModel as? ListViewModelType else {
            self.viewModel = nil
            return
        }
        self.viewModel = viewModel
        
        let collectionView = self
        _ = viewModel.listIdentifiers.map { $0.name}.reduce("", { (_, value) in
            collectionView.register(UINib(nibName: value, bundle: nil), forCellWithReuseIdentifier: value)
            return ""
        })
        _ = (viewModel as? ListViewModelTypeHeaderable)?.headerIdentifiers.reduce("", { (_, value) in
            
            collectionView.register(UINib(nibName: value.name, bundle: nil), forSupplementaryViewOfKind: value.type?.name ?? UICollectionElementKindSectionHeader, withReuseIdentifier: value.name)
            return ""
        })
        
        collectionView.register(EmptyReusableView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader , withReuseIdentifier: EmptyReusableView.emptyReuseIdentifier)
        collectionView.register(EmptyReusableView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionFooter , withReuseIdentifier: EmptyReusableView.emptyReuseIdentifier)
        if (viewModel.collectionViewDataSource == nil) {
            viewModel.collectionViewDataSource = ViewModelCollectionViewDataSource(viewModel: viewModel)
        }
        self.dataSource = viewModel.collectionViewDataSource
        
        viewModel
            .dataHolder
            .reloadAction
            .elements
            .subscribe(onNext:{ _ in collectionView.reloadData() })
            .addDisposableTo(self.disposeBag)
        
        if (collectionView.backgroundView != nil) {
            viewModel.isEmpty.asObservable().map{!$0}.bindTo(collectionView.backgroundView!.rx.isHidden).addDisposableTo(self.disposeBag)
        }
    }
    public func autosizeItemAt(indexPath:IndexPath, constrainedToWidth width:Float) -> CGSize {
        guard let viewModel = viewModel as? ListViewModelType else {
            return .zero
        }
        guard let dataSource = viewModel.collectionViewDataSource as? ViewModelCollectionViewDataSource else {
            return .zero
        }
        return dataSource.autoSizeForItemAtIndexPath(indexPath, width: width)
    }
    public func autosizeItemAt(indexPath:IndexPath, itemsPerLine:Int = 1) -> CGSize {
        guard let flow = self.collectionViewLayout as? UICollectionViewFlowLayout else {
            return self.autosizeItemAt(indexPath: indexPath, constrainedToWidth: Float(self.frame.size.width))
        }
        let flowDelegate = self.delegate as? UICollectionViewDelegateFlowLayout
        let insets =  flowDelegate?.responds(to:#selector(UICollectionViewDelegateFlowLayout.collectionView(_:layout:insetForSectionAt:))) == true ? flowDelegate!.collectionView!(self, layout: flow, insetForSectionAt: indexPath.section) : flow.sectionInset
        
        let spacing =  flowDelegate?.responds(to:#selector(UICollectionViewDelegateFlowLayout.collectionView(_:layout:minimumInteritemSpacingForSectionAt:))) == true ? flowDelegate!.collectionView!(self, layout: flow, minimumInteritemSpacingForSectionAt: indexPath.section) : flow.minimumInteritemSpacing
        
        
        let globalWidth = self.frame.size.width - insets.left - insets.right - self.contentInset.left - self.contentInset.right
        
        let singleWidth = (CGFloat(globalWidth) - (CGFloat(max(0,itemsPerLine - 1)) * spacing)) / CGFloat(max(itemsPerLine,1))
        return self.autosizeItemAt(indexPath: indexPath, constrainedToWidth: floor(Float(singleWidth)))
        
    }
}
