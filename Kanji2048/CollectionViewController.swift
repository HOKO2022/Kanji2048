//
//  CollectionViewController.swift
//  Kanji2048
//
//  Created by HOKO on 2022/04/08.
//

import UIKit
import AVFoundation

class CollectionViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var backButton: UIButton!
    
    let userDefaults:UserDefaults = UserDefaults.standard
    
    var grid:Int!
    
    var player: AVAudioPlayer?
        
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        grid = Int(self.view.frame.width - 20) / 8
        
        backButton.backgroundColor = UIColor{_ in return #colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1)}
        backButton.layer.masksToBounds = true
        backButton.layer.cornerRadius = 20
        backButton.setTitle("戻る", for: .normal)
        backButton.setTitleColor(UIColor.black, for: .normal)
        backButton.titleLabel?.textAlignment = NSTextAlignment.center
        backButton.titleLabel?.font = backButton.titleLabel?.font.withSize(CGFloat(20))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let margin = grid / 20
        var y_pos = 0
        for i in 1...24{
            let numLabel = UILabel()
            numLabel.frame = CGRect(x: 0, y: y_pos + grid * (i-1), width: grid * 8, height: grid)
            numLabel.textAlignment = NSTextAlignment.center
            numLabel.font = numLabel.font.withSize(CGFloat(grid/2))
            numLabel.backgroundColor = Const.colorArray[i]
            var h_num = Int(Array(Const.kanjiArray[i]).count / 8) + 1
            if Array(Const.kanjiArray[i]).count % 8 == 0{
                h_num -= 1
            }
            var kanjiCount = 0
            for (j, charKanji) in Array(Const.kanjiArray[i]).enumerated(){
                let kanjiLabel = UILabel()
                kanjiLabel.frame = CGRect(
                    x: grid * (j % 8) + margin,
                    y: y_pos + grid * (i+j/8) + margin,
                    width: grid - margin*2,
                    height: grid - margin*2)
                kanjiLabel.textAlignment = NSTextAlignment.center
                kanjiLabel.font = kanjiLabel.font.withSize(CGFloat(grid/2))
                kanjiLabel.layer.masksToBounds = true
                kanjiLabel.layer.cornerRadius = 5
                kanjiLabel.textColor = UIColor.black
                if userDefaults.bool(forKey: String(charKanji)){
                    kanjiLabel.text = "\(charKanji)"
                    kanjiCount += 1
                }
                kanjiLabel.backgroundColor = UIColor.lightGray
                self.contentView.addSubview(kanjiLabel)
            }
            numLabel.textColor = UIColor.black
            if i > 12{
                numLabel.textColor = UIColor.white
            }
            numLabel.text = "\(i)画　\(kanjiCount) / \(Array(Const.kanjiArray[i]).count)"
            if kanjiCount == Array(Const.kanjiArray[i]).count{
                numLabel.text = "\(i)画　\(kanjiCount) / \(Array(Const.kanjiArray[i]).count)　👑"
            }
            self.contentView.addSubview(numLabel)
            y_pos += h_num * grid
        }
        self.contentView.frame = CGRect(x: 0, y: 0, width: Int(self.view.frame.width - 20), height: y_pos + grid)
    }
    
    @IBAction func backButtonHandle(_ sender: Any) {
        soundPlayer("buttonSound")
        self.dismiss(animated: true, completion: nil)
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
