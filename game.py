# importing necessary libraries
import tkinter as tk
import numpy as np
from tkinter import messagebox



class system():
    def __init__(self, value):
        self.value = value

        self.dict = {
    0 : 1,
    1 : 6,
    2 : 5,
    3 : 8,
    4 : 4,
    5 : 0,
    6 : 3,
    7 : 2,
    8 : 7,
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
    
    # finds index given board config
    def index(self, arr):
        index = 3**8 * arr[0] + 3**7 * arr[1] + 3**6 * arr[2] + 3**5 * arr[3] + 3**4 * arr[4] + 3**3 * arr[5] + 3**2 * arr[6] + 3**1 * arr[7] + 3**0 * arr[8]
        return int(index)
    
    # checks if someone wons or not
    def checkEnd(self, board, turn, index):
        first = self.dict[index]
        left = 12 - first
        for i in range(min(9, left)):
            for j in range(i+1, min(9, left)):
                if i != first and j != first and i + j == left and board[self.dict2[i]] == turn and board[self.dict2[j]] == turn:
                    return True
                
        return False

    # testing
    def test(self, board):
        max = -10**5
        global max_index
        max_index = 0
        for k in range(9):
            if board[k] == 0:

                temp_board = board.copy()
                temp_board[k] = 2
                
                if max < self.value[self.index(temp_board)]:
                    max = self.value[self.index(temp_board)]
                    max_index = k
            
        

        if self.checkEnd(board, 2, max_index):
            return max_index, 1
        
        return max_index, -1


# ------ levels ----------------
level_2_value = np.load("level_2.npy")
level_2 = system(level_2_value)

level_1_value = np.load("level_1.npy")
level_1 = system(level_1_value)



# ----------------- TESTING ------------------
test_board = np.zeros(9, dtype=int)

def oneChance(m, system):
    global test_board
    
    # -------------- human player chance -----------------
    btn_array[m].config(text = 'X', font=('Ariel', 10), foreground = 'black', state = tk.DISABLED)
    game.update()

    test_board[m] = 1

    # ---------- checking game ends or not -------------

    # checking for win
    if system.checkEnd(test_board, 1, m):
        play_again = messagebox.askyesno('You won', 'Do you wanna play again?')
        if play_again:
            test_board = np.zeros(9, dtype=int)
            for row in range(3):
                for col in range(3):
                    btn_array[row*3+col].config(text = '', font=('Ariel', 10), foreground = 'black', state = tk.NORMAL)
            return
        else:
            exit()

    # checking for draw
    if not np.isin(0, test_board):
        play_again = messagebox.askyesno('Draw', 'Do you wanna play again?')
        if play_again:
            test_board = np.zeros(9, dtype=int)
            for row in range(3):
                for col in range(3):
                    btn_array[row*3+col].config(text = '', font=('Ariel', 10), foreground = 'black', state = tk.NORMAL)
            return
        else:
            exit()

    # ----------- bot's turn --------------

    bot_index, type = system.test(test_board)


    btn_array[bot_index].config(text = 'O', font=('Ariel', 10), foreground = 'black', state = tk.DISABLED)
    game.update()
    test_board[bot_index] = 2
    print(test_board)

    # ---------- checking bot wins or not -----------
    if type == 1:
        play_again = messagebox.askyesno('You lose.', 'Do you wanna play again?')

        if play_again:
            test_board = np.zeros(9, dtype=int)
            for row in range(3):
                for col in range(3):
                    btn_array[row*3+col].config(text = '', font=('Ariel', 10), foreground = 'black', state = tk.NORMAL)
            return
        else:
            exit()        


# --------------- GUI -------------------

game = tk.Tk()

game.title("tic-tac-toe")
game.resizable(False, False)

btn_array = []

level = messagebox.askyesno('Level Selection', 'Choose a level: Beginner or not')
if level:
    system = level_1
else:
    system = level_2

for row in range(3):
    for col in range(3):
        btn_array.append(tk.Button(height=3, width=5, command=lambda r=row, c=col :oneChance(3*r + c, system)))
        btn_array[3*row + col].grid(row=row, column=col)

game.mainloop()
game.destroy()