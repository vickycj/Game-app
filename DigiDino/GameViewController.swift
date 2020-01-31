//
//  GameViewController.swift
//  DigiDino
//
//  Created by Raghu Sairam on 31/01/20.
//  Copyright © 2020 DBS. All rights reserved.
//

import UIKit

struct UserDataResponse: Codable {
    let allTasksCompleted: Bool?
    let currentLevel : Int?
    let tasksList : [TaskDetails]?
    let animalsObtained : [AnimalDetails]?
}

struct TaskDetails: Codable {
    let taskCompleted: Bool?
    let taskDescription : String?
    let taskId : Int?
    let taskLevel : Int?
}

struct AnimalDetails: Codable {
    let animalCategory: String?
    let animalName : String?
    let value : Int?
}

class GameViewController: UIViewController {
    
    var lionView: UIView = UIView()
    var tigerView: UIView = UIView()
    var goatView: UIView = UIView()
    var monkeyView: UIView = UIView()
    var dinoView: UIView = UIView()
    
    @IBOutlet var activityIndicator : UIActivityIndicatorView!
    
    var userResponse : UserDataResponse!
    let getURL = "http://100.0.1.197:8080/digigame/getUserDetails?userId=%d"
    
    let shareURL = "http://100.0.1.197:8080/digigame/shareAnimal"

    @IBOutlet weak var buttonShowStatus: UIButton!
    
    var selectedAnimal : Int = 0
    var selectedAnimalView : UIImageView = UIImageView()
    
    
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    //@IBOutlet weak var imageTrailingConstraint: NSLayoutConstraint!
    
    
    
    var isShowingHint  = false
    
    @IBAction func close(_sender : AnyObject){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func anAction(_sender : AnyObject){
        if !isShowingHint {
            isShowingHint = true
            trailingConstraint.constant = 200
            self.lionView.frame.origin.x -= 200
            self.monkeyView.frame.origin.x -= 200
        } else {
            isShowingHint = false
            trailingConstraint.constant =  0
            self.lionView.frame.origin.x += 200
            self.monkeyView.frame.origin.x += 200
        }
    }
    
    var lionCount = 0
    
    var tigerCount = 0
    
    var goatCount = 0
    
    var monkeyCount = 0
    
    var dinoCount = 0
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        
        trailingConstraint.constant = 0
        
        lionView.tag = 1000
        tigerView.tag = 1001
        monkeyView.tag = 1002
        goatView.tag = 1003
        lionView.tag = 1004
        
        getUserData()
        
       // updateView()
    }
    
    func refresh() {
//        userResponse = nil
//        DispatchQueue.main.async() {
//            self.lionView.removeFromSuperview()
//            self.tigerView.removeFromSuperview()
//            self.goatView.removeFromSuperview()
//            self.monkeyView.removeFromSuperview()
//            self.dinoView.removeFromSuperview()
//            self.goatCount = 0
//            self.monkeyCount = 0
//            self.tigerCount = 0
//            self.lionCount = 0
//            self.dinoCount = 0
//            self.updateView()
//        }
//        getUserData()
//        DispatchQueue.main.async() {
//            self.goatView.removeFromSuperview()
//            self.selectedAnimalView.isHidden = true
//        }
        
//        selectedAnimalView.alpha = 0
//        for view in selectedAnimalView.subviews {
//            view.isHidden = true
//        }
//        selectedAnimalView.layer.removeAllAnimations()
        if selectedAnimal == 1 {
            UIView.animate(withDuration: 2.0, animations: {
                self.selectedAnimalView.frame = CGRect(x: -120, y: 0, width: 120, height: 120)
            })
        } else if selectedAnimal == 3 {
            UIView.animate(withDuration: 2.0, animations: {
                self.selectedAnimalView.frame = CGRect(x: -120, y: 100, width: 120, height: 120)
            })
        } else if selectedAnimal == 4 {
            UIView.animate(withDuration: 2.0, animations: {
                self.selectedAnimalView.frame = CGRect(x: self.view.frame.width, y: self.view.frame.size.height - 120, width: 120, height: 120)
            })
        } else {
            self.selectedAnimalView.isHidden = true
        }
    }
    
