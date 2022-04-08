//
//  GameViewController.swift
//  Kanji2048
//
//  Created by HOKO on 2022/03/22.
//

import UIKit
import AVFoundation

class GameViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var boardView: UIView!
    @IBOutlet weak var maxScoreLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    //設定から引き継ぐ変数
    var boardNum:Int = 4
    var coloring:Bool = false
    var numbering:Bool = false
    
    var boardArray:[[TileData]]!
    
    var score:Int = 0
    let userDefaults:UserDefaults = UserDefaults.standard
    let scoreTextLabel = UILabel()
    let maxScoreTextLabel = UILabel()
    
    var player: AVAudioPlayer?
    
    var margin = 40
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //上スワイプ用のインスタンスを生成
        let upSwipe = UISwipeGestureRecognizer(
            target: self,
            action: #selector(self.didSwipe(_:))
        )
        upSwipe.direction = .up
        self.view!.addGestureRecognizer(upSwipe)

        //右スワイプ用のインスタンスを生成
        let rightSwipe = UISwipeGestureRecognizer(
            target: self,
            action: #selector(self.didSwipe(_:))
        )
        rightSwipe.direction = .right
        self.view!.addGestureRecognizer(rightSwipe)

        //下スワイプ用のインスタンスを生成
        let downSwipe = UISwipeGestureRecognizer(
            target: self,
            action: #selector(self.didSwipe(_:))
        )
        downSwipe.direction = .down
        self.view!.addGestureRecognizer(downSwipe)

        //左スワイプ用のインスタンスを生成
        let leftSwipe = UISwipeGestureRecognizer(
            target: self,
            action: #selector(self.didSwipe(_:))
        )
        leftSwipe.direction = .left
        self.view!.addGestureRecognizer(leftSwipe)
        
        self.view.backgroundColor = UIColor.white
        
        boardView.backgroundColor = UIColor.gray
        boardView.layer.masksToBounds = true
        boardView.layer.cornerRadius = 5
        
        maxScoreLabel.backgroundColor = UIColor.gray
        maxScoreLabel.layer.masksToBounds = true
        maxScoreLabel.layer.cornerRadius = 5
        maxScoreLabel.text = ""
        maxScoreTextLabel.frame = CGRect(x: 0, y: 0, width: 290, height: 40)
        maxScoreTextLabel.textAlignment = NSTextAlignment.right
        maxScoreTextLabel.textColor = UIColor.white
        maxScoreTextLabel.font = maxScoreLabel.font.withSize(CGFloat(20))
        maxScoreLabel.addSubview(maxScoreTextLabel)
        
        scoreLabel.backgroundColor = UIColor.gray
        scoreLabel.layer.masksToBounds = true
        scoreLabel.layer.cornerRadius = 5
        scoreLabel.text = ""
        scoreTextLabel.frame = CGRect(x: 0, y: 0, width: 290, height: 40)
        scoreTextLabel.textAlignment = NSTextAlignment.right
        scoreTextLabel.textColor = UIColor.white
        scoreTextLabel.font = scoreLabel.font.withSize(CGFloat(20))
        scoreLabel.addSubview(scoreTextLabel)
        
        backButton.backgroundColor = UIColor{_ in return #colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1)}
        backButton.layer.masksToBounds = true
        backButton.layer.cornerRadius = 20
        backButton.setTitle("タイトルへ戻る", for: .normal)
        backButton.setTitleColor(UIColor.black, for: .normal)
        backButton.titleLabel?.textAlignment = NSTextAlignment.center
        backButton.titleLabel?.font = backButton.titleLabel?.font.withSize(CGFloat(20))
        
        coloring = userDefaults.bool(forKey: "COLOR")
        numbering = userDefaults.bool(forKey: "NUMBER")
        boardNum = userDefaults.integer(forKey: "BOARD_NUM")
        
        margin = 40/boardNum
        
        initGame()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let resultViewController:ResultViewController = segue.destination as! ResultViewController
        resultViewController.score = self.score
        resultViewController.boardArray = self.boardArray
    }
    
    //スワイプ時に実行されるメソッド
    @objc func didSwipe(_ sender: UISwipeGestureRecognizer) {
        //スワイプ方向による実行処理をcase文で指定
        switch sender.direction {
            case .up:
                print("SYSTEM_PRINT: UP")
                moveBoard(vec: [0, 1])
                break
            case .right:
                print("SYSTEM_PRINT: RIGHT")
                moveBoard(vec: [-1, 0])
                break
            case .down:
                print("SYSTEM_PRINT: DOWN")
                moveBoard(vec: [0, -1])
                break
            case .left:
                print("SYSTEM_PRINT: LEFT")
                moveBoard(vec: [1, 0])
                break
            default:
                break
        }
        setBoard(boardArray)
    }
    
    @IBAction func backButtonHandle(_ sender: Any) {
        soundPlayer("buttonSound")
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func initGame(){
        boardArray = Array<[TileData]>(repeating: Array<TileData>(repeating: TileData(), count: boardNum), count: boardNum)
        for i in 0 ..< boardNum{
            for j in 0 ..< boardNum{
                boardArray[i][j] = TileData()
            }
        }
        let boardRow = Int.random(in: 0 ..< boardNum)
        let boardColumn = Int.random(in: 0 ..< boardNum)
        boardArray[boardRow][boardColumn].num += 1
        setKanji(num_i: boardRow, num_j: boardColumn)
        
        maxScoreTextLabel.text = "BEST SCORE:\(userDefaults.integer(forKey: "BEST\(boardNum)"))"
        
        setBoard(boardArray)
    }
    
    func setKanji(num_i i:Int, num_j j:Int){
        if boardArray[i][j].num >= Const.kanjiArray.count{
            boardArray[i][j].char = "XX"
            return
        }
        let str = Const.kanjiArray[boardArray[i][j].num]
        let random = Int.random(in: 0 ..< str.count)
        let index = str.index(str.startIndex, offsetBy: random)
        boardArray[i][j].char = str[index].description
        userDefaults.set(true, forKey: str[index].description)
        userDefaults.synchronize()
    }
    
    func setBoard(_ board: [[TileData]]){
        //boardViewの内容を全消去
        self.boardView.subviews.forEach { subview in subview.removeFromSuperview()}
        
        let grid = (Int(self.view.frame.size.width - 20) - margin * (boardNum + 1)) / boardNum
        let corner_x = (Int(self.view.frame.size.width - 20) - (grid * boardNum + margin * (boardNum - 1))) / 2
        let corner_y = (Int(self.view.frame.size.width - 20) - (grid * boardNum + margin * (boardNum - 1))) / 2
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
                    
                    
                    label.center.x += CGFloat((grid + self.margin) * self.boardArray[i][j].moveVec[0])
                    label.center.y += CGFloat((grid + self.margin) * self.boardArray[i][j].moveVec[1])
                    UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear, animations: {
                        label.center.x -= CGFloat((grid + self.margin) * self.boardArray[i][j].moveVec[0])
                        label.center.y -= CGFloat((grid + self.margin) * self.boardArray[i][j].moveVec[1])
                    }, completion: nil)
                    if boardArray[i][j].generated{
                        label.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
                            label.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        }, completion: nil)
                        boardArray[i][j].generated = false
                    }
                    
                    self.boardView.addSubview(label)
                }
            }
        }
        for i in 0 ..< boardNum{
            for j in 0 ..< boardNum{
                boardArray[i][j].moveVec = [0, 0]
            }
        }
        
        score = 0
        for i in 0 ..< boardNum{
            for j in 0 ..< boardNum{
                if boardArray[i][j].num != 0 && boardArray[i][j].num != 24{
                    score += Int(pow(Double(2), Double(boardArray[i][j].num-1)))
                } else if boardArray[i][j].num == 24 {
                    score += Int(pow(Double(2), Double(28)))
                }
            }
        }
        scoreTextLabel.text = "SCORE:\(score)"
        var maxScore = userDefaults.integer(forKey: "BEST\(boardNum)")
        if score > maxScore {
            maxScore = score
            maxScoreTextLabel.text = "BEST SCORE:\(maxScore)"
            userDefaults.set(maxScore, forKey: "BEST\(boardNum)")
            userDefaults.synchronize()
        }
    }
    
    func moveBoard(vec: [Int]){
        var moved = false
        //タイルの移動
        for _ in 0 ..< boardNum - 1{
            if(vec[0] + vec[1] == 1){
                for i in 0 ..< boardNum - vec[0]{
                    for j in 0 ..< boardNum - vec[1]{
                        if boardArray[i+vec[0]][j+vec[1]].num != 0{
                            if boardArray[i][j].num == 0{
                                boardArray[i][j] = boardArray[i+vec[0]][j+vec[1]]
                                boardArray[i][j].addVec(vec)
                                boardArray[i+vec[0]][j+vec[1]] = TileData()
                                moved = true
                            }
                            else if boardArray[i][j].num == boardArray[i+vec[0]][j+vec[1]].num && boardArray[i][j].notCombined && boardArray[i+vec[0]][j+vec[1]].notCombined &&
                                boardArray[i][j].num < 24{
                                boardArray[i][j] = boardArray[i+vec[0]][j+vec[1]]
                                boardArray[i][j].addVec(vec)
                                boardArray[i][j].num += 1
                                boardArray[i][j].notCombined = false
                                setKanji(num_i: i, num_j: j)
                                boardArray[i+vec[0]][j+vec[1]] = TileData()
                                moved = true
                            }
                        }
                    }
                }
            } else {
                for i in (-vec[0] ..< boardNum).reversed(){
                    for j in (-vec[1] ..< boardNum).reversed(){
                        if boardArray[i+vec[0]][j+vec[1]].num != 0{
                            if boardArray[i][j].num == 0{
                                boardArray[i][j] = boardArray[i+vec[0]][j+vec[1]]
                                boardArray[i][j].addVec(vec)
                                boardArray[i+vec[0]][j+vec[1]] = TileData()
                                moved = true
                            }
                            else if boardArray[i][j].num == boardArray[i+vec[0]][j+vec[1]].num && boardArray[i][j].notCombined && boardArray[i+vec[0]][j+vec[1]].notCombined &&
                                boardArray[i][j].num < 24{
                                boardArray[i][j] = boardArray[i+vec[0]][j+vec[1]]
                                boardArray[i][j].addVec(vec)
                                boardArray[i][j].num += 1
                                boardArray[i][j].notCombined = false
                                setKanji(num_i: i, num_j: j)
                                boardArray[i+vec[0]][j+vec[1]] = TileData()
                                moved = true
                            }
                        }
                    }
                }
            }
        }
        for i in 0 ..< boardNum{
            for j in 0 ..< boardNum{
                if !boardArray[i][j].notCombined{
                    boardArray[i][j].notCombined = true
                }
            }
        }
        //タイルが動いた場合
        if moved{
            soundPlayer("tileSound")
            var countNum = 0
            var countIndex = 0
            var endFlag = false
            for i in 0 ..< boardNum{
                for j in 0 ..< boardNum{
                    if boardArray[i][j].num == 0{
                        countNum += 1
                    }
                }
            }
            //タイルの生成
            if(countNum != 0){
                countIndex = 1 + Int.random(in: 0 ..< countNum)
                for i in 0 ..< boardNum{
                    for j in 0 ..< boardNum{
                        if boardArray[i][j].num == 0{
                            if countIndex == countNum{
                                boardArray[i][j].num = Int.random(in: 1 ..< 3)
                                setKanji(num_i: i, num_j: j)
                                boardArray[i][j].generated = true
                            }
                            countNum -= 1
                        }
                    }
                }
            }
            countNum = 0
            for i in 0 ..< boardNum{
                for j in 0 ..< boardNum{
                    if boardArray[i][j].num == 0{
                        countNum += 1
                    }
                }
            }
            if(countNum == 0){
                endFlag = true
                for i in 0 ..< boardNum{
                    for j in 0 ..< boardNum - 1{
                        if boardArray[i][j].num == boardArray[i][j+1].num{
                            endFlag = false
                        }
                    }
                }
                for i in 0 ..< boardNum - 1{
                    for j in 0 ..< boardNum{
                        if boardArray[i][j].num == boardArray[i+1][j].num{
                            endFlag = false
                        }
                    }
                }
            }
            //ゲームオーバー
            if endFlag{
                print("SYSTEM_PRINT: GAME OVER")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.performSegue(withIdentifier: "toResult", sender: self)
                }
            }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
