//
//  SavedNewsVC.swift
//  NewsApp
//
//  Created by Kavya on 18/08/22.
//

import UIKit
import CoreData

class SavedNewsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var savedNewsTableView: UITableView!
    
    var newsArray : [News] = []
    var manageObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manageObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        configureTableView()
        fetchData()
    }
    
    func configureTableView() {
        //view.addSubview(savedNewsTableView)
        savedNewsTableView.delegate = self
        savedNewsTableView.dataSource = self
    }
    
    func fetchData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entity = NSEntityDescription.entity(forEntityName: "News", in: self.manageObjectContext!)
        fetchRequest.entity = entity
        self.newsArray = try! self.manageObjectContext!.fetch(fetchRequest) as! [News]
//        savedNewsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedNewsTableViewCell") as! SavedNewsTableViewCell
        cell.headlineLabel.text = newsArray[indexPath.row].title
        cell.headlineSource.text = newsArray[indexPath.row].name
        cell.headlineImage.kf.setImage(with: URL(string: newsArray[indexPath.row].image ?? "https://www.kindpng.com/picc/m/134-1341850_contacts-icon-transparent-iphone-contact-icon-hd-png.png"))
        return cell
    }

}