    @objc func tapAnimal(_ sender: UITapGestureRecognizer) {
        selectedAnimal = sender.view?.tag ?? 0
        selectedAnimalView = sender.view as! UIImageView
        openAlertView()
    }
    
    var textField: UITextField?
    
    func configurationTextField(textField: UITextField!) {
        if (textField) != nil {
            self.textField = textField!        //Save reference to the UITextField
            self.textField?.placeholder = "Some text";
        }
    }
    
    func openAlertView() {
        let alert = UIAlertController(title: "Please enter sender details", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(configurationHandler: configurationTextField)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ (UIAlertAction) in
            if let toUserId = Int(self.textField?.text ?? "0") {
                self.shareAnimal(animalValue: self.selectedAnimal, toUserId: toUserId)
                //self.refresh()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateView() {
        activityIndicator.stopAnimating()
        lionView = UIView()
        tigerView = UIView()
        monkeyView = UIView()
        goatView = UIView()
        dinoView = UIView()
        
        if lionCount > 0 {
            lionView.frame = CGRect(x: 0, y: self.view.frame.size.height - 120, width: self.view.frame.width, height: 120)
            for i in 1...lionCount {
                
                let lion = UIImageView()
                let newTap = UITapGestureRecognizer(target: self, action: #selector(self.tapAnimal(_:)))
                lion.isUserInteractionEnabled = true
                lion.addGestureRecognizer(newTap)
                lion.tag = 4
                
                lion.image = UIImage(named: "lion")
                
                lion.frame = CGRect(x: self.view.frame.width, y: 0, width: 120, height: 120)
                
                UIView.animate(withDuration: (TimeInterval(1.0 + CGFloat(i))), animations: {
                    
                    let gapBetweenLions : CGFloat = CGFloat((self.lionCount*40)) - CGFloat((i-1) * 40)
                    
                    lion.frame = CGRect(x: self.view.frame.width - lion.frame.width - 20 - gapBetweenLions, y: lion.frame.origin.y, width: lion.frame.width, height: lion.frame.height)
                    
                })
                
                lionView.addSubview(lion)
                
            }
            
            self.view.addSubview(lionView)
        }
        
        
        if tigerCount > 0 {
            tigerView.frame = CGRect(x: 0, y: 100, width: self.view.frame.width, height: 120)
            
            
            for i in 1...tigerCount {
                
                let tiger = UIImageView()
                let newTap = UITapGestureRecognizer(target: self, action: #selector(self.tapAnimal(_:)))
                tiger.isUserInteractionEnabled = true
                tiger.addGestureRecognizer(newTap)
                tiger.tag = 3
                
                var imageName = "tiger"
                
                if i%2 == 0 {
                    imageName = "tiger1"
                }
                
                let tigerGif = UIImage.gifImageWithName(name: imageName)
                
                tiger.image = tigerGif
                
                tiger.frame = CGRect(x: -120, y: 0, width: 120, height: 120)
                
                UIView.animate(withDuration: (TimeInterval(1.0 + CGFloat(i))), animations: {
                    let gapBetweenTigers : CGFloat = CGFloat((self.tigerCount*40)) - CGFloat((i) * 40)
                    tiger.frame = CGRect(x: 40 + gapBetweenTigers, y: tiger.frame.origin.y, width: tiger.frame.width, height: tiger.frame.height)
                })
                tigerView.addSubview(tiger)
                
            }
            self.view.addSubview(tigerView)
            
        }
        
        if goatCount > 0 {
            goatView.frame = CGRect(x: 0, y: self.view.frame.height - 100, width: self.view.frame.width, height: 120)
            
            for i in 1...goatCount {
                
                let goat = UIImageView()
                goat.tag = 1
                
                let newTap = UITapGestureRecognizer(target: self, action: #selector(self.tapAnimal(_:)))
                goat.isUserInteractionEnabled = true
                goat.addGestureRecognizer(newTap)
                

                let goatGif = UIImage.gifImageWithName(name: "goat1")
                
                goat.image = goatGif
                
                goat.frame = CGRect(x: -120, y: 0, width: 120, height: 120)
                
                UIView.animate(withDuration: (TimeInterval(1.0 + CGFloat(i))), animations: {
                    let gapBetweenGoat : CGFloat = CGFloat((self.goatCount*40)) - CGFloat((i) * 40)
                    goat.frame = CGRect(x: 40 + gapBetweenGoat, y: goat.frame.origin.y, width: goat.frame.width, height: goat.frame.height)
                })
                goatView.addSubview(goat)
            }
            self.view.addSubview(goatView)
        }
        
        
        if monkeyCount > 0 {
            monkeyView.frame = CGRect(x: self.view.frame.width - 300, y: 50, width: self.view.frame.width, height: 120)
            
            var tempXAxis = 0
            
            for _ in 1...monkeyCount {
                
                let monkey = UIImageView()
                let newTap = UITapGestureRecognizer(target: self, action: #selector(self.tapAnimal(_:)))
                monkey.isUserInteractionEnabled = true
                monkey.addGestureRecognizer(newTap)
                monkey.tag = 2
                let monkeyGif = UIImage.gifImageWithName(name: "monkey")
                
                monkey.image = monkeyGif
                
                monkey.frame = CGRect(x: tempXAxis, y: 0, width: 60, height: 120)
                
                tempXAxis += 60
                monkeyView.addSubview(monkey)
            }
            self.view.addSubview(monkeyView)
        }
        
        
        dinoView.frame = CGRect(x: self.view.frame.width/2 - 150, y: 0, width: 240, height: self.view.frame.height)
        if dinoCount > 0 {
            let dino = UIImageView()
            dino.image = UIImage(named: "dino")
            dino.frame = CGRect(x: 0, y: -self.view.frame.height, width: 240, height: self.view.frame.height)
            dino.contentMode = .scaleAspectFill
            UIView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
                dino.frame = CGRect(x: 0, y: 0, width: 240, height: self.view.frame.height)
            }) { _ in
                
            }
            dinoView.addSubview(dino)
        }
        self.view.addSubview(dinoView)
    }
    
    func getUserData() {
        goatCount = 0
        monkeyCount = 0
        tigerCount = 0
        lionCount = 0
        dinoCount = 0
        let req = NSMutableURLRequest(url: NSURL(string:String(format: getURL, appDelegate.userID))! as URL)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpMethod = "GET"
        URLSession.shared.dataTask(with: req as URLRequest) { data, response, error in
            guard error == nil else {
                return
            }
            guard let responseData = data else {
                return
            }
            do {
                if let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String: Any] {
                    do {
                        let json = try JSONSerialization.data(withJSONObject: jsonData)
                        print(jsonData)
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        self.userResponse = try decoder.decode(UserDataResponse.self, from: json)
                        for animals in self.userResponse?.animalsObtained ?? [] {
                            if animals.value == 1 {
                                self.goatCount += 1
                            } else if animals.value == 2 {
                                self.monkeyCount += 1
                            } else if animals.value == 3 {
                                self.tigerCount += 1
                            } else if animals.value == 4 {
                                self.lionCount += 1
                            } else if animals.value == 5 {
                                self.dinoCount += 1
                            }
                        }
                        DispatchQueue.main.async {
                            self.updateView()
                        }
                    } catch {
                        print(error)
                    }
                }
                
            } catch  {
                print(error)
            }
            }.resume()
    }
    
    func shareAnimal(animalValue: Int, toUserId: Int) {
        let Url = String(format: shareURL)
        guard let serviceUrl = URL(string: Url) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let data : Data = "fromUserId=\(appDelegate.userID)&toUserId=\(toUserId)&animalValue=\(animalValue)".data(using: .utf8)!
        request.httpBody = data
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        if let data = data {
                            do {
                                DispatchQueue.main.async {
                                    self.refresh()
                                }
                                //                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                            } catch {
                                print(error)
                            }
                        }
                    }
                }
            }
            }.resume()
    }
}



