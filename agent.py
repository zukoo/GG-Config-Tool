import os 
import time
import shutil


QUERY_UP = "cat /proc/interrupts | grep 'Volume Up' | awk '{ print $2}'"

up = int(os.popen(QUERY_UP).read().strip('\n'))
diff_up = 0

def update():
  global up
  u = int(os.popen(QUERY_UP).read().strip('\n'))
  if up == u:
    reset()
  up = u

def reset():
  global diff_up
  if diff_up >= 4: # 2 press
    #os.system("scripts/setup_wifi_ap.py")

    shutil.rmtree('./uploads', ignore_errors=True)
    os.mkdir('./uploads')

    os.system("python server.py")

    if os.path.isfile('./uploads/certificates.tar.gz'):
      os.system("bash scripts/reset_greengrass.sh")
      
    #os.system("scripts/reset_wifi.py")
  diff_up = 0

while 42:
  time.sleep(1)
  u = up
  update()
  diff_up = diff_up + up - u
