//
//  CollectionViewCell.swift
//  
//
//  Created by Stefano Mondino on 07/03/17.
//
//

import UIKit
import Boomerang
import RxSwift
import Action
import RxCocoa

class ShowItemCollectionViewCell: UICollectionViewCell, ViewModelBindable {
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var viewModel: ItemViewModelType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bindTo(viewModel: ViewModelType?) {
        guard let viewModel = viewModel as? ShowItemViewModel else { return }
        self.viewModel = viewModel
        self.lbl_title.text = viewModel.itemTitle
        self.disposeBag = DisposeBag()
        viewModel.image?
            .bindTo(self.imageView.rx.image)
            .addDisposableTo(self.disposeBag)
        //SYNImageDownloader.download(from: viewModel.imageUrl).bindTo(imageView.rx.image).addDisposableTo(disposeBag)
    }
}
