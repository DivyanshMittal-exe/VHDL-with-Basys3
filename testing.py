
from K_map_gui_tk import *
import random
# Added .py to the end. Removed due to autograder breaking


solver = __import__('2020CS10342_2020CS10330_assignment_1')

k = random.randrange(3) + 2
# k = 3

if k == 2:
    k_map_gen = [[random.randrange(3) for _ in range(2)] for _ in range(2)]

elif k == 3:
    k_map_gen = [[random.randrange(3) for _ in range(4)] for _ in range(2)]
    
elif k == 4:
    k_map_gen = [[random.randrange(3) for _ in range(4)] for _ in range(4)]
    

k_map_gen =  [['x' if j == 2 else j for j in row] for row in k_map_gen]    

terms = [random.randrange(3) for _ in range(k)]
terms = [None if e == 2 else e for e in terms]

print(terms)    
try:
    root = kmap(k_map_gen, terms)
except:
    root = kmap(k_map_gen)
    
p1, p2, leg = solver.is_legal_region(k_map_gen,terms)

x1,y1 = p1
x2,y2 = p2

if leg:
    root.draw_region(x1,y1,x2,y2,'green')
else:
    root.draw_region(x1,y1,x2,y2,'red')
root.mainloop()
