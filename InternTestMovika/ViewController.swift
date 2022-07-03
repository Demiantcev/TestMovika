//
//  ViewController.swift
//  InternTestMovika
//
//  Created by Кирилл Демьянцев on 03.07.2022.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    
    let tapGesture = UITapGestureRecognizer()
    
    let playerOne = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "video", ofType: "mp4")!))
    let playerTwo = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "video2", ofType: "mp4")!))
    var layer = AVPlayerLayer()
    let shapeLayer = CAShapeLayer()
    
    var timer = Timer()
    var durationTimer = 10
    
    private var buttonCenterX: NSLayoutConstraint?
    private var buttonCenterY: NSLayoutConstraint?
    
    var buttonTest: UIButton = {
        var button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "ant.fill"), for: .normal)
        button.addTarget(self, action: #selector(testTap), for: .touchUpInside)
        button.tintColor = .green
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func testTap() {
        
        playerOne.pause()
        timerLabel.isHidden = true
        shapeLayer.strokeColor = UIColor.clear.cgColor
        buttonTest.alpha = 0
        player2()
    }
    
    let timerLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 50)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        timerLabel.text = "\(durationTimer)"
        player1()
        
        view.addSubview(buttonTest)
        view.addSubview(timerLabel)
        setupConstraint()
        setupGesture()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    }
    
    func animation() {
        
        let circularPath = UIBezierPath()
        let dotOne = CGPoint(x: 25, y: 30)
        let dotTwo = CGPoint(x: 25, y: view.frame.height - 30)
        let dotThree = CGPoint(x: 870, y: 30)
        let dotFour = CGPoint(x: 870, y: view.frame.height - 30)
        
        circularPath.move(to: dotOne)
        circularPath.addLine(to: dotTwo)
        circularPath.move(to: dotThree)
        circularPath.addLine(to: dotFour)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.lineWidth = 21
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        
        shapeLayer.strokeColor = UIColor.red.cgColor
        view.layer.addSublayer(shapeLayer)
    }
    
    func basicAnimation() {
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 0
        basicAnimation.duration = CFTimeInterval(durationTimer)
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = true
        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
    }
    
    func player1() {
        layer = AVPlayerLayer(player: playerOne)
        layer.frame = view.bounds
        layer.videoGravity = .resizeAspect
        view.layer.addSublayer(layer)
    }
    
    func player2() {
        layer = AVPlayerLayer(player: playerTwo)
        layer.frame = view.bounds
        layer.videoGravity = .resizeAspect
        playerTwo.play()
        view.layer.addSublayer(layer)
    }
    
    func setupConstraint() {
        
        let timerTopConstraint = timerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30)
        let timerLeadingConstraint = timerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35)
        
        self.buttonCenterX = buttonTest.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30)
        self.buttonCenterY = buttonTest.topAnchor.constraint(equalTo: view.topAnchor,constant: 150)
        let buttonHeight = buttonTest.heightAnchor.constraint(equalToConstant: 100)
        let buttonWidth = buttonTest.widthAnchor.constraint(equalToConstant: 100)
        
        NSLayoutConstraint.activate([
            timerTopConstraint, timerLeadingConstraint, buttonHeight, buttonWidth, self.buttonCenterX, self.buttonCenterY
        ].compactMap({$0}))
    }
    
    func animateButton() {
        UIView.animate(withDuration: 10, delay: 2, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: .allowUserInteraction) {
            
            self.buttonCenterX?.constant = 760
            self.buttonCenterY?.constant = 150
            
            self.view.layoutIfNeeded()
        }
    }
    
    func setupGesture() {
        self.tapGesture.addTarget(self, action: #selector(handleTap))
        self.view.addGestureRecognizer(self.tapGesture)
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        guard self.tapGesture === gestureRecognizer else { return }
        
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
            self.buttonTest.alpha = 1
            self.timerLabel.alpha = 1
            self.animation()
            self.basicAnimation()
            self.animateButton()
            self.playerOne.play()
        }
    }
    @objc func timerAction() {
        durationTimer -= 1
        timerLabel.text = "\(durationTimer)"
        
        if durationTimer == 0 {
            timer.invalidate()
            buttonTest.isHidden = true
            timerLabel.isHidden = true
            shapeLayer.isHidden = true
        }
    }
}


