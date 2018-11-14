//
//  ViewController.swift
//  ThreadSafeTableView
//
//  Created by osanai on 2018/11/14.
//  Copyright © 2018年 osanai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var lock:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    var data:[String] = ["AA","B","C","D","E","F","G"]
    
    func setData(d:[String],completion:@escaping (() -> ())) {
        if lock {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.data = d
                completion()
            }
        }
        else {
            self.data = d
            completion()
        }
    }
    
    func reloadDataWithLock() {
        lock = true        
        tableView.reloadData {
            DispatchQueue.main.async {
                self.lock = false
            }
        }
    }
    
    @IBAction func tappedButton(_ sender: Any) {
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
        reloadDataWithLock()
        print("抜け")


        for i in 0...100000 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.00000001 * Double(i)) {
                if (i % 4 == 0) {
                    let dd = ["b","b","b","b","b","b","b","b","b","b","b","b","b","b","b","b","b","b","b","b","b","b","b","b","b","b","b","b"]
                    self.setData(d: dd, completion: {
                    })
                }
                else if (i % 4 == 1) {
                    let dd = ["あ","あ","あ","あ","あ","あ","あ","あ","あ","あ","あ","あ"]
                    self.setData(d: dd, completion: {
                    })
                }
                else if (i % 4 == 2) {
                    let dd = ["＠","＠","＠","＠","＠","＠"]
                    self.setData(d: dd, completion: {
                    })
                }
                else {
                    let dd = ["A"]
                    self.setData(d: dd, completion: {
                    })
                }
            }
        }
        
        
    }
}


extension ViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("☠️count \(data.count) \(String(describing: data.first))")
        
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("🤔count \(data.count) \(String(describing: data.first))")
        let d = data[indexPath.row]
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = d
        
        print("return cell")
        return cell
    }
    
    
}

extension UITableView {
    public func reloadData(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }
}
