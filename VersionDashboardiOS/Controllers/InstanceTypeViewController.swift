//
//  InstanceTypeViewController.swift
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

class InstanceTypeViewController: UIViewController {

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var infoTextfield: UITextField!
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

}
