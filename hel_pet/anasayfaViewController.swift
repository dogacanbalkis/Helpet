//
//  anasayfaViewController.swift
//  hel_pet
//
//  Created by Doğa Balkış on 12.11.2020.
//

import UIKit
import Firebase

class anasayfaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UI Elements
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var posts = [Post]()
    let postManager = PostManager()
    var documentIDarray = [String]()
    var refresher: UIRefreshControl!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Firestoredan verileri çekmek...
        self.postManager.getAllPosts { [self] (posts, error) in
            if let posts = posts {
                self.posts = posts
                self.tableView.reloadData()
            }else if let error = error {
                debugPrint(error.localizedDescription)
            }
        }
    
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh),for: .valueChanged)
   }
    
    // MARK: - UI TableView Functions
    // posts gönderilerini sayarak o kadar satır oluşturmaktadır.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning("Delete before production")
        return posts.count
    }
    // UITableVievCell içerisinde tanımladığımız tüm verilere erişmek için oluşturduğumuz kodlar.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! anasayfaCell
        let post = posts[indexPath.row]
        cell.prepare(with: post)
        return cell
    }

    @objc private func didPullToRefresh(){
      print("start refreshing")
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    
    
    
}
