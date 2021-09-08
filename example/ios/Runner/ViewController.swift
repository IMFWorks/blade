//
//  ViewController.swift
//  Runner
//
//  Created by sangya on 2021/9/2.
//

import Foundation
import blade
class FirstViewController: UIViewController {
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.white
        let btn = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        btn.backgroundColor = UIColor.red
        btn.addTarget(self, action: #selector(self.click), for: .touchUpInside)
        self.view.addSubview(btn)
    }
    @objc func click() {
        let vc = FlutterViewContainer()
        vc.setPageInfo(PageInfo(name: "flutterPage", id: "1234", params: ["1":2]))
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


class SecondViewController: UIViewController {
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.white
        let btn = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        btn.backgroundColor = UIColor.red
        btn.setTitle("ViewController second", for: .normal)
        btn.addTarget(self, action: #selector(self.click), for: .touchUpInside)
        self.view.addSubview(btn)
    }
    @objc func click() {
        self.navigationController?.popViewController(animated: true)
    }
}
