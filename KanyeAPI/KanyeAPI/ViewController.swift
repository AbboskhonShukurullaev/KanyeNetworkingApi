//
//  ViewController.swift
//  KanyeAPI
//
//  Created by 1 on 23/11/21.
//

import UIKit

class ViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var quoteButton: UIButton!
    @IBOutlet weak var kanyeImageView: UIImageView!
    
    //MARK: - Constants
    let networker = Networker.shared
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getImage()
        setupViews()
    }
    
    //MARK: - Internal methods
    @IBAction func quoteButtonAction(_ sender: Any) {
        networker.getQuote { (kanyeJson, error) -> (Void) in
            if let _ = error {
                self.quoteLabel.text = "Error"
                return
            }
            self.quoteLabel.text = kanyeJson?.quote
        }
    }
    
    //MARK: - Private methods
    private func getImage() {
        networker.getImage { data, error in
            if let error = error {
                print(error)
                return
            }
            self.kanyeImageView.image = UIImage(data: data!)
        }
    }
    
    private func setupViews() {
        quoteLabel.text = "Kanye quotes appear here"
        quoteLabel.numberOfLines = 0
        
        quoteButton.backgroundColor = .systemBlue
        quoteButton.setTitleColor(.white, for: .normal)
    }
}

