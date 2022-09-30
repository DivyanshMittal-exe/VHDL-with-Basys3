# import numpy as np
# from PIL import Image

# # for x in range(1,10):

# #     im = Image.open(f"Images/{x}.png","r")

# #     pix_val = list(im.getdata())

# #     f = open(f"MIF/{x}.mif","w")

# #     for i in range(len(pix_val)):
# #         f.write("{0:08b}".format(pix_val[i])+"\n")

# f = open("MIF/imgdata_digit7.mif","r")
# val = f.readlines()
# for i in range(len(val)):
#     val[i] = int(val[i],2)

# val = np.array(val)
# val = np.reshape(val, (28,28))

# data = Image.fromarray(val.astype(np.uint8))
# data.save("Images/og.png")

accumb = "-00000000000000000000001"
accumb = "1"+accumb[1:]
n = int(accumb,2)
n = 2**24-n
accumb = "1"+"{0:023b}".format(n)
print(accumb)