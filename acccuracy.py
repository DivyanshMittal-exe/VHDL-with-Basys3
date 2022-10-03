import numpy as np
from mlxtend.data import mnist_data
import random



f = open("file_1.mif","r")

data = f.readlines()


for i in range(len(data)):
    data[i] = int(data[i],2)
    if(i>1023):
        if(data[i]>=128):
            data[i] = data[i] - 256

image = np.array(data[:784])
w1 = np.array(data[1024:1024+784*64])
b1 = data[1024+784*64:1024+784*64+64]
w2 = np.array(data[1024+784*64+64:1024+784*64+64+64*10])
b2 = np.array(data[1024+784*64+64+64*10:])

w1 = np.reshape(w1,(64,784))
w2 = np.reshape(w2,(10,64))

w1 = np.transpose(w1)
w2 = np.transpose(w2)



X, y = mnist_data()

i_s = [i for i in range(len(X))]
random.shuffle(i_s)


def twos(val_str, bytes):
    import sys
    val = int(val_str, 2)
    b = val.to_bytes(bytes, byteorder=sys.byteorder, signed=False)                                                          
    return int.from_bytes(b, byteorder=sys.byteorder, signed=True)

sum = 0
tot = 0
for i_ss in i_s:
    tot += 1
    image = X[i_ss]
    typ = y[i_ss]
    image = image.flatten()

    image = [int(e) for e in image]

    output1 = [0 for _ in range(64)]

    for i in range(64):
        accum = 0
        for j in range(784):
            accum += image[j]*w1[j][i]
            accumb = np.binary_repr(accum,width=24)[-24:]
            accumb = accumb[0] + accumb[-15:]         
            accum = twos(accumb,2)

        output1[i] = accum

    for i in range(len(output1)):
        output1[i] = (b1[i] + output1[i])//32
        
        
    output1 = [0 if x < 0 else x for x in output1]
    output2 = [0 for _ in range(10)]


    for i in range(10):
        accum = 0
        for j in range(64):
            
            accum += output1[j]*w2[j][i]
            accumb = np.binary_repr(accum,width=24)[-24:]
            accumb = accumb[0] + accumb[-15:]
            accum = twos(accumb,2)

        output2[i] = accum

    for i in range(len(output2)):
        output2[i] = (b2[i] + output2[i])//32
        
        
    index_max = max(range(len(output2)), key=output2.__getitem__)
    sum += index_max == typ
    
    print(sum/tot)
    
    
print(sum/len(y))
