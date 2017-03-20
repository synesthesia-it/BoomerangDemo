//
//  ShowsViewController.swift
//  Maze
//
//  Created by Cristian Bellomo on 15/03/2017.
//  Copyright © 2017 Cristian Bellomo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Boomerang
import Action

class ShowsViewController : UIViewController, ViewModelBindable, ViewControllerActionBindable,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: ShowsViewModel?
    
    var flow:UICollectionViewFlowLayout? {
        return self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TV Shows"
    }
    
    func bindTo(viewModel: ViewModelType?) {
        guard let viewModel = viewModel as? ShowsViewModel else { return }
        
        self.viewModel = viewModel
        self.collectionView.bindTo(viewModel:viewModel)
        self.collectionView.delegate = self
        self.bindTo(action: viewModel.selection).addDisposableTo(self.disposeBag)
        viewModel.selection.elements.subscribe(onNext: { selection in
            switch selection {
            case .viewModel(let viewModel):
                Router.from(self, viewModel: viewModel).execute()
            }
        }).addDisposableTo(self.disposeBag)
        
        viewModel.reload()
        
//        LocationManager.locationUpdates
//            .take(10)
//            .takeUntil(viewModel.selection.elements)
//            .subscribe(onNext: { _ in print("!") })
//            .addDisposableTo(self.disposeBag)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.autosizeItemAt(indexPath: indexPath, itemsPerLine: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel?.selection.execute(.item(indexPath))
    }

    
}
