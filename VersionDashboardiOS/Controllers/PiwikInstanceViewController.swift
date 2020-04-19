//
//  PiwikInstanceViewController.swift
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

class PiwikInstanceViewController: GenericViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var infoTitle: UILabel!
    @IBOutlet weak var apiTokenTextfield: UITextField!
    @IBOutlet weak var apiTokenTitle: UILabel!
    @IBOutlet weak var hostUrlTextfield: UITextField!
    @IBOutlet weak var hostUrlTitle: UILabel!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var nameTitle: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func saveInstance(_ sender: Any) {
        if (self.checkURLTextfields(hostUrlTextfield: self.hostUrlTextfield, infoTitle: self.infoTitle)) {
            return
        }
        
        if (SystemInstancesModel.checkInstanceNameAlreadyPresent(self.nameTitle.text!)) {
            self.infoTitle.isHidden = false
            self.infoTitle.text = NSLocalizedString("instanceDuplicate", comment: "")
            return
        }
        
        let piwikInstance = PiwikModel.init(creationDate: "", currentVersion: "0.0", hosturl: self.hostUrlTextfield.text!, apiToken: self.apiTokenTextfield.text!, lastRefresh: "", name: self.nameTextfield.text!, type: "Piwik", headVersion: "0.0", updateAvailable: 0, phpVersion: "", serverType: "")
        _ = piwikInstance.saveConfigfile()
        HeadInstances.headInstances.removeAll()
        SystemInstances.systemInstances.removeAll()
        
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
