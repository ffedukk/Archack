//
//  Data.swift
//  Archack 2
//
//  Created by Fedor on 05/11/2019.
//  Copyright © 2019 Fedor Semenov. All rights reserved.
//

protocol Library {
    var author : String { get }
    var photos : [String] { get }
}

struct Trees {
    var author = "Andrew"
    var photos = ["08","09","10","13","14","f2","j1","nuok2","nuok3","nuok4","nuok5","Дерево","Дерево-2","Дерево-3"]
}

struct People {
    var author = "Fedya"
    var photos = ["Gray Guy Arms Crossed2","Guy-in-Black-Coat-Crossing-the-Street","Man-in-Suit","Man-in-Trenchcoat","Old-Woman","Two-Blond-Women","Young-Couple"]
}
