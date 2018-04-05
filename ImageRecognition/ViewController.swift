//
//  ViewController.swift
//  ImageRecognition
//
//  Created by Pedro Alonso on 4/3/18.
//  Copyright © 2018 Pedro Alonso. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController {

    @IBOutlet weak var objectLabel: UILabel!
    @IBOutlet weak var objectImage: UIImageView!
//    let imagePath = Bundle.main.path(forResource: "dog", ofType: "jpg")
//    let imageURL = NSURL.fileURL(withPath: imagePath!)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//         Do any additional setup after loading the view, typically from a nib.
        let imagePath = Bundle.main.path(forResource: "dog", ofType: "jpg")
        let imageURL = NSURL.fileURL(withPath: imagePath!)
        
        let modelFile = MobileNet()
        let model = try! VNCoreMLModel(for: modelFile.model)
        
        let handler = VNImageRequestHandler(url: imageURL)
        let request = VNCoreMLRequest(model: model, completionHandler:
            self.findResults)
        try! handler.perform([request])
    }

    func findResults(request: VNRequest, error: Error?) {
        guard let results = request.results as?
            [VNClassificationObservation] else {
                fatalError("Unable to get results")
        }
        var bestGuess = ""
        var bestConfidence: VNConfidence = 0
        for classification in results {
            if (classification.confidence > bestConfidence) {
                bestConfidence = classification.confidence
                bestGuess = classification.identifier
            }
        }
        objectLabel.text = "Image is: \(bestGuess) with confidence \(bestConfidence) out of 1"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

