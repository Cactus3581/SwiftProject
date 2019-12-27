
import re
import sqlite3
import subprocess

#说明
print( u'')
print( u'------------------------------------------')
print( u'将脚本放入日志所在目录，运行脚本，输入日志日期，将在相同目录生成log.db数据库')
print( u'------------------------------------------')
print( u'')

#解密日志
log_date = input('Please input the log date(eg. 20191224):')
name = "ios_lark_" + log_date + ".xlog.parsed.log"
rm_command_line = "rm -f " + name
subprocess.call(rm_command_line, shell = True) # 删除旧文件
decry_command_line = "rdt xl -o " + "lark_" + log_date + ".xlog"# 解密
subprocess.call(decry_command_line, shell = True)

#读取日志文件、连接数据库
log_db = sqlite3.connect('./log.db')
cursor = log_db.cursor()
#建表
cursor.execute('DROP TABLE IF EXISTS log')
cursor.execute('CREATE TABLE log (date, time, executionTime, module, file, line, func, logType, thread, content, error)')
#设定正则规则
pattern = re.compile(r'\s+',re.S|re.M)
#读取日志文件
log = open('./%s' %name)
#进行转换
try:
    for line in log:
        result = re.split(pattern, line)
        if result != None and len(result) >= 11:

            date = result[0]
            time = result[1]
            executionTime = ''
            module = result[3]

            # 处理数据错误的模块
            #tmp = result
            if module == "AppContainer.TimeLogger":
                    result.pop(4)

            elif module == "UUIDManager":
                    result.pop(4)

            elif module == "unknown":
                    module = result[4]
                    result.pop(2)

            elif module == "keychain":
                    module = result[4]
                    result.pop(3)

            elif module == "TroubleKiller":
                    result.pop(4)
                    result.pop(5)

            elif module == "Application.Monitor":
                    result.pop(4)

            elif module == "TroubleKiller.PET":
                    result.pop(4)

            fileResult = re.split(r':',result[8])
            fileStr = ''
            lineStr = ''
            if len(fileResult) == 2:
                fileStr = fileResult[0]
                lineStr = fileResult[1]

            file = fileStr
            lineNum = lineStr

            func = result[9]
            logType = result[4]
            thread = result[7]
            content = result[10]
            error = None

            if file.find(".swift") == -1:
                error = "1"

            if re.search("Execution-Time", line):
                rs = re.findall("Execution-Time\":\"([0-9.s]+)\"}$", line)
                if len(rs) > 0:
                    executionTime = rs[0]

            cursor.execute('INSERT INTO log (date, time, executionTime, module, file, line, func, logType, thread, content, error) VALUES (?,?,?,?,?,?,?,?,?,?,?)', (date,time, executionTime, module, file, lineNum, func, logType, thread, line, error))

    log_db.commit()
    print( u'------------------------------------------')
    print('done')
except Exception as e:
    print( u'------------------------------------------')
    print(e)
    pass
