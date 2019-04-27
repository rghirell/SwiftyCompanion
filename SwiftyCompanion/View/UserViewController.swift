//
//  UserViewController.swift
//  SwiftyCompanion
//
//  Created by Raphael GHIRELLI on 6/12/18.
//  Copyright © 2018 Raphael GHIRELLI. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import MessageUI

class UserViewController: UIViewController, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {

    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var mailView: UIView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var progressBar: UIView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var progressBarL: UIView!
    @IBOutlet weak var levelIndicator: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var isAvailable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.bringSubview(toFront: image)
        let pictureTap = UITapGestureRecognizer(target: self, action: #selector(showPicture))
        image.addGestureRecognizer(pictureTap)
        image.isUserInteractionEnabled = true
        assignBackground(background: getUserInfo.coas!)
    }
    
    var levelBarWidth: CGRect?
    var done = false
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !done {
            animateProgressBar()
            done = true
        }
    }
    
    fileprivate func animateProgressBar() {
        levelBarWidth = self.progressBarL.frame
        progressBarL.frame = CGRect(x: 0, y: 0, width: 0, height: levelBarWidth!.height)
        progressBarL.isHidden = false
        UIView.animate(withDuration: 2) {
            self.progressBarL.frame = CGRect(x: 0, y: 0, width: self.levelBarWidth!.width, height: self.levelBarWidth!.height)
        }
    }
    
    
    @objc func showPicture() {
        let popOveVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpView") as! PopUpViewController
        self.addChildViewController(popOveVC)
        popOveVC.view.frame = self.view.frame
        self.view.addSubview(popOveVC.view)
        popOveVC.didMove(toParentViewController: self)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        progressBarL.isHidden = !done ? true : false
        if getUserInfo.student!.image_url!.hasSuffix(".gif") {
            image.loadGif(url: getUserInfo.student!.image_url!)
        }
        else {
            let downloadURL = URL(string: getUserInfo.student!.image_url!)!
            image.af_setImage(withURL: downloadURL)
        }
        tabBarController?.navigationItem.hidesBackButton = false
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        clearImageFromCache()
        tabBarController?.navigationItem.hidesBackButton = true
    }
    
    override func viewDidLayoutSubviews() {
        setupLayout()
        print("DidLayout")
        image.layer.masksToBounds = false
        image.layer.cornerRadius = image.bounds.width / 2.0
        image.clipsToBounds = true
        phoneView.roundCorners([.bottomLeft], radius: 5)
        mailView.roundCorners([.bottomRight], radius: 5)
    }
    
    
    @IBAction func message(_ sender: UIButton) {
        if (MFMessageComposeViewController.canSendText()) {
            guard let numberExist = getUserInfo.student?.phone else {
                sendAlert(title: "Error", message: "Invalid phone number was given.")
                return
            }
            guard let _ = URL(string: "tel://" + numberExist) else {
                sendAlert(title: "Error", message: "Invalid phone number was given.")
                return
            }
            let alert = UIAlertController(title: "Message", message: "Would you like to send a text message to \(getUserInfo!.student!.phone!) ?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel.", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Send.", style: .default, handler: messageHandler))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func messageHandler(alert: UIAlertAction!) {
        guard let numberExist = getUserInfo.student?.phone else {
            sendAlert(title: "Error", message: "Invalid phone number was given.")
            return
        }
        let controller = MFMessageComposeViewController()
        controller.body = ""
        controller.recipients = [numberExist]
        controller.messageComposeDelegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func phoneNumber(_ sender: UIButton) {
        print("Telephone")
        guard let numberExist = getUserInfo.student?.phone else {
            sendAlert(title: "Error", message: "Invalid phone number was given.")
            return
        }
        guard let number = URL(string: "tel://" + numberExist) else {
            sendAlert(title: "Error", message: "Invalid phone number was given.")
            return
        }
        UIApplication.shared.open(number)
    }
    
    @IBAction func emailAddress(_ sender: UIButton) {
        print("Email")
        if getUserInfo.student?.email == nil {
            sendAlert(title: "Error", message: "No email addresses were found.")
            return
        }

        let alert = UIAlertController(title: "E-mail", message: "Would you like to send an email to \(getUserInfo!.student!.email!) ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel.", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Send.", style: .default, handler: sendEmail))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func sendEmail(alert: UIAlertAction!) {
        if MFMailComposeViewController.canSendMail() {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            // Configure the fields of the interface.
            composeVC.setToRecipients([getUserInfo!.student!.email!])
            composeVC.setSubject("Swifty-Companion")
            composeVC.setMessageBody("Hello from 42!", isHTML: false)
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
        } else {
            sendAlert(title: "Error", message: "Can't send an e-mail.")
        }
    }
    
    func sendAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok.", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
