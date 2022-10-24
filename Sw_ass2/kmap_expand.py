import math
from tabnanny import check
from K_map_gui_tk import *


# root = kmap([[1,1,1,1], [1,1,1,1], [1,1,1,1], [1,1,1,1]])
# root.draw_region(1,3,2,0,'blue')
# root.draw_region(1,1,2,2,'green')
# root.mainloop()

def check_region(kmap, startx, starty, finishx, finishy):
    """check if a specified region is valid"""

    m = len(kmap)
    n = len(kmap[0])

    startx %= m
    finishx %= m
    starty %= n
    finishy %= n
    h = (finishx - startx)%m + 1
    w = (finishy - starty)%n + 1

    flag = True

    i = 0

    while(i<h):
        j = 0
        while(j<w):
            if(kmap[(startx+i)%m][(starty+j)%n] == 0):
                flag = False
                break
            j += 1
        
        if(not flag):
            break
        i += 1

    return flag


def find_expansion_direction(kmap, startx, starty, finishx, finishy):
    """find a valid expansion direction of region if exists"""
    
    m = len(kmap)
    n = len(kmap[0])

    startx %= m
    finishx %= m
    starty %= n
    finishy %= n
    h = (finishx - startx)%m + 1
    w = (finishy - starty)%n + 1

    if(check_region(kmap, startx, starty, finishx, finishy+w)):
        if(w!=n):
            return "Right"
    if(check_region(kmap, startx, starty, finishx+h, finishy)):
        if(h!=m):
            return "Down"
    if(check_region(kmap, startx, starty-w, finishx, finishy)):
        if(w!=n):
            return "Left"
    if(check_region(kmap, startx-h, starty, finishx, finishy)):
        if(h!=m):
            return "Up"
    
    return "None"


def expand_full(kmap, startx, starty, finishx, finishy):
    """m*n kmap, expand the a region fully and return new rectangle"""
    
    m = len(kmap)
    n = len(kmap[0])

    startx %= m
    finishx %= m
    starty %= n
    finishy %= n
    h = (finishx - startx)%m + 1
    w = (finishy - starty)%n + 1

    direction = find_expansion_direction(kmap, startx, starty, finishx, finishy)

    while(direction != "None"):

        if(direction == "Right"):
            finishy += w
            finishy %= n
        elif(direction == "Down"):
            finishx += h
            finishx %= m
        elif(direction == "Left"):
            starty -= w
            starty %= n
        elif(direction == "Up"):
            startx -= h
            startx %= m
        
        h = (finishx - startx)%m + 1
        w = (finishy - starty)%n + 1
        direction = find_expansion_direction(kmap, startx, starty, finishx, finishy)

    return (startx, starty, finishx, finishy)

# kmap = [[1,1,1,1],[1,1,1,1],[1,1,1,1],[0,0,0,0]]
# print(expand_full(kmap, 0, 1, 0, 1))

def expand_all_full(kmap):
    """expands all the terms fully and returns list of terms in expanded K-map"""

    m = len(kmap)
    n = len(kmap[0])
    uncovered = set()  # Set to contain the uncovered 1's in kmap

    for i in range(m):
        for j in range(n):
            if(kmap[i][j] == 1):
                uncovered.add((i,j))

    expanded_regions = []

    for i in range(m):
        for j in range(n):

            if((kmap[i][j] == 1) and ((i,j) in uncovered)):
                startx, starty, finishx, finishy = expand_full(kmap, i,j,i,j)

                startx %= m
                finishx %= m
                starty %= n
                finishy %= n
                h = (finishx - startx)%m + 1
                w = (finishy - starty)%n + 1

                ii = 0

                while(ii<h):
                    jj = 0
                    while(jj<w):
                        if(kmap[(startx+ii)%m][(starty+jj)%n] == 1):
                            if(((startx+ii)%m,(starty+jj)%n) in uncovered):
                                uncovered.remove(((startx+ii)%m, (starty+jj)%n))
                        jj += 1

                    ii += 1

                expanded_regions.append((startx, starty, finishx, finishy))

    return expanded_regions

kmap =[[0,0,1,0], [0,1,1,0], [0,1,0,0],[0,0,0,0]]
print(expand_all_full(kmap))