#!/usr/bin/env python3
import threading
import queue
import random
import time

q_in = queue.Queue()
#q_out = queue.Queue()

def worker():
    while True:
        item = q_in.get()
        print(f'Working on {item}')
        time.sleep(random.randint(2,5))
        print(f'Finished {item}')
#        q_out.put(f'Finished {item}')
        q_in.task_done()

# Turn-on the worker thread.
for r in range(5):
    threading.Thread(target = worker, daemon = True).start()

# Send thirty task requests to the worker.
for item in range(10):
    q_in.put(item)

# Block until all tasks are done.
q_in.join()

#while q_out.not_empty:
#while True:
#    print(q_out.get())
#    q_out.task_done()

#q_out.task_done()
#q_out.join()

print('All work completed')

