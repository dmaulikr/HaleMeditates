//
//  SessionTableViewCell.swift
//  Hale Meditates
//
//  Created by Ryan Pillsbury on 9/4/15.
//  Copyright (c) 2015 koait. All rights reserved.
//

import UIKit

class SessionTableViewCell: UITableViewCell {
    
    var model: AudioSession? {
        didSet {
            setUI();
        }
    }
    
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var instructorImage: UIImageView!
    @IBOutlet weak var instructorNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUI() {
        self.titlelabel.text = self.model?.title
        if self.model != nil {
            self.durationLabel.text = UIUtil.formatTimeStringLong(self.model!.duration);
        } else {
            self.durationLabel.text = "";
        }
        
        self.instructorNameLabel.text = (self.model?.instructorName != nil) ? self.model?.instructorName : "";
        
        
        
        if self.model?.instructorImage == nil {
            if (self.model?.instructorImageUrl != nil) {
                Util.enqueue(({
                    var url = self.model!.instructorImageUrl!;
                    if let data = HttpUtil.GET(url, body: nil, headers: nil, isAsync: false, callback: nil) {
                        dispatch_async(dispatch_get_main_queue(), ({
                            if (url == self.model?.instructorImageUrl) {
                                var image = UIImage(data: data);
                                self.model?.instructorImage = image;
                                self.instructorImage.image = self.model?.instructorImage;
                            }
                        }));
                    }
                    
                }), priority: Util.PRIORITY.SUPER_HIGH)
            }
        } else {
            self.instructorImage.image = self.model?.instructorImage
        }
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
