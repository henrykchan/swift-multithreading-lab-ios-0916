//
//  ImageViewController.swift
//  swift-multithreading-lab
//
//  Created by Ian Rahman on 7/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import UIKit
import CoreImage


//MARK: Image View Controller

class ImageViewController : UIViewController {
    
    var scrollView: UIScrollView!
    var imageView = UIImageView()
    let picker = UIImagePickerController()
    var activityIndicator = UIActivityIndicatorView()
    let filtersToApply = ["CIBloom",
                          "CIPhotoEffectProcess",
                          "CIExposureAdjust"]
    
    var flatigram = Flatigram()
    
    @IBOutlet weak var filterButton: UIBarButtonItem!
    @IBOutlet weak var chooseImageButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        setUpViews()
    }
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        selectImage()
    }
    
    @IBAction func filterButtonTapped(_ sender: AnyObject) {
        
        switch (flatigram.state) {
        case .unfiltered:
            startProcess()
        case .filtered:
            presentFilteredAlert()
        }
    }
    
}



extension ImageViewController {
    
    func filterImage(with completion: @escaping (Bool) -> ()) {
        
        
        let queue = OperationQueue()
        queue.name = "Image Filtration queue"
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .userInitiated
        
        for eachFilter in filtersToApply {
            
            let filterer = FilterOperation(flatigram: flatigram, filter: eachFilter)
            filterer.completionBlock = {
                
                if filterer.isCancelled {
                    completion(false)
                    return
                }
                
                if queue.operationCount == 0 {
                    
                    DispatchQueue.main.async(execute: {
                        self.flatigram.state = .filtered
                        completion(true)
                    })
                }
            }
        
            queue.addOperation(filterer)
            print("Added FilterOperation with \(eachFilter) to \(queue.name!)")
        }
    }
    
    
    func startProcess() {
        
        activityIndicator.startAnimating()
        filterButton.isEnabled = false
        chooseImageButton.isEnabled = false
        
        filterImage{ result in
            
            OperationQueue.main.addOperation {
                if result {
                    print ("Image successfully filtered")
                }
                else {
                    print ("Image filtering did not complete")
                }
                
                self.imageView.image = self.flatigram.image
                self.activityIndicator.stopAnimating()
                self.filterButton.isEnabled = true
                self.chooseImageButton.isEnabled = true
            }
        }
    }
}
