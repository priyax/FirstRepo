//
//  ViewController.swift
//  textToTableViewController
//
//  Created by Priya Xavier on 10/6/16.
//  Copyright © 2016 Guild/SA. All rights reserved.
//

import UIKit

class ExtractRecipe: UIViewController {

    @IBAction func backBtn(_ sender: UIButton) {
         _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func homeBtn(_ sender: UIButton) {
        let url = URL (string: "http://www.google.com/");
        let requestObj = URLRequest(url: url!);
        webView.loadRequest(requestObj);
    }
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let url = URL (string: "http://www.google.com/");
        let requestObj = URLRequest(url: url!);
        webView.loadRequest(requestObj);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
