//
//  AudioPlaybackViewController.swift
//  Hale Meditates
//
//  Created by Ryan Pillsbury on 10/17/15.
//  Copyright © 2015 koait. All rights reserved.
//

import UIKit
import MediaPlayer

protocol AudioPlaybackDelegate: class {
    func handleTimeChange(current: Float, remaining: Float);
//    func handlePlaybackFinished();
}

class AudioPlaybackViewController: UIViewController {
    
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var currentPlaybackLabel: UILabel!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var timeScrubSlider: UISlider!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    var isScrubbing = false;
    let audioPlayer: AVPlayer = AppDelegate.audioPlayer
    var observerObject: AnyObject?
    var playImage = UIImage(named: "play_icon_no_border.png")!
    var pauseImage = UIImage(named: "pause_icon_no_border.png")!;
    var currentItem: AVPlayerItem?
    var removedDurationObserver = false;
    var model: AudioSession? {
        didSet {
            self.setStatesForNewTrack();
        }
    }
    var audioURL:String? {
        get {
            return self.model?.audioUrl;
        }
    }

    weak var delegate: AudioPlaybackDelegate?
    
    @IBAction func sliderFinishedScrubbing(sender: UISlider) {
        self.isScrubbing = false;
        let value = sender.value;
        let time = CMTimeMake(Int64(floor(value)), 1);
        self.audioPlayer.seekToTime(time);
        let current = Float(floor(CMTimeGetSeconds(time)));
        let remaining = Float(floor(CMTimeGetSeconds(self.audioPlayer.currentItem!.duration)) - floor(CMTimeGetSeconds(time)));
        setViewStateForTimeLabels(current, remaining: remaining);
        setViewStateForSlider(current);
        audioPlayer.play();
    }
    
    @IBAction func updateSliderLabels(sender: UISlider) {
        let value = sender.value;
        let time = CMTimeMake(Int64(floor(value)), 1);
        let current = Float(floor(CMTimeGetSeconds(time)));
        let remaining = Float(floor(CMTimeGetSeconds(self.audioPlayer.currentItem!.duration)) - floor(CMTimeGetSeconds(time)));
        setViewStateForTimeLabels(current, remaining: remaining);
    }
    
    @IBAction func sliderStartedScrubbing(sender: UISlider) {
        self.isScrubbing = true;
        audioPlayer.pause();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        audioPlayer.actionAtItemEnd = AVPlayerActionAtItemEnd.Pause;
        self.observerObject = audioPlayer.addPeriodicTimeObserverForInterval(CMTimeMake(1, 3), queue: nil, usingBlock: playbackTimeChanged)
        setInitialViewStates();
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        activityView.transform = CGAffineTransformMakeScale(0.75, 0.75);
    }
    
    func pause() {
        self.audioPlayer.pause();
        self.setViewStateForPlayPauseButton(true);
    }
    
    func play() {
        self.audioPlayer.play();
        self.setViewStateForPlayPauseButton(false);
    }
    
    func setInitialViewStates() {
        setViewStateForPlayPauseButton(true);
        setViewStateForSlider(0);
        self.currentPlaybackLabel.text = "-:--";
        self.timeLeftLabel.text = "-:--";
    }
    
