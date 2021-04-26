//
//  MovieTableViewCell.swift
//  MovieSearcher
//
//  Created by Mohamad Eslami on 2/4/1400 AP.
//

import UIKit
import Alamofire

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet var movieTitleLabel : UILabel!
    @IBOutlet var movieYearLabel : UILabel!
    @IBOutlet var moviePosterImageView : UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static let identifier = "MovieTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "MovieTableViewCell", bundle: nil)
    }
    
    func configure(with model : Movie){
        self.movieYearLabel.text = model.Year
        self.movieTitleLabel.text = model.Title
        let url = model.Poster
        
        AF.request(url , method: .get).response { response in
            if let data = response.value {
                self.moviePosterImageView.image = UIImage(data: data!)
            } else {
                print("error")
            }
        }
        
//        DispatchQueue.main.async {
//            if let data = try? Data(contentsOf: URL(string: url)!){
//                self.moviePosterImageView.image = UIImage(data: data)
//            }
//        }
        
        
    }
    
}
