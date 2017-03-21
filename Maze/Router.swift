//
//  Router.swift

//
//  Created by Stefano Mondino on 11/11/16.
//  Copyright © 2016 Stefano Mondino. All rights reserved.
//

import Foundation
import Boomerang
import UIKit
import SafariServices
import MediaPlayer
import AVKit
import RxSwift

@available(iOS 9.0, *)
extension SFSafariViewController {
    class func canOpenURL(URL: URL) -> Bool {
        return URL.host != nil && (URL.scheme == "http" || URL.scheme == "https")
    }
}

internal extension UIViewController {
    func withNavigation() -> NavigationController {
        return NavigationController(rootViewController: self)
    }
}

 extension ViewModelBindable where Self : UIViewController {
    func withViewModel<T:ViewModelBindableType>(_ viewModel:ViewModelType) -> T {
        self.bindTo(viewModel:viewModel, afterLoad: true)
        return self as! T
    }
}

struct Router : RouterType {
    
    public static func exit<Source>(_ source:Source) where Source: UIViewController{
        _ = source.navigationController?.popToRootViewController(animated: true)
    }
    
    public static func dismiss<Source>(_ source:Source) where Source: UIViewController{
        _ = source.dismiss(animated: true, completion: nil)
    }
    
    public static func start(_ delegate: AppDelegate) {
        delegate.window = UIWindow(frame: UIScreen.main.bounds)
        delegate.window?.rootViewController = self.root()
        delegate.window?.makeKeyAndVisible()
        
    }
    
    public static func confirm<Source:UIViewController>(title:String,message:String,confirmationTitle:String, from source:Source, action:@escaping ((Void)->())) -> RouterAction {
        let alert = UIAlertController(title:title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: confirmationTitle, style: .default, handler: {_ in action()}))
        return UIViewControllerRouterAction.modal(source: source, destination: alert, completion: nil)
    }
    
    public static func actions<Source: UIViewController>(fromSource source: Source, item: UIBarButtonItem, actions: [UIAlertAction]) -> RouterAction {
        let alert = UIAlertController(title:nil, message: nil, preferredStyle: .actionSheet)
        actions.forEach { alert.addAction($0) }
        alert.modalPresentationStyle = .popover
        let popover = alert.popoverPresentationController!
        popover.permittedArrowDirections = .up
        popover.barButtonItem = item
        return UIViewControllerRouterAction.modal(source: source, destination: alert, completion: nil)
    }

    
    public static func from<Source> (_ source:Source, viewModel:ViewModelType) -> RouterAction where Source: UIViewController {
        switch viewModel {
        case is ShowActorsViewModel:
            let destination: ShowActorsViewController = Storyboard.main.scene(.actors)
            destination.bindTo(viewModel: viewModel, afterLoad: true)
            return UIViewControllerRouterAction.push(source: source, destination: destination)
        case is DetailsViewModel:
            let destination: DetailsViewController = Storyboard.main.scene(.showDetail)
            destination.bindTo(viewModel: viewModel, afterLoad: true)
            return UIViewControllerRouterAction.push(source: source, destination: destination)
        case is GenresViewModel:
            let destination: GenresViewController = Storyboard.main.scene(.genres)
            destination.bindTo(viewModel: viewModel, afterLoad: true)
            return UIViewControllerRouterAction.push(source: source, destination: destination)
        default:
            return EmptyRouterAction()
        }
    }
    
    public static func open<Source> (_ url:URL?, from source:Source) -> RouterAction
        where Source: UIViewController{
            if url == nil { return EmptyRouterAction() }
            if !SFSafariViewController.canOpenURL(URL: url!) {
                return UIViewControllerRouterAction.custom {
                    UIApplication.shared.openURL(url!)
                }
            }
            let vc = SFSafariViewController(url: url!, entersReaderIfAvailable: true)
            return UIViewControllerRouterAction.modal(source: source, destination: vc, completion: nil)
    }
    
    public static func root() -> UIViewController {
        
        let source:ShowsViewController = (Storyboard.main.scene(.showList) as ShowsViewController)
            .withViewModel(ViewModelFactory.showsViewModel())
       
        
        return source.withNavigation()
    }
    
    public static func rootController() -> UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController
    }
    
    public static func restart() {
        UIApplication.shared.keyWindow?.rootViewController = Router.root()
    }

    public static func openApp<Source> (_ url: URL?, from source: Source) -> RouterAction where Source: UIViewController{
        if url == nil { return EmptyRouterAction() }
        return UIViewControllerRouterAction.custom {
            UIApplication.shared.openURL(url!)
        }
    }
    
    public static func playVideo<Source> (_ url: URL?, from source: Source) -> RouterAction where Source: UIViewController {
            guard let urlFormatted:URL = URL(string:url?.absoluteString.removingPercentEncoding ?? "") else {
                return EmptyRouterAction()
            }

            let playerController = AVPlayerViewController()
            let asset:AVURLAsset = AVURLAsset(url: urlFormatted, options: [:])

            return UIViewControllerRouterAction.modal(source: source, destination: playerController, completion: {
                let playerItem:AVPlayerItem =  AVPlayerItem(asset: asset)
                playerController.player = AVPlayer(playerItem: playerItem)
                playerController.player?.play()
            })
    }
    
}
