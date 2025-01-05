//
//  ViewController.swift
//  MusicSearchApp
//
//  Created by 진욱의 Macintosh on 1/1/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

extension ViewController: UITableViewDelegate {
    //선택적으로 구현할수 있는 여러가지 메서드들이 존재한다.
    //셀 높이 설정을 위한 것들. heightForRowAt: 확실한 높이
    // estimatedHeightForRowAt : 추정된 높이 heightForRowAt보다 먼저 계산한다??
    //직접 설정을 하면 단점이 존재한다. - > 셀 높이가 변할때 표현이 힘들다. (상황에 따라 어떤경우는 높이를 ~로)
}
