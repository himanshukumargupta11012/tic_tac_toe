import numpy as np
import random


class system():
    def __init__(self):
        self.board = np.zeros(9, dtype=int)
        self.value = np.zeros(3**9)
        self.lr = .1

        self.dict = {
            0: 1,
            1: 6,
            2: 5,
            3: 8,
            4: 4,
            5: 0,
            6: 3,
            7: 2,
            8: 7,
        }
        self.dict2 = {
            1: 0,
            6: 1,
            5: 2,
            8: 3,
            4: 4,
            0: 5,
            3: 6,
            2: 7,
            7: 8
        }

        self.order = [0, 1, 2, 3, 4, 5, 6, 7, 8]

    # ---- index in value array for given board configuration ----
    def index(self, arr):
        index = 3**8 * arr[0] + 3**7 * arr[1] + 3**6 * arr[2] + 3**5 * arr[3] + \
            3**4 * arr[4] + 3**3 * arr[5] + 3**2 * \
            arr[6] + 3**1 * arr[7] + 3**0 * arr[8]
        return int(index)

    # ---- for checking game ends or not
    def checkEnd(self, board, turn, index):
        first = self.dict[index]
        left = 12 - first
        for i in range(min(9, left)):
            for j in range(i+1, min(9, left)):
                if i != first and j != first and i + j == left and board[self.dict2[i]] == turn and board[self.dict2[j]] == turn:
                    return True

        return False

    # ------- training ----------
    def train(self, n_epochs):

        for i in range(n_epochs):
            for j in range(9):

                self.order = random.sample(self.order, 9)

                max = -10**5
                min = 10**5
                max_index = 0
                min_index = 0

                # ---- finding next turn with maximum or minimum value depending or player and updating value ----
                for k in self.order:
                    if self.board[k] == 0:

                        temp_board = self.board.copy()
                        temp_board[k] = j % 2 + 1

                        if max < self.value[self.index(temp_board)]:
                            max = self.value[self.index(temp_board)]
                            max_index = k

                        if min > self.value[self.index(temp_board)]:
                            min = self.value[self.index(temp_board)]
                            min_index = k

                # ---- when bot plays ----
                if j % 2 == 0:
                    self.value[self.index(self.board)] += self.lr * \
                        (min - self.value[self.index(self.board)])
                    self.board[min_index] = 1

                    if self.checkEnd(self.board, 1, min_index):
                        self.value[self.index(self.board)] += -1
                        break
                    
                # ---- when player plays ----
                else:
                    self.value[self.index(self.board)] += self.lr * \
                        (max - self.value[self.index(self.board)])

                    self.board[max_index] = 2

                    if self.checkEnd(self.board, 2, max_index):
                        self.value[self.index(self.board)] += 1
                        break

            self.board = np.zeros(9, dtype=int)

# for beginners
level_1 = system()

level_1.train(3000)

np.save("level_1", level_1.value)


# for advanced
level_2 = system()

level_2.train(20000)

np.save("level_2", level_2.value)
