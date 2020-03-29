//
//  WordpressInstanceViewController.swift
//  VersionDashboardiOS
//
//  Created by Christian Schneider on 27.12.17.
//  Copyright © 2017 NonameCompany. All rights reserved.
//

import UIKit
#if targetEnvironment(simulator)
import VersionDashboardSDK
#else
import VersionDashboardSDKARM
#endif

class WordpressInstanceViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var nameTitle: UILabel!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var infoTitle: UILabel!
    @IBOutlet weak var hostUrlTextfield: UITextField!
    @IBOutlet weak var hostUrlTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func saveInstance(_ sender: Any) {
        if (self.checkURLTextfields()) {
            return
        }
        
        if (SystemInstancesModel.checkInstanceNameAlreadyPresent(self.nameTitle.text!)) {
            self.infoTitle.isHidden = false
            self.infoTitle.text = NSLocalizedString("instanceDuplicate", comment: "")
            return
        }
        
        let wordpressInstance = WordpressModel.init(creationDate: "", currentVersion: "", hosturl: self.hostUrlTextfield.text!, headVersion: "", lastRefresh: "", name: self.nameTextfield.text!, type: "Wordpress", updateAvailable: 0, phpVersion: "", serverType: "")
        _ = wordpressInstance.saveConfigfile()
        HeadInstances.headInstances.removeAll()
        SystemInstances.systemInstances.removeAll()
        
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func checkURLTextfields() -> Bool {
        var error = false
        if (!((self.hostUrlTextfield.text?.hasSuffix("/"))!)) {
            self.infoTitle.text = NSLocalizedString("urlEnding", comment: "")
            self.infoTitle.isHidden = false
            error = true
        }
        if (!((self.hostUrlTextfield.text?.hasPrefix("http"))!)) {
            self.infoTitle.text = NSLocalizedString("protocolMissing", comment: "")
            self.infoTitle.isHidden = false
            error = true
        }
        return error
    }
    
}
