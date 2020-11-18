//
//  FloatingAudioPlayerView.swift
//  FloatingAudioPlayer
//
//  Created by Zhangali Pernebayev on 11/12/20.
//

import UIKit
import AVFoundation

public protocol FloatingAudioPlayerViewDelegate: class {
    func floatingAudioPlayerViewDidTapPlay()
    func floatingAudioPlayerViewDidTapPause()
    func floatingAudioPlayerViewDidTapNext()
    func floatingAudioPlayerViewDidChangeProgress(progress: Float)
}

@IBDesignable
class FloatingAudioPlayerView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var audioImageView: UIImageView!
    @IBOutlet weak var audioNameLabel: UILabel!
    @IBOutlet weak var audioAuthorLabel: UILabel!
    @IBOutlet weak var playOrPauseBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    weak var delegate: FloatingAudioPlayerViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        nibSetup()
    }
    
    private func nibSetup() {
        backgroundColor = .clear
        
        contentView = loadViewFromNib()
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.translatesAutoresizingMaskIntoConstraints = true

        addSubview(contentView)
        
        playOrPauseBtn.setImage(UIImage(named: "pause", in: Bundle(for: Self.self), compatibleWith: nil), for: .selected)
        slider.tintColor = .white
        slider.setThumbImage(UIImage(named: "thumb", in: Bundle(for: Self.self), compatibleWith: nil), for: .normal)
        slider.setThumbImage(UIImage(named: "thumb", in: Bundle(for: Self.self), compatibleWith: nil), for: .highlighted)
        slider.addTarget(self, action: #selector(sliderChangedValue(_:)), for: .valueChanged)
    }

    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @IBAction func playOrPauseBtnTapHandler(_ sender: UIButton) {
        if sender.isSelected {
            delegate?.floatingAudioPlayerViewDidTapPause()
        }else{
            delegate?.floatingAudioPlayerViewDidTapPlay()
        }
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func nextButtonTapHandler(_ sender: UIButton) {
        delegate?.floatingAudioPlayerViewDidTapNext()
    }
    
    public func play(audioModel: FloatingAudioModel, delegate: FloatingAudioPlayerViewDelegate) {
        self.delegate = delegate
        setAudio(progress: audioModel.audioProgress)
        audioImageView.load(urlString: audioModel.imageURL, placeholder: UIImage(named: "note", in: Bundle(for: Self.self), compatibleWith: nil))
        audioNameLabel.text = audioModel.name
        audioAuthorLabel.text = audioModel.author
        playOrPauseBtn.isSelected = true
    }
    
    public func pause() {
        playOrPauseBtn.isSelected = false
    }
    
    public func setAudio(progress: Float) {
        if !slider.isHighlighted {
            slider.setValue(progress, animated: false)
        }
    }
    
    @objc private func sliderChangedValue(_ slider: UISlider) {
        delegate?.floatingAudioPlayerViewDidChangeProgress(progress: slider.value)
    }
}

extension UIImageView {
    /// Loads image from web asynchronosly and caches it, in case you have to load url
    /// again, it will be loaded from cache if available
    func load(url: URL, placeholder: UIImage?, cache: URLCache? = nil) {
        let cache = cache ?? URLCache.shared
        let request = URLRequest(url: url)
        if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
            self.image = image
        } else {
            self.image = placeholder
            DispatchQueue.global(qos: .userInitiated).async {
                URLSession.shared.dataTask(with: request, completionHandler: {[weak self] (data, response, error) in
                    
                    if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300 {
                        let cachedData = CachedURLResponse(response: response, data: data)
                        cache.storeCachedResponse(cachedData, for: request)
                        
                        DispatchQueue.main.async {
                            if let image = UIImage(data: data)  {
                                self?.image = image
                            }
                        }
                    }
                }).resume()
            }
        }
    }
    
    func load(urlString: String?, placeholder: UIImage?, cache: URLCache? = nil) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            self.image = placeholder
            return
        }
        load(url: url, placeholder: placeholder, cache: cache)
    }
}
