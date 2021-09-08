//
//  FlutterViewContainer.swift
//  blade
//
//  Created by sangya on 2021/9/1.
//

import Foundation

protocol FlutterContainerDelegate {
    var pageInfo:PageInfo? {get set}
    func setPageInfo(_ pageInfo:PageInfo)
}

public class FlutterViewContainer: FlutterViewController,FlutterContainerDelegate {
    var pageInfo:PageInfo?
    var flbNibName: String?
    var flbNibBundle: Bundle?
    public init() {
        Blade.shared.engine.viewController = nil
        super.init(engine: Blade.shared.engine, nibName: flbNibName, bundle: flbNibBundle)
        self.modalPresentationStyle = .fullScreen
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setPageInfo(_ pageInfo:PageInfo) {
        self.pageInfo = pageInfo
        if self.pageInfo?.id.count == 0 {
            self.pageInfo?.id = UUID.init().uuidString
        }
        Blade.shared.containerManager?.addContainer(container: self, uniqueId: self.pageInfo?.id ?? "")
    }

    public override func willMove(toParent parent: UIViewController?) {
        
        Blade.shared.channel?.sendEvent(event: PagePushedEvent(pageInfo))
        super.willMove(toParent: parent)
    }

    public override func didMove(toParent parent: UIViewController?) {
        if parent == nil {
            detachFlutterEngine()
            notifyWillDealloc()
        }
        super.didMove(toParent: parent)
    }

    public override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag) {[weak self] in
            guard let self = self else {return}
            completion?()
            self.detachFlutterEngine()
            self.notifyWillDealloc()
        }
    }
    
    func attatchFlutterEngine(){
        if Blade.shared.engine.viewController != self {
            Blade.shared.engine.viewController = self
        }
    }
    
    func detachFlutterEngine(){
        if self.engine?.viewController == self {
            if Blade.shared.engine.viewController != nil {
                Blade.shared.engine.viewController = nil
            }
        }
    }
    
    func notifyWillDealloc(){
        Blade.shared.containerManager?.removeContainerByUniqueId(uniqueId: self.pageInfo?.id ?? "")
        Blade.shared.channel?.sendEvent(event: PageDestroyedEvent(pageInfo))
    }
    
    public override func viewDidLoad() {
        attatchFlutterEngine()
        super.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.isHidden = true
        attatchFlutterEngine()
        Blade.shared.channel?.sendEvent(event: PagePushedEvent(pageInfo))
        super.viewWillAppear(animated)
    }

    public override func viewDidAppear(_ animated: Bool) {
        attatchFlutterEngine()
        super.viewDidAppear(animated)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        super.viewWillDisappear(animated)
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    public override func loadDefaultSplashScreenView() -> Bool {
        return true
    }
}
