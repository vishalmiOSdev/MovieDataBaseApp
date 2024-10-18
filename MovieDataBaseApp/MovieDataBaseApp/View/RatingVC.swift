//
//  RatingVC.swift
//  MovieDataBaseApp
//
//  Created by Vishal Manhas on 18/10/24.
//

import UIKit

class RatingVC: UIViewController {
    
    var ratingSource:[RatingSource]?
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var ratingSourceText:UILabel!
    @IBOutlet weak var ratingValue:UILabel!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      configureUI()
    }
    
    func configureUI(){
        segmentedControl.removeAllSegments()
        
        if ratingSource?.isEmpty == true{
            segmentedControl.insertSegment(withTitle: "No Rating Found", at: 0, animated: false)
            segmentedControl.isEnabled = false
            ratingSourceText.isHidden = true
            ratingValue.isHidden = true
        } else {
            
            if let ratingSource =  ratingSource?[0].source{
                self.ratingSourceText.text = ratingSource
            }else{
                self.ratingSourceText.text = "Not found"
            }
            
            
             if let ratingValue =  ratingSource?[0].value{
                 self.ratingValue.text = ratingValue
             }else{
                 self.ratingValue.text = "Not found"
             }
            
            for rating in 0..<(ratingSource?.count ?? 0){
                segmentedControl.insertSegment(withTitle: self.ratingSource?[rating].source, at: rating, animated: false)
            }
            segmentedControl.isEnabled = true
            segmentedControl.selectedSegmentIndex = 0
        }
        
        view.backgroundColor = .black.withAlphaComponent(0.2)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutside))
        view.addGestureRecognizer(tapGesture)
    }
    
    
    @objc private func handleTapOutside() {
        dismiss(animated: false, completion: nil)
    }

    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        if ratingSource?.isEmpty  == true{
            print("No data available")
            return
        }
        let selectedIndex = sender.selectedSegmentIndex
       
        if let ratingSource =  ratingSource?[selectedIndex].source{
            self.ratingSourceText.text = ratingSource
        }else{
            self.ratingSourceText.text = "Not found"
        }
        
        
         if let ratingValue =  ratingSource?[selectedIndex].value{
             self.ratingValue.text = ratingValue
         }else{
             self.ratingValue.text = "Not found"
         }
    }
}
