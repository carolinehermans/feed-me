//
//  RecipeHTMLParser.swift
//  FeedMe
//
//  Created by Jordan Brown on 9/5/15.
//  Copyright (c) 2015 woosufjordaline. All rights reserved.
//

import Foundation

protocol RecipeHTMLParser {
    func parse() -> Recipe;
    init(page: String);
}