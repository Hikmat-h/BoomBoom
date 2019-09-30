//
//  Constants.swift
//  BoomBoom
//
//  Created by Hikmatillo Habibullaev on 9/9/19.
//  Copyright © 2019 Hikmatillo Habibullaev. All rights reserved.
//

import Foundation

public class Constants {
    public class UsersProperties {
        static let USER_MAIL = "user_login"
        static let TOKEN_NAME = "token_name"
        static let AUTH = "auth"
    }
    
    public class HTTP {
        static let PATH_URL = "http://46.183.163.124:8080"
    }
    
    public class MESSAGE {
        static let ERROR_NOT_INTERNET = "Проверьте подключение к интернету"
        static let ERROR_NOT_ALL_FILLED = "Заполнены не все поля"
        static let ERROR_PASSWORD_DO_NOT_MATH = "Пароли не совпадают"
        static let ERROR_PASSWORD_NOT_LESS_SYMBOLS = "Пароль должен бынь не менее 6 символов"
        static let ERROR_ENTER_EMAIL = "E-Mail введен неверно!"
        static let ERROR_ENTER_MAIL = "Введите Вашу почту"
        static let ERROR_ENTER_CODE_MAIL = "Введите код сброса, отправленный Вам на почту"
        static let ERROR_PASSWORD_NOT_FOUND = "Введите новый пароль"
        static let ERROR_NO_ACCESS_TO_SLEEP_DIARY = "нет доступа ко сну"
        
    }
    
    public class NAME_SEGUE {
        static let REG_TO_REG_DETAIL = "regToRegDetail"
        static let REG_TO_SMS = "regToSms"
        static let SMS_TO_REG_DETAIL = "smsToRegDetail"
    }
    
    public class NAME_CELL {
        static let NEWS_CELL = "newsCell"
        static let CHAT_LIST_CELL = "chatListCell"
        static let STARRED_CHATS_CELL = "starredChatsCell"
        static let PROFILE_PHOTO_CELL = "profilePhotoCell"
        static let STARRED_NEWS_CELL = "starredNewsCell"
        static let NEWS_PHOTO_CELL = "newsPhotoCell"
    }
    
    public class TAG_ACTION {
        static let CHILDREN_CREATE = "createChild"
        static let CHILDREN_EDIT = "editCgild"
    }
    
    public class GENDER {
        static let MAN = "Мужской"
        static let WOMAN = "Женский"
    }
    
    public class OBSERVER_NOTIFIC {
        static let LOAD_CHILDREN = "loadChildrenList"
        static let LOAD_WAYS_TO_SLEEP = "loadWaysToSleep"
        static let LOAD_PREPARATION_SLEEP = "loadPreparationSleep"
        static let LOAD_SLEEP_DIARIES_BY_CHILDREN_ID = "loadSleepDiariesByCildrenId_"
        static let LOAD_SLEEP_DIEARIES = "loadSleepDiaries"
    }
}
