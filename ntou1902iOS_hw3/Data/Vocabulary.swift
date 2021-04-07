//
//  Questions.swift
//  ntou1902iOS_hw3
//
//  Created by Shaun Ku on 2021/3/31.
//

import Foundation

struct Vocabulary: Codable
{
    var fr:String
    var en: String
    var picName: String
}

var vocabulary: [Vocabulary] =
[
    Vocabulary(fr:"ours", en: "bear", picName: "bear"),
    Vocabulary(fr:"bonjour", en: "hello", picName: "hello"),
    Vocabulary(fr:"chien", en: "dog", picName: "dog"),
    Vocabulary(fr:"chat", en: "cat", picName: "cat"),
    Vocabulary(fr:"français", en: "french", picName: "french"),
    Vocabulary(fr:"merci", en: "thank you", picName: "tk"),
    Vocabulary(fr:"au revoir", en: "goodbye", picName: "gb"),
    Vocabulary(fr:"zèbre", en: "zebra", picName: "zebra"),
    Vocabulary(fr:"éléphant", en: "elephant", picName: "elephant"),
    Vocabulary(fr:"loup", en: "wolf", picName: "wolf"),
    Vocabulary(fr:"lapin", en: "rabbit", picName: "rabbit"),
    Vocabulary(fr:"le raisin", en: "grapes", picName: "grapes"),
    Vocabulary(fr:"pomme", en: "apple", picName: "apple"),
    Vocabulary(fr:"boeuf", en: "beef", picName: "beef"),
    Vocabulary(fr:"le lait", en: "milk", picName: "milk"),
]
