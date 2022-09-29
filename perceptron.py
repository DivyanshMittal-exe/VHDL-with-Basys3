import numpy as np

f = open("file.mif","r")

data = f.readlines()
w1 = np.array(data[1024:1024+784*64])
b1 = np.array(data[1024+784*64:1024+784*64+64])
# print(b1)
for i in range(len(data)):
    data[i] = int(data[i],2)
    if(data[i]>=128):
        data[i] = data[i] - 256

image = np.array(data[:784])
w1 = np.array(data[1024:1024+784*64])
b1 = data[1024+784*64:1024+784*64+64]
# print(b1)
w2 = np.array(data[1024+784*64+64:1024+784*64+64+64*10])
b2 = np.array(data[1024+784*64+64+64*10:])

w1 = np.reshape(w1,(64,784))
w2 = np.reshape(w2,(10,64))

w1 = np.transpose(w1)
w2 = np.transpose(w2)

output1 = [0 for _ in range(64)]

for i in range(64):
    accum = 0
    for j in range(784):
        accum += image[j]*w1[j][i]
        accum = accum%(2**(16))
        if(accum>=2**15):
            accum = accum-2**16
        if(i == 3  ):
            print(f"{j} {accum} {w1[j][i]} {image[j]}")
    output1[i] = accum

# print(output1)
print(b1)

for i in range(len(output1)):
    output1[i] = b1[i] + output1[i]//32
    
    
output1 = [0 if x < 0 else x for x in output1]

output2 = [0 for _ in range(10)]

print(output1)

for i in range(10):
    accum = 0
    for j in range(64):
        accum += output1[j]*w2[j][i]
        accum = accum%(2**(16))
        if(accum>=2**15):
            accum = accum-2**16
    output2[i] = accum

for i in range(len(output2)):
    output2[i] = b2[i] + output2[i]//32
    
print(output2)
print(b2)
# output1 = np.array(output1)
# output1 = output1 + b1
# print(output1)

# output1 = (np.matmul(image,w1)+b1)
# print(output1)

# for i in range(len(output1)):
#     if(output1[i]<0):
#         output1[i] = 0

# # print(output1)

# output2 = (np.matmul(output1,w2)+b2)

# print(output2)