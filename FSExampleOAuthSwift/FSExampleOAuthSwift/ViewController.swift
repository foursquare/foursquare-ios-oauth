//
// Copyright (C) 2016 Foursquare, Inc. and other contributors.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//         http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import UIKit


class ViewController: UIViewController {
    
    // MARK: Properties

    var latestAccessToken: String = ""
    
    // MARK: IBOutlet

    @IBOutlet weak var clientSecretField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var universalLinkCallback: UITextField!
    @IBOutlet weak var callbackUrlField: UITextField!
    
    @IBOutlet weak var clientIdField: UITextField!
    
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    /**
     Connect and authorize user and then process the auth status back to the resultLabel
     
     @note this function is dependant on accessToke, clientId, callbackURI and clientSecret
     */
    
    @IBAction func connectTapped(_ sender: AnyObject) {

        self.dismissKeyboard(sender)
        
        // The testing app currently does not support universal url callbacks
        let statuscode: FSOAuthStatusCode = FSOAuth.shared().authorizeUser(usingClientId:self.clientIdField.text!,
                                                                           nativeURICallbackString: self.callbackUrlField.text,
                                                                           universalURICallbackString: nil,
                                                                           allowShowingAppStore: true,
                                                                           presentFrom: self)
        var resultText: String = ""
        switch(statuscode) {
            case FSOAuthStatusCode.success:
                // Do Nothing
                break
            case FSOAuthStatusCode.errorInvalidCallback:
                resultText = "Invalid callback URI"
                break
            case FSOAuthStatusCode.errorFoursquareNotInstalled:
                resultText = "Foursquare is not installed"
                break
            case FSOAuthStatusCode.errorInvalidClientID:
                resultText = "Invalid client id"
                break
            case FSOAuthStatusCode.errorFoursquareOAuthNotSupported:
                resultText = "Installed FSQ App doesn't support oauth"
                break
            default:
                resultText = "Unknown status code returned"
                break
            }
        self.resultLabel.text = resultText
    }
    
    /**
     Process a request for an access token and set the response to the "resultLabel"

     @note this function is dependant on accessToke, clientId, callbackURI and clientSecret
     */
    
    @IBAction func convertTapped(_ sender: AnyObject) {
        FSOAuth.shared().requestAccessToken(forCode: self.latestAccessToken,
                                            clientId: self.clientIdField.text!,
                                            callbackURIString: self.callbackUrlField.text!,
                                            clientSecret: self.clientSecretField.text!) { (authToken, requestCompleted, errorCode) in
                                                var resultText: String = ""
                                                if (requestCompleted) {
                                                    if (errorCode == FSOAuthErrorCode.none) {
                                                        resultText = String(format: "Auth Token: %@", authToken!)
                                                    } else {
                                                        resultText = self.errorMessageForCode(errorCode: errorCode)
                                                    }
                                                } else {
                                                    resultText = "An error occured when attempting o connect to the Foursquare server."
                                                }
                                                self.resultLabel.text = String(format: "Result: %@", resultText)
                                            }

    }
    
    /**
     Remove the keyboard from the view
     
     @note See "Main.storyboard" for more details on the @IBAction.
     @note dismissKeyboard is assigned to Did End on Exit for each of the text field
    */

    @IBAction func dismissKeyboard(_ sender: AnyObject) {
        self.clientIdField.resignFirstResponder()
        self.callbackUrlField.resignFirstResponder()
        self.clientSecretField.resignFirstResponder()
    }
    
    /**
     Processes an error message code for auth.
     
     @param errorCode An FSOAuthErrorCode pointer that will be set to the error code on return.
     See enum definition above for possible error code values.
     @return The access code for this user or nil if there was an error in authorization or parsing the URL.
    */

    func errorMessageForCode(errorCode: FSOAuthErrorCode) -> String {
        var resultText: String = ""
        switch (errorCode) {
            case FSOAuthErrorCode.none:
                break
            case FSOAuthErrorCode.invalidClient:
                resultText = "Invalid client error"
                break
            case FSOAuthErrorCode.invalidGrant:
                resultText = "Invalid grant error"
                break
            case FSOAuthErrorCode.invalidRequest:
                resultText = "Invalid request error"
                break
            case FSOAuthErrorCode.unauthorizedClient:
                resultText = "Invalid unauthorized client error"
                break
            case FSOAuthErrorCode.unsupportedGrantType:
                resultText = "Invalid unsupported grant error"
                break
            case FSOAuthErrorCode.unknown:
                resultText = "Unknown error"
                break
            default:
                resultText = "Unknown error"
                break
        }
        return resultText
    }
    
    /**
     Handle URL from AppDelegate to this view controller.
     
     @param url A url for type URL.
    */
    
    func handleURL(url: URL) {
        print(url)
        if (url.scheme == "fsoauthexample") {
            var errorCode: FSOAuthErrorCode = FSOAuthErrorCode.none

            let accessCode = FSOAuth.shared().accessCode(forFSOAuthURL: url,
                                                         error: &errorCode)
            var resultText: String
            if (errorCode == FSOAuthErrorCode.none) {
                resultText = String(format:"Access code: %@", accessCode!)
                self.latestAccessToken = accessCode!
            } else {
                resultText = self.errorMessageForCode(errorCode: errorCode)
            }
            self.resultLabel.text = String(format: "Result: %@", resultText)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

