//
//  GetUserInfo.swift
//  SwiftyCompanion
//
//  Created by Raphael GHIRELLI on 6/12/18.
//  Copyright © 2018 Raphael GHIRELLI. All rights reserved.
//

import Foundation

protocol AlertDelegate {
    func errorHandler(errorMessage: String)
    func segue()
}

class GetUserInfo  {
    var token: String?
    var apiController: APIController?
    var userRoute = "https://api.intra.42.fr/v2/users/"
    var student: Student? {
        didSet {
            if student?.login != nil && student?.displayname != nil {
                getCoas(username: student!.login!)
            }
        }
    }
    var coas: String? {
        didSet {
            delegateAlert.segue()
        }
    }
    
    let delegateAlert: AlertDelegate
    init(delegate: AlertDelegate) {
        delegateAlert = delegate
        apiController = APIController()
    }
    
    func getUser(username: String){
        guard let urlComps = NSURLComponents(string: userRoute + username) else {
            delegateAlert.errorHandler(errorMessage: "Couldn't retrieve this user : \(username)")
            return
        }
        let accessRequest = apiController?.oauth2.request(forURL: urlComps.url!)
        guard let request = accessRequest else {
            delegateAlert.errorHandler(errorMessage: "Couldn't retrieve this user : \(username)")
            return
        }
        let task  = URLSession.shared.dataTask(with: request, completionHandler: parseResult)
        task.resume()
    }
    
    func getCoas(username: String)  {
        guard let urlComps = NSURLComponents(string: userRoute + username + "/coalitions") else {
            delegateAlert.errorHandler(errorMessage: "Couldn't retrieve this user : \(username)")
            return
        }
        let accessRequest = apiController?.oauth2.request(forURL: urlComps.url!)
        guard let request = accessRequest else {
            delegateAlert.errorHandler(errorMessage: "Couldn't retrieve this user : \(username)")
            return
        }
        let task  = URLSession.shared.dataTask(with: request, completionHandler: parseCoas)
        task.resume()
        return
    }
    
    func parseCoas(data: Data?, urlResponse: URLResponse?, error: Error?) {
        if let err = error {
            print(err.localizedDescription)
            delegateAlert.errorHandler(errorMessage: err.localizedDescription)
            return
        }
        if let d = data {
            let coasTmp = try? JSONDecoder().decode([Coalitions].self, from: d)
            getCoasColor(coalition: coasTmp)
        }
    }
    
    func getCoasColor(coalition: [Coalitions]?) {
        if coalition?.count == 0 {
            coas = "default"
        }
        else {
            guard let id = coalition?.last?.id else { coas = "default"; return }
            switch id {
            case 1:
                coas = Coalition.federation.rawValue
            case 2:
                coas = Coalition.alliance.rawValue
            case 3:
                coas = Coalition.assembly.rawValue
            case 4:
                coas = Coalition.order.rawValue
            case 5:
                coas = Coalition.allianceK.rawValue
            case 6:
                coas = Coalition.unionK.rawValue
            case 7:
                coas = Coalition.empireK.rawValue
            case 8:
                coas = Coalition.hiveK.rawValue
            case 9, 17:
                coas = Coalition.worms.rawValue
            case 10:
                coas = Coalition.sloths.rawValue
            case 11, 16:
                coas = Coalition.skunks.rawValue
            case 12, 15:
                coas = Coalition.blobfishes.rawValue
            default:
                coas = "default"
            }
        }
    }
    
    func parseResult(data: Data?, urlResponse: URLResponse?, error: Error?) {
        if let err = error {
            print(err.localizedDescription)
            delegateAlert.errorHandler(errorMessage: err.localizedDescription)
            return
        }
        if let d = data {
            student = try? JSONDecoder().decode(Student.self, from: d)
            if (student?.login == nil && student?.displayname == nil) {
                delegateAlert.errorHandler(errorMessage: "Couldn't retrieve this user")
            }
        }
    }
}


enum Coalition: String {
    case federation = "federation"
    case alliance
    case assembly
    case order
    case allianceK
    case unionK
    case empireK
    case hiveK
    case worms
    case sloths
    case skunks
    case blobfishes
}
