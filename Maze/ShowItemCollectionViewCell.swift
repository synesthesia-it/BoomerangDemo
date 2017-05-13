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
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var subtitle: UILabel!
    
    var viewModel: ItemViewModelType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bind(to viewModel: ViewModelType?) {
        guard let viewModel = viewModel as? ShowItemViewModel else { return }
        self.viewModel = viewModel
        self.title.text = viewModel.itemTitle
        self.subtitle.text = viewModel.description
        self.disposeBag = DisposeBag()
        viewModel.image?
            .bindTo(self.thumbnail.rx.image)
            .addDisposableTo(self.disposeBag)
        //SYNImageDownloader.download(from: viewModel.imageUrl).bindTo(imageView.rx.image).addDisposableTo(disposeBag)
        thumbnail.heroID = "showThumbnail_\(viewModel.id)"
    }
}
