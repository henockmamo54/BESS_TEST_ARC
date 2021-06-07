

from datetime import datetime

start=datetime.now()

'''
execute task
'''

end =datetime.now()

f = open("log.txt","a")
log_text= "\n start= {}, end= {} \n". format(start,end)
f.write(log_text)

print("Done")