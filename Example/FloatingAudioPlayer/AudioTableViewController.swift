//
//  AudioTableViewController.swift
//  FloatingAudioPlayer_Example
//
//  Created by Zhangali Pernebayev on 11/15/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import FloatingAudioPlayer
import AVFoundation

class AudioTableViewController: UITableViewController {

    enum Mode {
        case music
        case podcast
        
        var title: String {
            switch self {
            case .music:
                return "Music"
            case .podcast:
                return "Podcast"
            }
        }
    }
    
    private let mode: Mode
    private let musicArray: [AudioModel] = [
        AudioModel(name: "Bleu Channel", author: "ARIA", fileName: "bleu_channel"),
        AudioModel(name: "All That", author: "Bensound", fileName: "allthat"),
        AudioModel(name: "Elevate", author: "Bensound", fileName: "elevate"),
        AudioModel(name: "Endless Motion", author: "Bensound", fileName: "endlessmotion"),
        AudioModel(name: "Inspire", author: "Bensound", fileName: "inspire"),
        AudioModel(name: "Perception", author: "Bensound", fileName: "perception")
    ]
    private let podcastArray: [AudioModel] = [
        AudioModel(name: "English at Work: Episode 1", author: "BBC", fileName: "English1"),
        AudioModel(name: "English at Work: Episode 2", author: "BBC", fileName: "English2"),
        AudioModel(name: "English at Work: Episode 3", author: "BBC", fileName: "English3"),
        AudioModel(name: "English at Work: Episode 4", author: "BBC", fileName: "English4"),
        AudioModel(name: "English at Work: Episode 5", author: "BBC", fileName: "English5"),
        AudioModel(name: "English at Work: Episode 6", author: "BBC", fileName: "English6"),
        AudioModel(name: "English at Work: Episode 7", author: "BBC", fileName: "English7")
    ]
    private static var player: AVAudioPlayer?
    private var currentPlayinAudioIndex: Int = 0
    private var timer: Timer?
    
    init(mode: Mode) {
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        timer?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureTableView()
    }
    
    private func configureNavBar() {
        self.navigationItem.title = mode.title
    }
    
    private func configureTableView() {
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 88, bottom: 0, right: 0)
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch mode {
        case .music:
            return musicArray.count
        case .podcast:
            return podcastArray.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        switch mode {
        case .music:
            cell.setup(audio: musicArray[indexPath.row])
        case .podcast:
            cell.setup(audio: podcastArray[indexPath.row])
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        playAudio(at: indexPath.row)
    }
}

extension AudioTableViewController {
    private func playAudio(at index: Int) {
        AudioTableViewController.player?.stop()
        self.timer?.invalidate()
        
        self.currentPlayinAudioIndex = index
        let audioModel: AudioModel = (mode == .music) ? musicArray[index]:podcastArray[index]
        
        let model = FloatingAudioModel(name: audioModel.name, author: audioModel.author, imageURL: nil, audioProgress: 0)
        FloatingAudioPlayer.play(audioModel: model, delegate: self)
        
        guard let path = Bundle.main.path(forResource: "\(audioModel.fileName).mp3", ofType:nil) else {
            return
        }
        let url = URL(fileURLWithPath: path)
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.allowAirPlay, .allowBluetooth, .mixWithOthers])
                try AVAudioSession.sharedInstance().setActive(true)
            
                AudioTableViewController.player = try AVAudioPlayer(contentsOf: url)
                AudioTableViewController.player?.play()
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else {
                        return
                    }
                    
                    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateProgressBar), userInfo: nil, repeats: true)
                }
            } catch {
                // couldn't load file :(
            }
        }
    }
    
    @objc private func updateProgressBar() {
        guard let player = AudioTableViewController.player else {
            timer?.invalidate()
            return
        }
        let progress: Float = Float(player.currentTime)/Float(player.duration)
        FloatingAudioPlayer.setAudio(progress: progress)
    }
    
    private func pause() {
        AudioTableViewController.player?.pause()
        timer?.invalidate()
    }
    
    private func play(at time: TimeInterval? = nil) {
        if let time = time {
            AudioTableViewController.player?.play(atTime: time)
        }else{
            AudioTableViewController.player?.play()
        }
        
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateProgressBar), userInfo: nil, repeats: true)
    }
    
    private func next() {
        let audioArray: [AudioModel] = (mode == .music) ? musicArray:podcastArray
        if currentPlayinAudioIndex < audioArray.count - 1 {
            currentPlayinAudioIndex += 1
        }else{
            currentPlayinAudioIndex = 0
        }
        playAudio(at: currentPlayinAudioIndex)
    }
}

extension AudioTableViewController: FloatingAudioPlayerViewDelegate {
    
    func floatingAudioPlayerViewDidTapPause() {
        pause()
    }
    
    func floatingAudioPlayerViewDidTapPlay() {
        play()
    }
    
    func floatingAudioPlayerViewDidTapNext() {
        next()
    }
    
    func floatingAudioPlayerViewDidChangeProgress(progress: Float) {
        guard let player = AudioTableViewController.player else {
            return
        }
        let time: Double = player.duration * Double(progress)
        player.currentTime = time
    }
}
