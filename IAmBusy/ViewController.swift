//
//  ViewController.swift
//  IAmBusy
//
//  Created by إيلاف on 07/11/2020.
//

import RealmSwift
import UIKit


/*
 - To show list of current to do list items
 - To enter new to do list items
 - To show previously enteres to do list item
 
 -Item
 -Date
 */

class ToDOListItem: Object {
    @objc dynamic var  item: String = ""
    @objc dynamic var  date: Date = Date()
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var table: UITableView!
    
    private let realm = try! Realm()
    private var data = [ToDOListItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data = realm.objects(ToDOListItem.self).map({ $0 })
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.delegate = self
        table.dataSource = self
    }

   // Mark: Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableVeiw(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        _ = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLable?.text = data[indexPath.row].item
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deSelectRow(at: indexPath, animated: true)
        
        // open the screen where we can see item info and delete
        let item = data[indexPath.row]
    
        guard let vc = storyboard?.instantiateViewController(identifier: "view") as? ViewViewController else {
            return
        }
        
        vc.item = item
        vc.deletionHandler = { [weak self] in
            self?.refresh()
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = item.item
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapAddButton() {
        guard let vc = storyboard?.instantiateViewController(identifier: "enter") as? EntryViewController else {
            return
        }
        vc.completionHandler = { [weak self] in
            self?.refresh()
        }
        vc.title = "New Item"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    func refresh() {
        data = realm.objects(ToDOListItem.self).map({ $0 })
        table.reloadData()
    }
}


  
