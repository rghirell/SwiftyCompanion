//
//  tabBarController.swift
//  SwiftyCompanion
//
//  Created by Raphael GHIRELLI on 6/12/18.
//  Copyright © 2018 Raphael GHIRELLI. All rights reserved.
//

import UIKit

var cursus: Cursus!

class tabBarController: UITabBarController {
    var coas: String?
    var user: Student?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        setTabBarControllers()
    }
    
    private func setNavBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    private func setTabBarControllers() {
        guard let user = self.user else { navigationController?.popViewController(animated: true); return }
        let projectTab = viewControllers![1] as! ProjectsTableViewController
        let skillTab = viewControllers![2] as! SkillsTableViewController
        let filtered = user.projects_users?.filter {  m in m.project?.parent_id == nil  }
        cursus = user.cursus_users!.first(where: { (curs) -> Bool in
            curs.cursus_id == 10 ||  curs.cursus_id == 1
        })
        if cursus?.skills?.count == 0 || cursus == nil {
            if self.viewControllers?.count == 3 {
                self.viewControllers?.remove(at: 2)
                self.viewControllers?.remove(at: 1)
            }
        }
        projectTab.project = filtered
        skillTab.skills = cursus?.skills
    }
    
    deinit {
        print("Tab bar deinit")
    }
    
}
