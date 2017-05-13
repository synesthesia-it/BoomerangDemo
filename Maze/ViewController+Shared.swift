//
//  ViewController.swift
//  ZiaMaria
//
//  Created by Stefano Mondino on 24/11/16.
//  Copyright © 2016 Synesthesia. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Action
import Boomerang
import UIKit
import pop
import MBProgressHUD
import SpinKit
import Localize_Swift
import AVKit

enum SharedSelectionOutput : SelectionOutput {
    case exit
    case dismiss
    case restart
    case url(URL?)
    case preview(URL?)
    case playVideo(URL?)
    case confirm(title: String, message: String, confirmTitle: String, action: ((Void)->()))
}

class NavigationController: UINavigationController, UINavigationBarDelegate {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            return .landscape
        default:
            return .portrait
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
}

extension UIView {
    func findFirstResponder() -> UIView? {
        if self.isFirstResponder { return self }
        if self.subviews.count == 0 { return nil }
        return self.subviews.map { $0.findFirstResponder() ?? self }.filter { $0 != self }.first
    }
}

protocol KeyboardResizable  {
    var bottomConstraint:NSLayoutConstraint! { get set }
    var scrollView:UIScrollView {get}
    var keyboardResize: Observable<CGFloat> { get }
}

extension KeyboardResizable where Self: UIViewController {
    
    var keyboardResize: Observable<CGFloat>  {
        self.scrollView.keyboardDismissMode = .onDrag
        let original:CGFloat = self.bottomConstraint.constant
        var currentBottomSpace:CGFloat = 0.0
        let willShow = NotificationCenter.default.rx.notification(NSNotification.Name.UIKeyboardWillShow)
        let willHide = NotificationCenter.default.rx.notification(NSNotification.Name.UIKeyboardWillHide)
        let merged = Observable.of(willShow,willHide).merge()
        
        let vc = self as UIViewController
        return
            merged
                .takeUntil(vc.rx.deallocating)
                .throttle(0.1, scheduler:MainScheduler.instance)
                .scan(self.bottomConstraint.constant, accumulator: {[weak self] (value:CGFloat, notification:Notification) -> CGFloat in
                    if self == nil {
                        return 0
                    }
                    let isShowing = notification.name == .UIKeyboardWillShow
                    currentBottomSpace = isShowing ? self!.finalConstraintValueValueForKeyboardOpen(frame: (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? CGRect(x:0,y:0,width:0,height:0) ) : original
                    
                    let duration:Double = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double ?? 0.25
                    
                    
                    let animation = POPBasicAnimation(propertyNamed: kPOPLayoutConstraintConstant)!
                    animation.duration = duration
                    animation.toValue = currentBottomSpace
                    animation.completionBlock = { animation, completed in
                        if completed {
                            let view = self?.scrollView.findFirstResponder()
                            if view != nil {
                                var frame = view!.convert(view!.frame, to: self!.scrollView)
                                frame.origin.y += 20
                                self?.scrollView.scrollRectToVisible(frame, animated: true)
                            }
                        }
                    }
                    self!.bottomConstraint.pop_add(animation, forKey: "constraint")
                    return currentBottomSpace
                })
        
    }
    
    func finalConstraintValueValueForKeyboardOpen(frame:CGRect) -> CGFloat {
        return frame.size.height
    }
    
}

protocol Collectionable {
    weak var collectionView:UICollectionView! {get}
    func setupCollectionView()
}
extension Collectionable where Self : UIViewController {
    func setupCollectionView() {
        self.collectionView.backgroundColor = .clear
    }
}

//protocol Sharer {
//    func shareItem() -> Sharable?
//}



extension UIViewController {
    
    private struct AssociatedKeys {
        static var loaderCount = "loaderCount"
        static var DisposeBag = "vc_disposeBag"
    }
   
    public var disposeBag: DisposeBag {
        var disposeBag: DisposeBag
        
        if let lookup = objc_getAssociatedObject(self, &AssociatedKeys.DisposeBag) as? DisposeBag {
            disposeBag = lookup
        } else {
            disposeBag = DisposeBag()
            objc_setAssociatedObject(self, &AssociatedKeys.DisposeBag, disposeBag, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        return disposeBag
    }
    
    func setup() -> UIViewController {
        let closure = {
            (self as? Collectionable)?.setupCollectionView()
        }
        self.automaticallyAdjustsScrollViewInsets = false
        if self.isViewLoaded {
            closure()
        } else {
            _ = self.rx.methodInvoked(#selector(viewDidLoad)).delay(0.0, scheduler: MainScheduler.instance).subscribe(onNext:{_ in closure()})
        }
        return self
    }
    
    func back() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func withBackButton() -> UIViewController {
        let item = UIBarButtonItem(image: UIImage(named: "ic_back"), style: .done, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = item
        return self
    }

    private var loaderCount: Int {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.loaderCount) as? Int ?? 0}
        set { objc_setAssociatedObject(self, &AssociatedKeys.loaderCount, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }
    
    func loaderView() -> UIView {
        return RTSpinKitView(style: .stylePulse, color: UIColor.red, spinnerSize: 44)
    }
    
    func loaderContentView() -> UIView {
        return self.navigationController?.view ?? self.view
    }
    
    func showLoader() {
        if self.loaderCount == 0 {
            DispatchQueue.main.async {[unowned self] in
                let hud = MBProgressHUD.showAdded(to: self.loaderContentView(), animated: true)
                let spin = self.loaderView()
                hud.customView = spin
                hud.mode = .customView
                hud.bezelView.color = .white
                hud.tintColor = .red
                hud.contentColor = .red
            }
        }
        self.loaderCount += 1
    }
    
    func hideLoader() {
        DispatchQueue.main.async {[weak self]  in
            if self == nil { return }
            
            self!.loaderCount = max(0, (self!.loaderCount ) - 1)
            
            if self!.loaderCount == 0 {
                MBProgressHUD.hide(for: self!.loaderContentView(), animated: true)
            }
        }
    }
    
    func sharedSelection(_ output: SelectionOutput) {
        guard let shared = output as? SharedSelectionOutput else { return }
        
        switch shared {
        case .restart:
            Router.restart()
        case .url(let url) :
            Router.open(url, from: self).execute()
        case .preview(let url) :
            Router.preview(url, from: self).execute()
        case .exit:
            Router.exit(self)
        case .dismiss:
            Router.dismiss(self)
        case .confirm(let title, let message, let confirmTitle, let action):
            Router.confirm(title: title, message: message, confirmationTitle: confirmTitle, from: self, action: action).execute()
        case .playVideo(let url):
            break
        }
    }
    
    func showError(_ error:ActionError) {
        // Router.error(error.unwrap(), from: self).execute()
    }
    
}
