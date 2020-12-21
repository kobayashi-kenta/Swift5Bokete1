//
//  ViewController.swift
//  Swift5Bokete1
//
//  Created by Kenta on 2020/12/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import Photos


class ViewController: UIViewController {

    
    @IBOutlet weak var odaiImageView: UIImageView!
    
    @IBOutlet weak var searchImageView: UITextField!
    
    @IBOutlet weak var CommentTextView: UITextView!
    
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        CommentTextView.layer.cornerRadius = 20.0
        
        PHPhotoLibrary.requestAuthorization{ (status) in
            
            switch(status){
                case .authorized: break
                case .denied :break
                case .limited :break
                case .notDetermined :break
                case.restricted :break
            }
        }
        getImages(keyword: "funny")
    }

    func getImages(keyword:String){
        let url = "https://pixabay.com/api/19611488-49019d7963f7289b17016c17e&q=\(keyword)"
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {
            (response) in
            
            switch response.result{
            
            case .success:
                let json:JSON = JSON(response.data as Any)
                var imageString = json["hits"][self.count]["webFormatURL"].string
                
                if imageString == nil {
                    imageString = json["hits"][0]["webFormatURL"].string
                self.odaiImageView.sd_setImage(with: URL(string: imageString!), completed: nil)
                }else{
                    self.odaiImageView.sd_setImage(with: URL(string: imageString!), completed: nil)
                }
                
                
                
               
                
            case .failure(let error):
                
                print(error)
                
            }
        }
    }
    
    
    @IBAction func nextOdai(_ sender: Any) {
        count += 1
        
        if searchImageView.text == ""{
            getImages(keyword: "funny")
        }else{
            
            getImages(keyword: searchImageView.text!)
        }
    }
    
    
    
    @IBAction func searchAction(_ sender: Any) {
        self.count = 0
        
        if searchImageView.text == ""{
            getImages(keyword: "funny")
        }else{
            
            getImages(keyword: searchImageView.text!)
        }
        
    }
    
    
    @IBAction func done(_ sender: Any) {
        
        performSegue(withIdentifier: "next", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let shareVC = segue.destination as? ShareViewController
        shareVC?.commentString = CommentTextView.text
        shareVC?.resultImage = odaiImageView.image!
    }
    
}

