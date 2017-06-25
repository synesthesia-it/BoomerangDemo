//
//  DetailsViewController.swift
//  Maze
//
//  Created by Synesthesia on 21/03/2017.
//  Copyright © 2017 Synesthesia. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Boomerang

class DetailsLayout : UICollectionViewFlowLayout {
    class DecorationView : UICollectionReusableView {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.isOpaque = false
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            self.isOpaque = false
            
        }
        override func draw(_ rect: CGRect) {
            let path = UIBezierPath()
            path.move(to: rect.origin)
            path.addLine(to: CGPoint(x: rect.origin.x + rect.width, y: rect.origin.y + 40))
            path.addLine(to: CGPoint(x: rect.origin.x + rect.width, y: rect.origin.y + rect.height))
            path.addLine(to: CGPoint(x: rect.origin.x , y: rect.origin.y + rect.height))
//            path.addLine(to: CGPoint(x: rect.origin.x , y: rect.origin.y ))
            path.close()
            UIColor(red: 241/255.0, green: 241/255.0, blue: 241/255.0, alpha: 1).setFill()
            path.fill()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override init() {
        super.init()
        self.commonInit()
    }
    
    func commonInit() {
        self.register(DecorationView.self, forDecorationViewOfKind: "DecorationView")
    }
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    var proportions:CGFloat = 0.65
    override var collectionViewContentSize: CGSize {
        let padding = (collectionView?.frame.size.width ?? 0) * proportions
        var size = super.collectionViewContentSize
        size.height += padding
        return size
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let padding = (collectionView?.frame.size.width ?? 0) * proportions
        let rect = rect.insetBy(dx: 0, dy: -padding)
        guard let attributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        
        let poster = self.layoutAttributesForSupplementaryView(ofKind: CellType.poster
            .name, at: IndexPath(item: 0, section: 0))
        
        let scroll = self.collectionView?.contentOffset.y ?? 0
        
        let normalized =  scroll /  (collectionView?.frame.size.height ?? 0)
        
        let proportional = scroll - normalized * padding - padding/1.5
        poster?.zIndex = -2
        poster?.frame = CGRect(x: 0, y: proportional, width: collectionView!.frame.size.width, height: collectionView!.frame.size.height)
        
        let decoration = UICollectionViewLayoutAttributes(forDecorationViewOfKind: "DecorationView", with: IndexPath(item: 0, section: 0))
        decoration.zIndex = -1
        decoration.frame = CGRect(x: 0, y: padding - 20, width: collectionViewContentSize.width, height: collectionViewContentSize.height)
        
        let finalAttributes =  attributes.map { attr in
            var a = attr
            var frame = a.frame
            frame.origin.y += padding
            a.frame = frame
            return a
            } + [poster,decoration].flatMap {$0}
        return finalAttributes
        }
    var supplementary:[IndexPath:UICollectionViewLayoutAttributes] = [:]
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let item = self.supplementary[indexPath] else {//super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath) else {
            let newItem = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
            supplementary[indexPath] = newItem
            return newItem
        }
        return item
    }
}

class DetailsViewController : UIViewController, ViewModelBindable, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel: DetailsViewModel?
    var flow:UICollectionViewFlowLayout? {
        return self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isHeroEnabled = true
        
       // self.collectionView.heroModifiers = [.cascade(delta: 0.2, direction: .topToBottom, delayMatchedViews: false)]
        self.view.backgroundColor = UIColor.white
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
      //  cell.heroModifiers = [.fade,.cornerRadius(100)]
    }
    func bind(to viewModel: ViewModelType?) {
        guard let viewModel = viewModel as? DetailsViewModel else {
            return
        }
        
        
        self.viewModel = viewModel
        self.collectionView.bind(to:viewModel)
        self.collectionView.delegate = self
        
        self.flow?.sectionHeadersPinToVisibleBounds = false
        self.flow?.sectionFootersPinToVisibleBounds = false
        viewModel.selection.elements.subscribe(onNext:{ selection in
            switch selection {
            case .viewModel(let viewModel):
                Router.from(self,viewModel: viewModel).execute()
            }
        }).addDisposableTo(self.disposeBag)
        viewModel.reload()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8 
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 20, 0, 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
 
        return collectionView.autosizeItemAt(indexPath: indexPath, itemsPerLine: self.viewModel?.itemsPerLine(atIndexPath: indexPath) ?? 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel?.selection.execute(.item(indexPath))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if self.viewModel?.hasHeader(inSection:section) == true {
                return CGSize(width: collectionView.autoWidthForItemAt(indexPath: IndexPath(item: 0, section: section)), height: 60)
        }
        return .zero
    }
    
}
