//
//  DetailsViewController.swift
//  Maze
//
//  Created by Cristian Bellomo on 21/03/2017.
//  Copyright © 2017 Cristian Bellomo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Boomerang


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
        self.collectionView.contentInset = UIEdgeInsetsMake(40, 20, 40, 20)
        self.flow?.sectionHeadersPinToVisibleBounds = true
        self.flow?.sectionFootersPinToVisibleBounds = true
        viewModel.selection.elements.subscribe(onNext:{ selection in
            switch selection {
            case .viewModel(let viewModel):
                Router.from(self,viewModel: viewModel).execute()
            }
        }).addDisposableTo(self.disposeBag)
        viewModel.reload()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.autosizeItemAt(indexPath: indexPath, itemsPerLine: self.viewModel?.itemsPerLine(atIndexPath: indexPath) ?? 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel?.selection.execute(.item(indexPath))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if self.viewModel?.hasHeader(inSection:section) == true {
                return CGSize(width: 199, height: 60)
        }
        return .zero
    }
    
}
