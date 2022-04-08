//
//  ViewController.swift
//  Kanji2048
//
//  Created by HOKO on 2022/03/22.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var boardView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var colorOnButton: UIButton!
    @IBOutlet weak var colorOffButton: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button8: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    let userDefaults:UserDefaults = UserDefaults.standard
    let scoreTextLabel = UILabel()
    
    let buttonRad = CGFloat(20)
    
    var player: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userDefaults.register(defaults: ["COLOR" : true,
                                         "NUMBER" : true,
                                         "BOARD_NUM" : 4])
        
        self.view.backgroundColor = UIColor.white
        
        boardView.backgroundColor = UIColor.gray
        boardView.layer.masksToBounds = true
        boardView.layer.cornerRadius = 5
        
        scoreLabel.backgroundColor = UIColor.gray
        scoreLabel.layer.masksToBounds = true
        scoreLabel.layer.cornerRadius = 5
        scoreLabel.text = ""
        scoreTextLabel.frame = CGRect(x: 0, y: 0, width: 290, height: 40)
        scoreTextLabel.textAlignment = NSTextAlignment.right
        scoreTextLabel.textColor = UIColor.white
        scoreTextLabel.font = scoreLabel.font.withSize(CGFloat(20))
        scoreLabel.addSubview(scoreTextLabel)
        
        colorOnButton.backgroundColor = UIColor{_ in return #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)}//UIColor.lightGray
        colorOnButton.layer.masksToBounds = true
        colorOnButton.layer.cornerRadius = buttonRad
        colorOnButton.setTitleColor(UIColor.black, for: .normal)
        colorOnButton.titleLabel?.textAlignment = NSTextAlignment.center
        colorOnButton.titleLabel?.font = colorOnButton.titleLabel?.font.withSize(CGFloat(20))
        if userDefaults.bool(forKey: "COLOR"){
            colorOnButton.setTitle("色彩あり", for: .normal)
        } else {
            colorOnButton.setTitle("色彩なし", for: .normal)
        }
        
        colorOffButton.backgroundColor = UIColor{_ in return #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)}//UIColor.lightGray
        colorOffButton.layer.masksToBounds = true
        colorOffButton.layer.cornerRadius = buttonRad
        colorOffButton.setTitleColor(UIColor.black, for: .normal)
        colorOffButton.titleLabel?.textAlignment = NSTextAlignment.center
        colorOffButton.titleLabel?.font = colorOffButton.titleLabel?.font.withSize(CGFloat(20))
        if userDefaults.bool(forKey: "NUMBER"){
            colorOffButton.setTitle("画数表示あり", for: .normal)
        } else {
            colorOffButton.setTitle("画数表示なし", for: .normal)
        }
        
        button4.backgroundColor = UIColor{_ in return #colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1)}//UIColor{_ in return #colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 1)}
        button4.layer.masksToBounds = true
        button4.layer.cornerRadius = buttonRad
        button4.setTitle("4×4", for: .normal)
        button4.setTitleColor(UIColor.black, for: .normal)
        button4.titleLabel?.textAlignment = NSTextAlignment.center
        button4.titleLabel?.font = button4.titleLabel?.font.withSize(CGFloat(20))
        if userDefaults.integer(forKey: "BOARD_NUM") == 4{
            enableButton4(false)
        }
        
        button6.backgroundColor = UIColor{_ in return #colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1)}
        button6.layer.masksToBounds = true
        button6.layer.cornerRadius = buttonRad
        button6.setTitle("6×6", for: .normal)
        button6.setTitleColor(UIColor.black, for: .normal)
        button6.titleLabel?.textAlignment = NSTextAlignment.center
        button6.titleLabel?.font = button6.titleLabel?.font.withSize(CGFloat(20))
        if userDefaults.integer(forKey: "BOARD_NUM") == 6{
            enableButton6(false)
        }
        
        button8.backgroundColor = UIColor{_ in return #colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1)}//UIColor{_ in return #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)}
        button8.layer.masksToBounds = true
        button8.layer.cornerRadius = buttonRad
        button8.setTitle("8×8", for: .normal)
        button8.setTitleColor(UIColor.black, for: .normal)
        button8.titleLabel?.textAlignment = NSTextAlignment.center
        button8.titleLabel?.font = button8.titleLabel?.font.withSize(CGFloat(20))
        if userDefaults.integer(forKey: "BOARD_NUM") == 8{
            enableButton8(false)
        }
        
        startButton.backgroundColor = UIColor{_ in return #colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 1)}//UIColor{_ in return #colorLiteral(red: 0.001635324071, green: 0.09160238673, blue: 1, alpha: 1)}
        startButton.layer.masksToBounds = true
        startButton.layer.cornerRadius = startButton.frame.size.height / 2
        startButton.setTitle("スタート", for: .normal)
        startButton.setTitleColor(UIColor.black, for: .normal)
        startButton.titleLabel?.textAlignment = NSTextAlignment.center
        startButton.titleLabel?.font = startButton.titleLabel?.font.withSize(CGFloat(30))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBoard()
        scoreTextLabel.text = "BEST SCORE:\(userDefaults.integer(forKey: "BEST\(userDefaults.integer(forKey: "BOARD_NUM"))"))"
    }
    
    @IBAction func colorOnButtonHandle(_ sender: Any) {
        if !userDefaults.bool(forKey: "COLOR"){
            colorOnButton.setTitle("色彩あり", for: .normal)
            userDefaults.set(true, forKey: "COLOR")
        } else {
            colorOnButton.setTitle("色彩なし", for: .normal)
            userDefaults.set(false, forKey: "COLOR")
        }
        userDefaults.synchronize()
        setBoard()
        soundPlayer("buttonSound")
    }
    
    @IBAction func colorOffButtonHandle(_ sender: Any) {
        if !userDefaults.bool(forKey: "NUMBER"){
            colorOffButton.setTitle("画数表示あり", for: .normal)
            userDefaults.set(true, forKey: "NUMBER")
        } else {
            colorOffButton.setTitle("画数表示なし", for: .normal)
            userDefaults.set(false, forKey: "NUMBER")
        }
        userDefaults.synchronize()
        setBoard()
        soundPlayer("buttonSound")
    }
    
    @IBAction func button4Handle(_ sender: Any) {
        enableButton4(false)
        enableButton6(true)
        enableButton8(true)
        userDefaults.set(4, forKey: "BOARD_NUM")
        userDefaults.synchronize()
        setBoard()
        soundPlayer("buttonSound")
        scoreTextLabel.text = "BEST SCORE:\(userDefaults.integer(forKey: "BEST\(userDefaults.integer(forKey: "BOARD_NUM"))"))"
    }
    
    @IBAction func button6Handle(_ sender: Any) {
        enableButton4(true)
        enableButton6(false)
        enableButton8(true)
        userDefaults.set(6, forKey: "BOARD_NUM")
        userDefaults.synchronize()
        setBoard()
        soundPlayer("buttonSound")
        scoreTextLabel.text = "BEST SCORE:\(userDefaults.integer(forKey: "BEST\(userDefaults.integer(forKey: "BOARD_NUM"))"))"
    }
    
    @IBAction func button8Handle(_ sender: Any) {
        enableButton4(true)
        enableButton6(true)
        enableButton8(false)
        userDefaults.set(8, forKey: "BOARD_NUM")
        userDefaults.synchronize()
        setBoard()
        soundPlayer("buttonSound")
        scoreTextLabel.text = "BEST SCORE:\(userDefaults.integer(forKey: "BEST\(userDefaults.integer(forKey: "BOARD_NUM"))"))"
    }
    
    @IBAction func startButtonHandle(_ sender: Any) {
        soundPlayer("buttonSound")
    }
    
    func setBoard(){
        //boardViewの内容を全消去
        self.boardView.subviews.forEach { subview in subview.removeFromSuperview()}
        
        let boardNum = userDefaults.integer(forKey: "BOARD_NUM")
        let coloring = userDefaults.bool(forKey: "COLOR")
        let numbering = userDefaults.bool(forKey: "NUMBER")
        
        var boardArray = Array<[TileData]>(repeating: Array<TileData>(repeating: TileData(), count: boardNum), count: boardNum)
        for i in 0 ..< boardNum{
            for j in 0 ..< boardNum{
                boardArray[i][j] = TileData()
            }
        }
        let boardRow1 = boardNum/2 - 1
        let boardColumn1 = boardNum/2 - 1
        let boardRow2 = boardNum/2
        let boardColumn2 = boardNum/2
        
        boardArray[boardRow1][boardColumn1].num += 1
        boardArray[boardRow1][boardColumn1].char = "一"
        boardArray[boardRow2][boardColumn2].num += 2
        boardArray[boardRow2][boardColumn2].char = "二"
        
        let margin = 40/boardNum
        
        let grid = (Int(300) - margin * (boardNum + 1)) / boardNum
        let corner_x = (Int(300) - (grid * boardNum + margin * (boardNum - 1))) / 2
        let corner_y = (Int(300) - (grid * boardNum + margin * (boardNum - 1))) / 2
        for i in 0 ..< boardNum{
            for j in 0 ..< boardNum{
                let label = UILabel()
                label.frame = CGRect(
                    x: corner_x + (grid + margin) * i,
                    y: corner_y + (grid + margin) * j,
                    width: grid,
                    height: grid)
                label.backgroundColor = UIColor.lightGray
                label.layer.masksToBounds = true
                label.layer.cornerRadius = 5
                self.boardView.addSubview(label)
            }
        }
        for i in 0 ..< boardNum{
            for j in 0 ..< boardNum{
                if boardArray[i][j].num != 0{
                    let label = UILabel()
                    label.frame = CGRect(
                        x: corner_x + (grid + margin) * i,
                        y: corner_y + (grid + margin) * j,
                        width: grid,
                        height: grid)
                    label.layer.masksToBounds = true
                    label.layer.cornerRadius = 5
                    label.textAlignment = NSTextAlignment.center
                    label.font = label.font.withSize(CGFloat(grid/2))
                    label.textColor = UIColor.black
                    label.backgroundColor = UIColor.white
                    label.text = "\(boardArray[i][j].char)"
                    if coloring{
                        label.backgroundColor = Const.colorArray[boardArray[i][j].num]
                        if boardArray[i][j].num > 12{
                            label.textColor = UIColor.white
                        }
                    }
                    if numbering{
                        let numLabel = UILabel()
                        numLabel.frame = CGRect(x: 0, y: grid*3/4, width: grid, height: grid/4)
                        numLabel.textAlignment = NSTextAlignment.right
                        numLabel.font = label.font.withSize(CGFloat(grid/4))
                        numLabel.textColor = UIColor.black
                        if coloring && boardArray[i][j].num > 12{
                            numLabel.textColor = UIColor.white
                        }
                        if boardArray[i][j].num == 24{
                            numLabel.text = "29"
                        } else {
                            numLabel.text = "\(boardArray[i][j].num)"
                        }
                        label.addSubview(numLabel)
                    }
                    self.boardView.addSubview(label)
                }
            }
        }
    }
    
    func enableButton4(_ yes:Bool){
        if yes{
            button4.isEnabled = true
            button4.backgroundColor = UIColor{_ in return #colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1)}//UIColor{_ in return #colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 1)}
            button4.setTitleColor(UIColor.black, for: .normal)
        } else {
            button4.isEnabled = false
            button4.backgroundColor = UIColor{_ in return #colorLiteral(red: 0.5738074183, green: 0.5655357838, blue: 0, alpha: 1)}//UIColor{_ in return #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)}
            button4.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    func enableButton6(_ yes:Bool){
        if yes{
            button6.isEnabled = true
            button6.backgroundColor = UIColor{_ in return #colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1)}
            button6.setTitleColor(UIColor.black, for: .normal)
        } else {
            button6.isEnabled = false
            button6.backgroundColor = UIColor{_ in return #colorLiteral(red: 0.5738074183, green: 0.5655357838, blue: 0, alpha: 1)}
            button6.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    func enableButton8(_ yes:Bool){
        if yes{
            button8.isEnabled = true
            button8.backgroundColor = UIColor{_ in return #colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1)}//UIColor{_ in return #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)}
            button8.setTitleColor(UIColor.black, for: .normal)
        } else {
            button8.isEnabled = false
            button8.backgroundColor = UIColor{_ in return #colorLiteral(red: 0.5738074183, green: 0.5655357838, blue: 0, alpha: 1)}//UIColor{_ in return #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)}
            button8.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    func soundPlayer(_ name:String){
        if let soundURL = Bundle.main.url(forResource: name, withExtension: "m4a") {
            do {
                player = try AVAudioPlayer(contentsOf: soundURL)
                player?.play()
            } catch {
                print("SYSTEM_PRINT: SOUND ERROR")
            }
        }
    }
}

