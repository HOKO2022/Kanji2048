//
//  TitleViewController.swift
//  Kanji2048
//
//  Created by HOKO on 2022/04/08.
//

import UIKit
import AVFoundation

class TitleViewController: UIViewController {
    
    @IBOutlet weak var boardView: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var collectionButton: UIButton!
    
    var boardArray:[[TileData]]!
    let boardNum = 4
    
    var player: AVAudioPlayer?
    
    let margin = 10

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        boardView.backgroundColor = UIColor.gray
        boardView.layer.masksToBounds = true
        boardView.layer.cornerRadius = 5
        
        playButton.backgroundColor = UIColor{_ in return #colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 1)}
        playButton.layer.masksToBounds = true
        playButton.layer.cornerRadius = playButton.frame.size.height / 2
        playButton.setTitle("プレイ", for: .normal)
        playButton.setTitleColor(UIColor.black, for: .normal)
        playButton.titleLabel?.textAlignment = NSTextAlignment.center
        playButton.titleLabel?.font = playButton.titleLabel?.font.withSize(CGFloat(30))
        
        collectionButton.backgroundColor = UIColor{_ in return #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)}
        collectionButton.layer.masksToBounds = true
        collectionButton.layer.cornerRadius = collectionButton.frame.size.height / 2
        collectionButton.setTitle("漢字コレクション", for: .normal)
        collectionButton.setTitleColor(UIColor.black, for: .normal)
        collectionButton.titleLabel?.textAlignment = NSTextAlignment.center
        collectionButton.titleLabel?.font = collectionButton.titleLabel?.font.withSize(CGFloat(20))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        demo()
    }
    
    @IBAction func playButtonHandle(_ sender: Any) {
        soundPlayer("buttonSound")
    }
    
    @IBAction func collectionButtonHandle(_ sender: Any) {
        soundPlayer("buttonSound")
    }
    
    func demo(){
        boardArray = Array<[TileData]>(repeating: Array<TileData>(repeating: TileData(), count: boardNum), count: boardNum)
        for i in 0 ..< boardNum{
            for j in 0 ..< boardNum{
                boardArray[i][j] = TileData()
            }
        }
        boardArray[0][0].num = 13
        boardArray[0][0].char = "漢"
        boardArray[1][0].num = 5
        boardArray[1][0].char = "字"
        boardArray[2][0].num = 7
        setKanji(num_i: 2, num_j: 0)
        boardArray[3][0].num = 12
        setKanji(num_i: 3, num_j: 0)
        boardArray[0][1].num = 6
        setKanji(num_i: 0, num_j: 1)
        boardArray[1][1].num = 6
        setKanji(num_i: 1, num_j: 1)
        boardArray[2][1].num = 11
        setKanji(num_i: 2, num_j: 1)
        boardArray[3][1].num = 11
        setKanji(num_i: 3, num_j: 1)
        boardArray[0][2].num = 2
        boardArray[0][2].char = "二"
        boardArray[1][2].num = 12
        setKanji(num_i: 1, num_j: 2)
        boardArray[2][2].num = 4
        setKanji(num_i: 2, num_j: 2)
        boardArray[3][2].num = 1
        setKanji(num_i: 3, num_j: 2)
        boardArray[0][3].num = 12
        setKanji(num_i: 0, num_j: 3)
        boardArray[1][3].num = 3
        setKanji(num_i: 1, num_j: 3)
        boardArray[2][3].num = 3
        setKanji(num_i: 2, num_j: 3)
        boardArray[3][3].num = 1
        setKanji(num_i: 3, num_j: 3)
        setBoard(boardArray)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.moveBoard(vec: [-1, 0])
            self.setBoard(self.boardArray)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.moveBoard(vec: [0, 1])
                self.boardArray[2][0].char = "画"
                self.boardArray[3][0].char = "数"
                self.boardArray[1][1].char = "零"
                self.boardArray[2][1].char = "四"
                self.boardArray[3][1].char = "八"
                self.setBoard(self.boardArray)
            }
        }
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
    }
    
    func setBoard(_ board: [[TileData]]){
        //boardViewの内容を全消去
        self.boardView.subviews.forEach { subview in subview.removeFromSuperview()}
        
        let grid = (Int(self.view.frame.size.width - 100) - margin * (boardNum + 1)) / boardNum
        let corner_x = (Int(self.view.frame.size.width - 100) - (grid * boardNum + margin * (boardNum - 1))) / 2
        let corner_y = (Int(self.view.frame.size.width - 100) - (grid * boardNum + margin * (boardNum - 1))) / 2
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
                    label.backgroundColor = Const.colorArray[boardArray[i][j].num]
                    if boardArray[i][j].num > 12{
                        label.textColor = UIColor.white
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