    deinit {
        self.audioPlayer.removeTimeObserver(observerObject!);
        if (!removedDurationObserver) {
            self.currentItem?.removeObserver(self, forKeyPath: "duration");
        }
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated);
        self.audioPlayer.pause();
    }
    
    func isIndefiniteTimeValue(time: CMTime) -> Bool {
        return time.flags.rawValue & CMTimeFlags.Indefinite.rawValue != 0;
    }
    
    func playbackTimeChanged(time: CMTime) -> Void {
        if ((self.activityView.isAnimating()) == true) {
            self.activityView.stopAnimating()
        }
        
        if (self.playPauseButton.hidden) {
            self.playPauseButton.hidden = false;
        }
        
        
        if currentItem == nil {
            return;
        }
        
        let duration = self.audioPlayer.currentItem!.duration;
        
        if (!isIndefiniteTimeValue(duration)) {
            let current = Float(floor(CMTimeGetSeconds(time)));
            let remaining = Float(floor(CMTimeGetSeconds(self.audioPlayer.currentItem!.duration)) - floor(CMTimeGetSeconds(time)));
            setViewStateForTimeLabels(current, remaining: remaining);
            if (!isScrubbing) {
                setViewStateForSlider(current);
            }

            self.delegate?.handleTimeChange(current, remaining: remaining);
        }
    }
    
    func setViewStateForPlayPauseButton(isPlayIcon: Bool) {
        if (isPlayIcon) {
            self.playPauseButton.setImage(playImage, forState: UIControlState.Normal);
            self.playPauseButton.tag = 0;
        } else {
            self.playPauseButton.setImage(pauseImage, forState: UIControlState.Normal);
            self.playPauseButton.tag = 1;
        }
    }
    
    func setViewStateForSlider(value: Float) {
        self.timeScrubSlider.value = value
    }
    
    @IBAction func pauseOrPlay(sender: UIButton) {
        if (sender.tag == 0) {
            self.audioPlayer.play();
            self.setViewStateForPlayPauseButton(false);
        } else if (sender.tag == 1) {
            self.audioPlayer.pause();
            self.setViewStateForPlayPauseButton(true);
        }
    }
    
    
    private func timeFormat(value: Float) -> String {
        let minutes: Float = floor(floor(value) / 60.0)
        let seconds: Float = floor(value) - (minutes * 60.0);
        
        let roundedSeconds = lroundf(seconds);
        let roundedMinutes = lroundf(minutes);
        
        return NSString(format: "%d:%02d", roundedMinutes, roundedSeconds) as String
    }
    
    func setViewStateForTimeLabels(current: Float, remaining: Float) {
        self.currentPlaybackLabel.text = (current != Float.NaN) ? timeFormat(current) : "-:--";
        self.timeLeftLabel.text = (remaining != Float.NaN) ? timeFormat(remaining) : "-:--"
    }
    
    func itemDidFinishPlaying(notification: NSNotification) {
        self.setViewStateForSlider(0);
        self.setViewStateForPlayPauseButton(true);
        self.setViewStateForTimeLabels(0, remaining: Float(CMTimeGetSeconds(self.audioPlayer.currentItem!.duration)))
//        self.audioPlayer.seekToTime(CMTimeMake(0, 1))
    }
    
    func setStatesForNewTrack() {
        if (currentItem != nil && removedDurationObserver == false) {
            self.currentItem!.removeObserver(self, forKeyPath: "duration");
        }
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: self.currentItem);
        self.currentItem = AVPlayerItem(asset: AVAsset(URL: NSURL(string: self.model!.audioUrl!)!));
        if self.currentItem == nil {
            return;
        }
        self.audioPlayer.replaceCurrentItemWithPlayerItem(self.currentItem!);
        self.setViewStateForPlayPauseButton(false);
        self.playPauseButton.hidden = true;
        self.setViewStateForSlider(0);
        self.currentPlaybackLabel.text = "0:00";
        self.timeLeftLabel.text = "-:--";
        activityView.startAnimating();
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDidFinishPlaying:", name: AVPlayerItemDidPlayToEndTimeNotification, object: self.currentItem!)
        if (!isIndefiniteTimeValue(currentItem!.duration)) {
            setUIForTrack();
            self.removedDurationObserver = true;
        } else {
            self.currentItem!.addObserver(self, forKeyPath: "duration", options: [], context: nil);
            self.removedDurationObserver = false;
        }
    }
    
    func setUIForTrack() {
        if self.currentItem != nil {
            self.timeScrubSlider.maximumValue = Float(CMTimeGetSeconds(self.audioPlayer.currentItem!.duration));
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "duration" {
            dispatch_async(dispatch_get_main_queue(), {
                self.setUIForTrack()
            })
            self.currentItem!.removeObserver(self, forKeyPath: "duration");
            self.removedDurationObserver = true;
        }
    }
}

