//
//  ViewController.swift
//  DaGate
//
//  Created by Guillermo A Araiza Torres on 06/03/15.
//  Copyright (c) 2015 Disforma. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet var firstInput:  UIImageView!
    @IBOutlet var secondInput: UIImageView!
    @IBOutlet var thirdInput:  UIImageView!
    @IBOutlet var fourthInput: UIImageView!
    
    
    @IBOutlet var mainBackground: UIImageView!
    var backgroundImages = ["bike", "cat", "friends", "geekissexy", "glasses", "hipster", "trooper", "tuxedo"]

    var initialState = [0,0,0,0]
    var counter = 0
    var resetimage = UIImage(named: "blankCircle.png")
    var palceimage = UIImage(named: "orangeCircle.png")
    var correimage = UIImage(named: "greenCircle.png")
    
    let alert = UIAlertView()
    
    var accessToken = "8c5a222f2fb398a85b474245091834905a28db5c"
    var deviceToken = "55ff6e065075555352351487"
    
    @IBAction func cancelButton(sender: AnyObject) {
        
        initialState = [0,0,0,0]
        counter = 0
        let delay = 0.7 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(time, dispatch_get_main_queue()) {
            self.firstInput.image  = self.resetimage
            self.secondInput.image = self.resetimage
            self.thirdInput.image  = self.resetimage
            self.fourthInput.image = self.resetimage
        }
    }
    
    @IBAction func ohButton(sender: AnyObject) {
        var randomNumber = Int(arc4random_uniform(UInt32(backgroundImages.count)))
        var background   = UIImage(named: "\(backgroundImages[randomNumber]).jpg")
        mainBackground.image = background
        mainBackground.alpha = 0.1
        self.view.sendSubviewToBack(mainBackground)
        
    }
    @IBAction func codeButton(sender: AnyObject) {
        
        var image = UIImage()
        initialState[counter] = sender.tag
        
        switch counter {
            case 0:
                firstInput.image  = palceimage
            case 1:
                secondInput.image = palceimage
            case 2:
                thirdInput.image  = palceimage
            default:
                fourthInput.image  = palceimage
            break
        }
        
        if counter == 3{
            
            var finalState = "\(initialState)"
            
            var passcode = returnPasscode(finalState)
            
            sparkFunction(passcode)
            
        }else{
            
            counter++
            
        }
        
    }
    
    func returnPasscode(state: String) -> String {
        var passcode = state
        passcode = passcode.stringByReplacingOccurrencesOfString("[", withString: "")
        passcode = passcode.stringByReplacingOccurrencesOfString("]", withString: "")
        passcode = passcode.stringByReplacingOccurrencesOfString(", ", withString: "")
        return passcode
    }
    
    func resetAll(state: Bool){
        
        initialState = [0,0,0,0]
        counter = 0
        let delay  = 0.5 * Double(NSEC_PER_SEC)
        let delay2 = 1.5 * Double(NSEC_PER_SEC)
        let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        let time2 = dispatch_time(DISPATCH_TIME_NOW, Int64(delay2))
        
        if(state == false){  // Errors or Wrong Password
            
            shakeImage(firstInput)
            shakeImage(secondInput)
            shakeImage(thirdInput)
            shakeImage(fourthInput)
            
            resetImage(time) // RESET IMAGE CIRCLES AT THE TOP
            
        }else{              // All Good!
            
            dispatch_after(time, dispatch_get_main_queue()) {  // PLACE GREEN CIRCLES!
                self.firstInput.image  = self.correimage
                self.secondInput.image = self.correimage
                self.thirdInput.image  = self.correimage
                self.fourthInput.image = self.correimage
            }
            
            resetImage(time2) // RESET IMAGE CIRCLES AT THE TOP
            
        }
        
    }
    
    func resetImage(time:dispatch_time_t){
        dispatch_after(time, dispatch_get_main_queue()) {
            self.firstInput.image  = self.resetimage
            self.secondInput.image = self.resetimage
            self.thirdInput.image  = self.resetimage
            self.fourthInput.image = self.resetimage
        }
    }
    
    private func sparkFunction(code: String) {
        
        var url = NSURL(string: "https://api.spark.io/v1/devices/\(deviceToken)/doorControl")
        var request = NSMutableURLRequest(URL: url!)
        var session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "POST"
        
        var params  = code
        var message = "access_token=\(accessToken)&params=\(params)"
        var value   = 0
        
        request.HTTPBody = (message as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            if error == nil {
                
                var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                
                // println(strData!) // Imprimimos la informacion.
                
                var jsonError: NSError?
                let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError) as NSDictionary
                
                var sparkError = json.objectForKey("error")        as? String
                var sparkValue = json.objectForKey("return_value") as? Int
                
                
                if sparkError != nil {
                    
                    println("json error: \(sparkError)")
                    self.alert.title = "Spark error"
                    self.alert.message = sparkError!
                    self.alert.addButtonWithTitle("Ooou!")
                    self.alert.show()
                    
                } else {
                    
                    value = sparkValue!
                    
                }
                
            }else{
                
                println("Request Error.")
                self.alert.title = "Request Error"
                self.alert.message = "There is a problem with your connection"
                self.alert.addButtonWithTitle("Ooou!")
                self.alert.show()
                
            }

            if value == 1 {
                
                println("Come in")
                self.resetAll(true)
                
            }else{
                
                println("Wrong Password")
                self.resetAll(false)
                
            }
            
        })//task
        
        task.resume()
    }
    
    func shakeImage(input: UIImageView){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(input.center.x - 10, input.center.y))
        animation.toValue = NSValue(CGPoint: CGPointMake(input.center.x + 10, input.center.y))
        input.layer.addAnimation(animation, forKey: "position")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set random background image.
        var randomNumber     = Int(arc4random_uniform(UInt32(backgroundImages.count)))
        var background       = UIImage(named: "\(backgroundImages[randomNumber]).jpg")
        mainBackground.image = background
        mainBackground.alpha = 0.1
        self.view.sendSubviewToBack(mainBackground)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

