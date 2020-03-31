//
//  Date+SPAdd.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/31.
//  Copyright © 2020 cactus. All rights reserved.
//

import Foundation

extension Date {

    /// 判断当前日期是否为今年
    func sp_isThisYear() -> Bool {
        // 获取当前日历
        let calender = Calendar.current
        // 获取日期的年份
        let yearComps = calender.component(.year, from: self)
        // 获取现在的年份
        let nowComps = calender.component(.year, from: Date())
        return yearComps == nowComps
    }

    /// 是否是昨天
    func sp_isYesterday() -> Bool {
        // 获取当前日历
        let calender = Calendar.current
        // 获取日期的年份
        let comps = calender.dateComponents([.year, .month, .day], from: self, to: Date())
        // 根据头条显示时间 ，我觉得可能有问题 如果comps.day == 0 显示相同，如果是 comps.day == 1 显示时间不同
        // 但是 comps.day == 1 才是昨天 comps.day == 2 是前天
        //return comps.year == 0 && comps.month == 0 && comps.day == 1
        return comps.year == 0 && comps.month == 0 && comps.day == 0
    }

    /// 是否是前天
    func sp_isBeforeYesterday() -> Bool {
        // 获取当前日历
        let calender = Calendar.current
        // 获取日期的年份
        let comps = calender.dateComponents([.year, .month, .day], from: self, to: Date())
        //return comps.year == 0 && comps.month == 0 && comps.day == 2
        return comps.year == 0 && comps.month == 0 && comps.day == 1
    }

    /// 判断是否是今天
    func sp_isToday() -> Bool {
        // 日期格式化
        let formatter = DateFormatter()
        // 设置日期格式
        formatter.dateFormat = "yyyy-MM-dd"
        let dateStr = formatter.string(from: self)
        let nowStr = formatter.string(from: Date())
        return dateStr == nowStr
    }
}

extension TimeInterval {

    // 把秒数转换成时间的字符串
    func sp_convertString() -> String {
        // 把获取到的秒数转换成具体的时间
        let createDate = Date(timeIntervalSince1970: self)
        // 获取当前日历
        let calender = Calendar.current
        // 获取日期的年份
        let comps = calender.dateComponents([.year, .month, .day, .hour, .minute, .second], from: createDate, to: Date())
        // 日期格式
        let formatter = DateFormatter()
        // 判断当前日期是否为今年
        guard createDate.sp_isThisYear() else {
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return formatter.string(from: createDate)
        }

        // 是否是前天
        if createDate.sp_isBeforeYesterday() {
            formatter.dateFormat = "前天 HH:mm"
            return formatter.string(from: createDate)
        } else if createDate.sp_isToday() || createDate.sp_isYesterday() {
            // 判断是否是今天或者昨天
            if comps.hour! >= 1 {
                return String(format: "%d小时前", comps.hour!)
            } else if comps.minute! >= 1 {
                return String(format: "%d分钟前", comps.minute!)
            } else {
                return "刚刚"
            }

        } else {
            formatter.dateFormat = "MM-dd HH:mm"
            return formatter.string(from: createDate)
        }
    }
}
