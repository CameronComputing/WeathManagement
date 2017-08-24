//
//  ViewController.swift
//  Wealth Management Prototype
//
//  Created by Nicholas Cameron on 2017-08-21.
//  Copyright © 2017 CameronComputing. All rights reserved.
//

import UIKit
import Foundation
class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnAsc: UIButton!
    @IBOutlet weak var btnDesc: UIButton!
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        let nib = UINib(nibName: "MainCollectionCells", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "mainCollectionCells")
        self.collectionView.delegate = self
        searchBar.delegate = self
      
        setUpActivityIndicator()
            
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpActivityIndicator(){
        activityIndicator.frame = CGRect(x: UIScreen.main.bounds.width / 2 - 10 , y: self.collectionView.frame.height / 2, width: 20, height: 20)
        activityIndicator.color = .black
        self.view.addSubview(self.activityIndicator)

    }
    
    func configureCells(){
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width

        layout.itemSize = CGSize(width: width / 2, height: width / 2)
        
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 0
        self.collectionView.collectionViewLayout = layout
        
    }
    
    //MARK: Collection View Delegate methods
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
    
    }
    
    //MARK: Collection View DataSource methods

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return  AppController.shared.Businesses.count
    }
    
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainCollectionCells", for: indexPath) as! mainCollectionCells
   
        cell.imageView.image = AppController.shared.Businesses[indexPath.row].image
        cell.lblAddress.text = AppController.shared.Businesses[indexPath.row].address
        cell.lblTitle.text = AppController.shared.Businesses[indexPath.row].title
    
        return cell
    }
    
    
     public func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }

    
    //MARK: UITextField Delegate Methods
    
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
       // self.performSegue(withIdentifier: "businessDetailSegue", sender: nil)
    
        let businessDetailVc = storyboard?.instantiateViewController(withIdentifier: "businessDetailSegue") as! BusinessDetailViewController
        
        businessDetailVc.business = AppController.shared.Businesses[indexPath.row]
        navigationController?.pushViewController(businessDetailVc, animated: true)
    }

    
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      
        if activityIndicator.isAnimating == false{
            activityIndicator.startAnimating()
            searchBar.resignFirstResponder()
            YelpAPIManager.getYelpKeywordSearchResult(keyword: searchBar.text!) { (code) in
               
                self.collectionView.dataSource = self
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                DispatchQueue.main.async {
                    if code == 200{
                        self.collectionView.performBatchUpdates(
                        {
                            self.collectionView.reloadSections(NSIndexSet(index: 0) as IndexSet)
                        }, completion: { (finished:Bool) -> Void in
                            
                        })
                        
                        self.configureCells()
                        
                    }else{
                        Alerts.dynamicAlert(viewController:self,title:"No results" , message:"please try again")
                    }
                }
            }
        }
    }
    
    
    //MARK: Sorting Methods
    
    @IBAction func btnAscTaped(_ sender: Any) {
        
        
        if btnAsc.currentTitleColor != .green && btnDesc.currentTitleColor == .green{
            btnAsc.setTitleColor(.green, for: .normal)
            btnDesc.setTitleColor(.white, for: .normal)
        }else{
            btnAsc.setTitleColor(.green, for: .normal)
        }
        if AppController.shared.Businesses.count != 0{
            AppController.shared.Businesses.sort(by:{$0.title?.compare($1.title!) == ComparisonResult.orderedAscending})
            self.collectionView.performBatchUpdates(
                {
                 self.collectionView.reloadSections(NSIndexSet(index: 0) as IndexSet)
            }, completion: { (finished:Bool) -> Void in
            })
        }
    }
    

    @IBAction func btnDescTapped(_ sender: Any) {
      
        if btnDesc.currentTitleColor != .green && btnAsc.currentTitleColor == .green{
            btnDesc.setTitleColor(.green, for: .normal)
            btnAsc.setTitleColor(.white, for: .normal)
        }else{
            btnDesc.setTitleColor(.green, for: .normal)
        }
        
        if AppController.shared.Businesses.count != 0{
            AppController.shared.Businesses.sort(by:{$0.title?.compare($1.title!) == ComparisonResult.orderedDescending})
            self.collectionView.performBatchUpdates(
                {
                    self.collectionView.reloadSections(NSIndexSet(index: 0) as IndexSet)
            }, completion: { (finished:Bool) -> Void in
           
            })
        }
        
    }
}

