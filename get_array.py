import numpy as np
import sys
np.set_printoptions(threshold=sys.maxsize)


arr = np.load("level_1.npy")

print(np.array2string(arr, separator=', '))


with open("array.txt", "w") as f:
    f.write(np.array2string(arr, separator=', '))