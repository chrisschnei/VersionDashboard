//
//  InstanceDetailsViewController.swift
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

class InstanceDetailsViewController: GenericViewController {

    var systemInstancesName : String!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var hostUrlTextfield: UITextField!
    @IBOutlet weak var typeEditField: UITextField!
    @IBOutlet weak var instanceTitle: UITextField!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var apiTokenEdit: UITextField!
    @IBOutlet weak var noInternetConnection: UITextField!
    @IBOutlet weak var phpversionLabel: UILabel!
    @IBOutlet weak var apiTokenLabel: UILabel!
    @IBOutlet weak var webserverLabel: UILabel!
    @IBOutlet weak var hosturlLabel: UILabel!
    @IBOutlet weak var instanceVersionLabel: UILabel!
    @IBOutlet weak var headVersionLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var phpVersionDetails: UILabel!
    @IBOutlet weak var webserverDetails: UILabel!
    @IBOutlet weak var instanceVersionNumber: UILabel!
    @IBOutlet weak var headVersionNumber: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fillWithData()
    }
    
    func fillWithData() {
        if ((SystemInstances.systemInstances[systemInstancesName] as? JoomlaModel) != nil) {
            let joomlamodel = SystemInstances.systemInstances[systemInstancesName] as? JoomlaModel
            self.typeEditField.text = joomlamodel?.type
            self.instanceTitle.text = joomlamodel?.name
            self.headVersionNumber.text = joomlamodel?.headVersion
            self.instanceVersionNumber.text = joomlamodel?.currentVersion
            self.hostUrlTextfield.text = joomlamodel?.hosturl
            self.webserverDetails.text = joomlamodel?.serverType
            self.phpVersionDetails.text = joomlamodel?.phpVersion
        } else if ((SystemInstances.systemInstances[systemInstancesName] as? WordpressModel) != nil) {
            let wordpressmodel = SystemInstances.systemInstances[systemInstancesName] as? WordpressModel
            self.typeEditField.text = wordpressmodel?.type
            self.headVersionNumber.text = wordpressmodel?.currentVersion
            self.instanceTitle.text = wordpressmodel?.name
            self.instanceVersionNumber.text = wordpressmodel?.headVersion
            self.hostUrlTextfield.text = wordpressmodel?.hosturl
            self.webserverDetails.text = wordpressmodel?.serverType
            self.phpVersionDetails.text = wordpressmodel?.phpVersion
        } else if ((SystemInstances.systemInstances[systemInstancesName] as? OwncloudModel) != nil) {
            let owncloudmodel = SystemInstances.systemInstances[systemInstancesName] as? OwncloudModel
            self.typeEditField.text = owncloudmodel?.type
            self.headVersionNumber.text = owncloudmodel?.currentVersion
            self.instanceVersionNumber.text = owncloudmodel?.headVersion
            self.hostUrlTextfield.text = owncloudmodel?.hosturl
            self.webserverDetails.text = owncloudmodel?.serverType
            self.phpVersionDetails.text = owncloudmodel?.phpVersion
            self.instanceTitle.text = owncloudmodel?.name
        } else if ((SystemInstances.systemInstances[systemInstancesName] as? PiwikModel) != nil) {
            let piwikmodel = SystemInstances.systemInstances[systemInstancesName] as? PiwikModel
            self.apiTokenLabel.isHidden = false
            self.apiTokenEdit.isHidden = false
            self.typeEditField.text = piwikmodel?.type
            self.headVersionNumber.text = piwikmodel?.currentVersion
            self.instanceVersionNumber.text = piwikmodel?.headVersion
            self.hostUrlTextfield.text = piwikmodel?.hosturl
            self.instanceTitle.text = piwikmodel?.name
            self.webserverDetails.text = piwikmodel?.serverType
            self.phpVersionDetails.text = piwikmodel?.phpVersion
            self.apiTokenEdit.text = piwikmodel?.apiToken
        } else {
            print("Failure casting AnyObject from systemInstances to known model.")
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func deleteInstance(_ sender: Any) {
        let path = (Constants.plistFilesPath + systemInstancesName) + ".plist"
        if (!self.deleteInstance(path, systemInstancesName)) {
            print("removing instance did not work")
        }
        self.dismiss(animated: true)
    }
    
    @IBAction func saveInstance(_ sender: Any) {
        if(self.checkURLTextfields()) {
            return
        }
        
        if(SystemInstancesModel.checkInstanceNameAlreadyPresent(self.title!)) {
            self.noInternetConnection.isHidden = false
            self.noInternetConnection.text = NSLocalizedString("instanceDuplicate", comment: "")
            return
        }
        
        if (SystemInstances.systemInstances[systemInstancesName] as? OwncloudModel != nil) {
            let owncloudModel = SystemInstances.systemInstances[systemInstancesName] as! OwncloudModel
            owncloudModel.hosturl = self.hostUrlTextfield.text!
            owncloudModel.name = self.instanceTitle.text!
            _ = owncloudModel.saveConfigfile()
        } else if (SystemInstances.systemInstances[systemInstancesName] as? PiwikModel != nil) {
            let piwikModel = SystemInstances.systemInstances[systemInstancesName] as! PiwikModel
            piwikModel.hosturl = self.hostUrlTextfield.text!
            piwikModel.name = self.instanceTitle.text!
            piwikModel.apiToken = self.apiTokenEdit.text!
            _ = piwikModel.saveConfigfile()
        } else if (SystemInstances.systemInstances[systemInstancesName] as? JoomlaModel != nil) {
            let joomlaModel = SystemInstances.systemInstances[systemInstancesName] as! JoomlaModel
            joomlaModel.hosturl = self.hostUrlTextfield.text!
            joomlaModel.name = self.instanceTitle.text!
            _ = joomlaModel.saveConfigfile()
        } else if (SystemInstances.systemInstances[systemInstancesName] as? WordpressModel != nil) {
            let wordpressModel = SystemInstances.systemInstances[systemInstancesName] as! WordpressModel
            wordpressModel.hosturl = self.hostUrlTextfield.text!
            wordpressModel.name = self.instanceTitle.text!
            _ = wordpressModel.saveConfigfile()
        } else {
            print("Error saving instance")
        }
        self.dismiss(animated: true)
    }
    
    func checkURLTextfields() -> Bool {
        var error = false
        if(!((self.hostUrlTextfield.text?.hasSuffix("/"))!)) {
            self.noInternetConnection.text = NSLocalizedString("urlEnding", comment: "")
            self.noInternetConnection.isHidden = false
            error = true
        }
        if(!((self.hostUrlTextfield.text?.hasPrefix("http"))!)) {
            self.noInternetConnection.text = NSLocalizedString("protocolMissing", comment: "")
            self.noInternetConnection.isHidden = false
            error = true
        }
        return error
    }
    
    @IBAction func refreshInstance(_ sender: Any) {
        self.activitySpinner.isHidden = false
        self.activitySpinner.startAnimating()
        if(InternetConnectivity.checkInternetConnection()) {
            self.updateSingleInstance(instanceName: systemInstancesName) { completion in
                let parameters = ["self": self, "completion" : completion] as [String : Any]
                self.performSelector(onMainThread: #selector(self.checksFinished), with: parameters, waitUntilDone: true)
            }
        } else {
            self.noInternetConnection.text = NSLocalizedString("errorInternetConnection", comment: "")
            self.noInternetConnection.isHidden = false
            self.refreshButton.setTitle(NSLocalizedString("retry", comment: ""), for: (UIControl.State).normal)
        }
    }
    
    @objc func checksFinished(_ parameters: [String: Any]) {
        self.activitySpinner.stopAnimating()
        self.activitySpinner.isHidden = true
        if (!(parameters["completion"] as! Bool)) {
            self.noInternetConnection.text = NSLocalizedString("errorfetchingVersions", comment: "")
            self.noInternetConnection.isHidden = false
        } else {
            self.noInternetConnection.isHidden = true
        }
        self.fillWithData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
