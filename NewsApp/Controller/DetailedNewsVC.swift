//
//  DetailedNewsVC.swift
//  NewsApp
//
//  Created by Kavya on 18/08/22.
//

import UIKit
import CoreData

class DetailedNewsVC: UIViewController {
    
    @IBOutlet weak var detailedTableView: UITableView!
    
    var category: String? = nil
    var sourceName: String? = nil
    var searchQuery: String? = nil
    var headlines: [Article] = []
    var currentAPICallPage = 1
    var manageObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manageObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        configureTableView()
        setUpTitle()
    }
    
    func setUpTitle() {
        if category != nil {
            self.title = category
        }
        if sourceName != nil {
            self.title = sourceName
        }
        if searchQuery != nil {
            self.title = searchQuery
        }
    }
    
    func configureTableView() {
        view.addSubview(detailedTableView)
        detailedTableView.delegate = self
        detailedTableView.dataSource = self
    }
}

extension DetailedNewsVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headlines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailedNewsTableViewCell", for: indexPath) as! DetailedNewsTableViewCell
        let article = headlines[indexPath.row]
        cell.setHeadlines(for: article)
        
        // last item in cell
        if category != nil {
            if indexPath.row == headlines.count - 1 {
                currentAPICallPage += 1
                NetworkManager.singleton.getArticles(passedInCategory: category!, passedInPageNumber: String(currentAPICallPage)) { result in
                    switch result {
                    case let .success(moreArticles):
                        self.headlines.append(contentsOf: moreArticles!)
                        self.detailedTableView.reloadData()
                    case let .failure(gotError):
                        print(gotError)
                    }
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // To display the actual html of the story
        let vc = DetailedNewsStoryVC()
        vc.url = headlines[indexPath.row].url
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { _, indexPath in
            tableView.beginUpdates()
            self.headlines.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with:.fade)
            tableView.endUpdates()
        }
        
        let saveAction = UITableViewRowAction(style: .normal, title: "Save") { _, indexPath in
            let article = self.headlines[indexPath.row]
            self.saveToCoreData(article: article)
        }
        deleteAction.backgroundColor = .red
        saveAction.backgroundColor = .green
        return [deleteAction,saveAction]
    }
    
    func saveToCoreData(article : Article){
        let entity = NSEntityDescription.entity(forEntityName: "News", in: self.manageObjectContext!)
        let news = News(entity: entity!, insertInto: self.manageObjectContext!)
        news.image = article.urlToImage
        news.title = article.title
        news.name = article.source.name
        do {
            try self.manageObjectContext!.save()
        } catch {
            print("Data saving error", error.localizedDescription)
        }
    }    
}

