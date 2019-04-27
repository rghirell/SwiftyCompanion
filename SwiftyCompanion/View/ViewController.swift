//
//  ViewController.swift
//  SwiftyCompanion
//
//  Created by Raphael GHIRELLI on 6/12/18.
//  Copyright © 2018 Raphael GHIRELLI. All rights reserved.
//

import UIKit

var getUserInfo: GetUserInfo!

class ViewController: UIViewController, UITextFieldDelegate, AlertDelegate {
   
    @IBOutlet weak var userInput: UITextField!
    @IBOutlet weak var buttonStyle: UIButton!
    
    // MARK: -
    // MARK: - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
        userInput.delegate = self
        getUserInfo = GetUserInfo(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: -
    // MARK: - View Layout
    let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        ai.color = .black
        ai.translatesAutoresizingMaskIntoConstraints = false
        return ai
    }()
    
    fileprivate func setupUI() {
        userInput.autocorrectionType = .no
        buttonStyle.layer.cornerRadius = 5.0
        buttonStyle.layer.borderWidth = 1.0
        buttonStyle.layer.borderColor = UIColor.white.cgColor
        self.assignBackground(background: "default")
        setupWaitingView()
    }
    
    func setupWaitingView() {
        view.addSubview(activityIndicator)
        activityIndicator.color = .white
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40).isActive = true
    }
    
    // MARK: -
    // MARK: - User fetching
    @objc func hideKeyboard(gesture: UITapGestureRecognizer){
        view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        if invalidInput() { return true }
        fetchInfos()
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func getLoginInfos(_ sender: UIButton) {
        if invalidInput() { return }
        fetchInfos()
    }
    
    func invalidInput() -> Bool {
        let newString = self.userInput.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if newString.count > 8 || newString.count == 0 {
            errorHandler(errorMessage: "Invalid input.")
            return true
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tabVc = segue.destination as! tabBarController
        tabVc.coas = getUserInfo.coas!
        tabVc.user = getUserInfo.student
    }
        
    func fetchInfos() {
        DispatchQueue.main.async {
            self.buttonStyle.isUserInteractionEnabled = false
            let newString = self.userInput.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            self.activityIndicator.startAnimating()
            getUserInfo.getUser(username: newString.lowercased())
        }
    }
    
    func errorHandler(errorMessage: String) {
        DispatchQueue.main.async {
            self.buttonStyle.isUserInteractionEnabled = true
            let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok.", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.activityIndicator.stopAnimating()
        }
    }
    
    func segue() {
        DispatchQueue.main.async {
            self.buttonStyle.isUserInteractionEnabled = true
            self.activityIndicator.stopAnimating()
            self.performSegue(withIdentifier: "toDetails", sender: nil)
        }
    }

}
