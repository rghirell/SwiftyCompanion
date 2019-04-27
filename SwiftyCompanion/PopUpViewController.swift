//
//  PopUpViewController.swift
//  SwiftyCompanion
//
//  Created by Raphael GHIRELLI on 7/10/18.
//  Copyright © 2018 Raphael GHIRELLI. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(closePopUp))
        view.addGestureRecognizer(closeTap)
        print(getUserInfo.student!.image_url!)
        if getUserInfo.student!.image_url!.hasSuffix(".gif") {
            image.loadGif(url: getUserInfo.student!.image_url!)
        }
        else {
            let downloadURL = URL(string: getUserInfo.student!.image_url!)!
            image.af_setImage(withURL: downloadURL)
        }
        showAnimate()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 5.0
        image.clipsToBounds = true
    }
    
    @objc func closePopUp() {
        self.view.removeFromSuperview()
    }
    
    func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }

}
