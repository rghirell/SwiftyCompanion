//
//  CustomTableViewCell.swift
//  SwiftyCompanion
//
//  Created by Raphael GHIRELLI on 6/13/18.
//  Copyright © 2018 Raphael GHIRELLI. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

  @IBOutlet weak var projectName: UILabel!
  @IBOutlet weak var detailName: UILabel!
    
    var project: ProjectUser? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        projectName.text = project?.project?.name!
        if let x = project?.final_mark {
            detailName.text = String(x)
            if (x > 100){
                detailName.textColor = UIColor(rgb: UIColor.RGB(r: 0,g:139,b:255))
            }
            else if (project?.validated!)! {
                detailName.textColor = .green
            } else {
                detailName.textColor = .red
            }
            
        } else {
            detailName.text = "⏱"
        }
    }
}