extension UIImage {
    
    
    
    public class func gifImageWithData(data: NSData) -> UIImage? {
        
        guard let source = CGImageSourceCreateWithData(data, nil) else {
            
            print("image doesn't exist")
            
            return nil
            
        }
        
        
        
        return UIImage.animatedImageWithSource(source: source)
        
    }
    
    
    
    public class func gifImageWithURL(gifUrl:String) -> UIImage? {
        
        guard let bundleURL = NSURL(string: gifUrl)
            
            else {
                
                print("image named \"\(gifUrl)\" doesn't exist")
                
                return nil
                
        }
        
        guard let imageData = NSData(contentsOf: bundleURL as URL) else {
            
            print("image named \"\(gifUrl)\" into NSData")
            
            return nil
            
        }
        
        
        
        return gifImageWithData(data: imageData)
        
    }
    
    
    
    public class func gifImageWithName(name: String) -> UIImage? {
        
        guard let bundleURL = Bundle.main
            
            .url(forResource: name, withExtension: "gif") else {
                
                print("SwiftGif: This image named \"\(name)\" does not exist")
                
                return nil
                
        }
        
        
        
        guard let imageData = NSData(contentsOf: bundleURL) else {
            
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            
            return nil
            
        }
        
        
        
        return gifImageWithData(data: imageData)
        
    }
    
    
    
