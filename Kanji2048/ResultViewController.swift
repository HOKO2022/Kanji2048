//
//  ResultViewController.swift
//  Kanji2048
//
//  Created by HOKO on 2022/03/28.
//

import UIKit
import AVFoundation

class ResultViewController: UIViewController {
    
    @IBOutlet weak var endBoardView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    var coloring:Bool = false
    var numbering:Bool = false
    
    var score:Int = 0
    
    var boardArray:[[TileData]]!
    
    var margin = 40
    
    let userDefaults:UserDefaults = UserDefaults.standard
    let scoreTextLabel = UILabel()
    
    var player: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        endBoardView.backgroundColor = UIColor.gray
        endBoardView.layer.masksToBounds = true
        endBoardView.layer.cornerRadius = 5
        
        scoreLabel.backgroundColor = UIColor.gray
        scoreLabel.layer.masksToBounds = true
        scoreLabel.layer.cornerRadius = 5
        scoreLabel.text = ""
        scoreTextLabel.frame = CGRect(x: 0, y: 0, width: 290, height: 40)
        scoreTextLabel.textAlignment = NSTextAlignment.right
        scoreTextLabel.textColor = UIColor.white
        scoreTextLabel.font = scoreLabel.font.withSize(CGFloat(20))
        scoreTextLabel.text = "SCORE:\(score)"
        scoreLabel.addSubview(scoreTextLabel)
        
        
        backButton.backgroundColor = UIColor.lightGray
        backButton.layer.masksToBounds = true
        backButton.layer.cornerRadius = 5
        backButton.setTitle("タイトルへ戻る", for: .normal)
        backButton.setTitleColor(UIColor.black, for: .normal)
        backButton.titleLabel?.textAlignment = NSTextAlignment.center
        backButton.titleLabel?.font = backButton.titleLabel?.font.withSize(CGFloat(20))
        
        let boardNum = boardArray.count
        coloring = userDefaults.bool(forKey: "COLOR")
        numbering = userDefaults.bool(forKey: "NUMBER")
        
        margin = 40/boardNum
        
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
                self.endBoardView.addSubview(label)
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
                    self.endBoardView.addSubview(label)
                }
            }
        }
    }
    
    @IBAction func backButtonHandle(_ sender: Any) {
        soundPlayer("buttonSound")
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
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
