
import sqlite3

start_time = input('Please input the start time(def. 00:00:00):')
end_time = input('Please input the end time(def. 24:00:00):')

if start_time:
    print ("not empty")
else:
    start_time = "00:00:00"

if end_time:
    print ("not empty")
else:
    end_time = "24:00:00"

db = sqlite3.connect('./log.db')
cursor = db.cursor()

cursor.execute('SELECT COUNT(*) FROM log WHERE time between ? and ?', [start_time,end_time])
amount_all = cursor.fetchone()#日志数

cursor.execute('SELECT COUNT(DISTINCT module) FROM log WHERE time between ? and ?', [start_time,end_time])
moduleCount = cursor.fetchone()#模块数

cursor.execute('SELECT module,COUNT(*) AS logTimes FROM log WHERE time between ? and ? GROUP BY module ORDER BY COUNT(*) DESC',[start_time,end_time])
logTimes = cursor.fetchall()#指定某个模块写日志的数量

#cursor.execute('SELECT DISTINCT module FROM log')
#moduleList = cursor.fetchall()#模块列表

print(u'')
print(u'------------统计------------\n')
print(u'在 %s ~ %s 时间区间内，共有%s个模块写了%s条日志。\n\n模块排序 （by 写日志的次数）: \n\n%s' % (start_time, end_time, moduleCount[0], amount_all[0], logTimes))
print(u'')
