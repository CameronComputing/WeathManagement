//
//  BusinessDetailViewController.swift
//  Wealth Management Prototype
//
//  Created by Nicholas Cameron on 2017-08-22.
//  Copyright © 2017 CameronComputing. All rights reserved.
//

import UIKit

class BusinessDetailViewController: UIViewController,UINavigationControllerDelegate,UINavigationBarDelegate {

    @IBOutlet weak var imageSatisfaction: UIImageView!
    @IBOutlet weak var lblReviewerRating: UILabel!
    @IBOutlet weak var lblRatedBy: UILabel!
    @IBOutlet weak var lblReview: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var activityIndicator = UIActivityIndicatorView()
    var business:Business?
 
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
        if let business = business{
        YelpAPIManager.getYelpReviewResult(business: business) { (statusCode) in
            DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.setUpContent()
            }

        }
    }
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setUpView(){
        activityIndicator.frame = CGRect(x: UIScreen.main.bounds.width / 2 - 10 , y:  UIScreen.main.bounds.height / 2, width: 20, height: 20)
        activityIndicator.color = .black
        activityIndicator.startAnimating()
        self.view.addSubview(self.activityIndicator)
        
    }
    
    
    
    func setUpContent(){
        
        if let business = self.business{
            imageView.image = business.image
            lblRating.text = "Overall Rating: " + String(describing: business.rating!)
            lblReview.text = business.review?.review
            lblRatedBy.text = "Review done by: " + (business.review?.reviewerName!)!
            lblReviewerRating.text = "Reviewer Rating: " + String(describing: business.review!.reviewerRating!)
            
            switch business.review!.positiveLevel! {
            case .happy:
                imageSatisfaction.image = UIImage(named: "happyFace")
            case .medium:
                imageSatisfaction.image = UIImage(named: "mediumFace")
            case .angry:
                imageSatisfaction.image = UIImage(named: "angryFace")
            }
            
        }
        
        navigationController?.navigationBar.topItem?.title = business!.title!
    }
    
    
        @IBAction func didTapBackBtn(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    @available(iOS 2.0, *)
     public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        return true
    }
    

}
