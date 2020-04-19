//
//  OwncloudInstanceViewController.swift
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

class OwncloudInstanceViewController: GenericViewController {

    @IBOutlet weak var infoTitle: UILabel!
    @IBOutlet weak var hostUrlTextfield: UITextField!
    @IBOutlet weak var hostUrlTitle: UILabel!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var nameTitle: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationBar!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func cancelAction(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        
        let owncloudInstance = OwncloudModel.init(creationDate: "", currentVersion: "0.0", hosturl: self.hostUrlTextfield.text!, headVersion: "0.0", lastRefresh: "", name: self.nameTextfield.text!, type: "Owncloud", updateAvailable: 0, phpVersion: "", serverType: "")
        _ = owncloudInstance.saveConfigfile()
        HeadInstances.headInstances.removeAll()
        SystemInstances.systemInstances.removeAll()
        
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
