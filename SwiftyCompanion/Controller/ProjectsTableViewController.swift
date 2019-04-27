//
//  ProjectsTableViewController.swift
//  SwiftyCompanion
//
//  Created by Raphael GHIRELLI on 6/13/18.
//  Copyright © 2018 Raphael GHIRELLI. All rights reserved.
//

import UIKit

class ProjectsTableViewController: UITableViewController {

    var project: [ProjectUser]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView?.rowHeight = 44.0
        self.tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
         cell.backgroundColor = .clear
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let backgroundImage = UIImage(named: "default")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleAspectFill
        self.tableView.backgroundView = imageView
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return project?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! CustomTableViewCell
        cell.project = project?[indexPath.item]
        return cell
    }
}
