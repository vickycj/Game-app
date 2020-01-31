//
//  LandingViewController.swift
//  DigiDino
//
//  Created by Raghu Sairam on 31/01/20.
//  Copyright © 2020 DBS. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {
    
    let postURL = "http://100.0.1.197:8080/digigame/postTask"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func goToGame(_sender : AnyObject){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "gameView") as! GameViewController
        //self.navigationController?.pushViewController(nextViewController, animated: true)
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    @IBAction func loginIb(_sender: AnyObject) {
        self.doTask(taskId: 1)
    }
    
    @IBAction func doTransaction(_sender: AnyObject) {
        let transactionOptions = UIAlertController(title: "TRANSACTION", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        
        let fifteenKTransaction = UIAlertAction(title: "Fund in 15k", style: .default) { (action: UIAlertAction) in
            self.doTask(taskId: 2)
        }
        
        let debitCardTransaction = UIAlertAction(title: "Debit Card more than 500", style: .default) { (action: UIAlertAction) in
            self.doTask(taskId: 3)
        }
        
        let tenKTransaction = UIAlertAction(title: "Transact 10k", style: .default) { (action: UIAlertAction) in
            self.doTask(taskId: 4)
        }
        
        let thirtyKTransaction = UIAlertAction(title: "Transact 30k", style: .default) { (action: UIAlertAction) in
            self.doTask(taskId: 5)
        }
        
        let upiTransaction = UIAlertAction(title: "UPI Transaction", style: .default) { (action: UIAlertAction) in
            self.doTask(taskId: 6)
        }
        

        transactionOptions.addAction(tenKTransaction)
        transactionOptions.addAction(debitCardTransaction)
        transactionOptions.addAction(fifteenKTransaction)
        transactionOptions.addAction(thirtyKTransaction)
        transactionOptions.addAction(upiTransaction)
        self.present(transactionOptions, animated: true, completion: nil)
    }
    
    @IBAction func deposit(_sender: AnyObject) {
        doTask(taskId: 7)
    }
    
    @IBAction func mutualFund(_sender: AnyObject) {
        doTask(taskId: 8)
    }
    
    @IBAction func referral(_sender: AnyObject) {
        doTask(taskId: 9)
    }
    
    func doTask(taskId: Int) {
        let Url = String(format: postURL)
        guard let serviceUrl = URL(string: Url) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let data : Data = "userId=\(appDelegate.userID)&taskId=\(taskId)".data(using: .utf8)!
        request.httpBody = data
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    DispatchQueue.main.async {
                        self.showSuccessAlert()
                    }
                } catch {
                    print(error)
                }
            }
            }.resume()
    }
    
    func showSuccessAlert() {        
        let alert = UIAlertView(title: "Yahooo!!!", message: "You have earned a gift. Please open Digi Dino game to see.", delegate: nil, cancelButtonTitle: "OK")
        let imageView = UIImageView(frame: CGRect(x: 220, y: 50, width: 60, height:60))
        let img = UIImage(named: "smile")
        imageView.contentMode = .scaleAspectFit
        
        imageView.image = img
        if floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1 {
            alert.setValue(imageView, forKey: "accessoryView")
        } else {
            alert.addSubview(imageView)
        }
        alert.show()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
