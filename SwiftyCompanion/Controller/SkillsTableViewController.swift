//
//  SkillsTableViewController.swift
//  SwiftyCompanion
//
//  Created by Raphael GHIRELLI on 6/13/18.
//  Copyright © 2018 Raphael GHIRELLI. All rights reserved.
//

import UIKit

class SkillsTableViewController: UITableViewController {
    
    var skills: [Skills]?
    var flag: [Bool]?
    
    let image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "sad")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        flag = [Bool](repeatElement(false, count: skills?.count ?? 0))
        self.tableView?.rowHeight = 73.0
        self.tableView.tableFooterView = UIView()
        
        if (skills!.count == 0){
            setupImage()
        }
    }
    
    func setupImage() {
        view.addSubview(image)
        NSLayoutConstraint.activate([image.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
                                     image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     image.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
                                     image.widthAnchor.constraint(equalTo: image.heightAnchor)])   
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let flag = self.flag else { return }
        if !flag[indexPath.item] {
            let skillsCell = cell as! SkillsTableViewCell
            skillsCell.backgroundColor = .clear
            let progressLevelBar = skillsCell.progressBarL.frame
            skillsCell.progressBarL.frame = CGRect(x: 0, y: 0, width: 0, height: progressLevelBar.height)
            UIView.animate(withDuration: 2) {
                skillsCell.progressBarL.frame = CGRect(x: 0, y: 0, width: progressLevelBar.width, height: progressLevelBar.height)
            }
            self.flag![indexPath.item] = true
        }
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
        return skills?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "skillCell", for: indexPath) as! SkillsTableViewCell
        cell.skills = skills?[indexPath.item]
        return cell
    }
    
}
