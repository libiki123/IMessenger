//
//  ProfileViewModels.swift
//  iMessenger
//
//  Created by Nikki Truong on 2021-01-16.
//  Copyright © 2021 EthanTruong. All rights reserved.
//

import Foundation

enum ProfileViewModelType {
    case info, logout
}

struct ProfileViewModel {
    let viewModelType: ProfileViewModelType
    let title: String
    let handler: (() -> Void)?
}