    class func delayForImageAtIndex(index: Int, source: CGImageSource!) -> Double {
        
        var delay = 0.1
        
        
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        
        let gifProperties: CFDictionary = unsafeBitCast(CFDictionaryGetValue(cfProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()), to: CFDictionary.self)
        
        
        
        var delayObject: AnyObject = unsafeBitCast(CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()), to: AnyObject.self)
        
        
        
        if delayObject.doubleValue == 0 {
            
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
            
        }
        
        
        
        delay = delayObject as! Double
        
        
        
        if delay < 0.1 {
            
            delay = 0.1
            
        }
        
        
        
        return delay
        
    }
    
    
    
    class func gcdForPair(a: Int?, _ b: Int?) -> Int {
        
        var a = a
        
        var b = b
        
        if b == nil || a == nil {
            
            if b != nil {
                
                return b!
                
            } else if a != nil {
                
                return a!
                
            } else {
                
                return 0
                
            }
            
        }
        
        
        
        if a! < b! {
            
            let c = a!
            
            a = b!
            
            b = c
            
        }
        
        
        
        var rest: Int
        
        while true {
            
            rest = a! % b!
            
            
            
            if rest == 0 {
                
                return b!
                
            } else {
                
                a = b!
                
                b = rest
                
            }
            
        }
        
    }
    
    
    
    class func gcdForArray(array: Array<Int>) -> Int {
        
        if array.isEmpty {
            
            return 1
            
        }
        
        
        
        var gcd = array[0]
        
        
        
        for val in array {
            
            gcd = UIImage.gcdForPair(a: val, gcd)
            
        }
        
        
        
        return gcd
        
    }
    
    
    
    class func animatedImageWithSource(source: CGImageSource) -> UIImage? {
        
        let count = CGImageSourceGetCount(source)
        
        var images = [CGImage]()
        
        var delays = [Int]()
        
        
        
        for i in 0..<count {
            
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                
                images.append(image)
                
            }
            
            
            
            let delaySeconds = UIImage.delayForImageAtIndex(index: Int(i), source: source)
            
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
            
        }
        
        
        
        let duration: Int = {
            
            var sum = 0
            
            
            
            for val: Int in delays {
                
                sum += val
                
            }
            
            
            
            return sum
            
        }()
        
        
        
        let gcd = gcdForArray(array: delays)
        
        var frames = [UIImage]()
        
        
        
        var frame: UIImage
        
        var frameCount: Int
        
        for i in 0..<count {
            
            frame = UIImage(cgImage: images[Int(i)])
            
            frameCount = Int(delays[Int(i)] / gcd)
            
            
            
            for _ in 0..<frameCount {
                
                frames.append(frame)
                
            }
            
        }
        
        
        
        let animation = UIImage.animatedImage(with: frames, duration: Double(duration) / 1000.0)
        
        
        
        return animation
        
    }
    
    
}

extension UIViewController {
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}
