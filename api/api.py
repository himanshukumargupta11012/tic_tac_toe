from flask import Flask, request
import numpy as np
import time
import copy

app = Flask(__name__)

dict = {
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

# ----------- node of tree -------------
class node:
    def __init__(self, key):
        self.value = 0
        self.child = []
        self.position = 0
        self.perfect_child = 0
        self.key = key
board = np.zeros(9, dtype=int)

nodeInstance = {}


curr_key = 0
root = node(curr_key)
nodeInstance[curr_key] = root
curr_key+=1


# ----------------- TRAINING ---------------------

def treeMaking(curr_node, board, height, position):
    
    global done, curr_key
    done = False
    remain_val = 12 - position
    if height%2 ==1:
        for i in range(0, min(9, remain_val)):
            if board[i] == 2 and remain_val - i<9 and board[remain_val - i] == 2 and remain_val - i != i != position and i != position and remain_val - i != position:
                done = True
                curr_node.value = -1
                break
        
    else:
        for i in range(0, min(9, remain_val)):
            if board[i] == 1 and remain_val - i<9 and board[remain_val - i] == 1 and remain_val - i != i != position and i != position and remain_val - i != position:
                done = True
                curr_node.value = 1
                break

    if not done:
        for i in range(len(board)):
            if board[i] == 0:
                board2 = board.copy()
                if height%2 ==0:
                    board2[i] = 2
                else:
                    board2[i] = 1
                curr_node.child.append(node(curr_key))
                nodeInstance[curr_key] = curr_node.child[-1]
                curr_key +=1
                curr_node.child[-1].position = i
                treeMaking(curr_node.child[-1], board2, copy.copy(height) + 1, i)
                
        if height%2 ==0 and len([i.value for i in curr_node.child])>0:
            curr_node.perfect_child = [i.value for i in curr_node.child].index(min([i.value for i in curr_node.child]))
            curr_node.value = min([i.value for i in curr_node.child])
        elif height%2 ==1 and len([i.value for i in curr_node.child])>0:
            curr_node.perfect_child = [i.value for i in curr_node.child].index(max([i.value for i in curr_node.child]))
            curr_node.value = max([i.value for i in curr_node.child])

treeMaking(root, board.copy(), 0, 100)

curr_node = root

@app.route('/api', methods=['GET'])
def api():
    d ={}    
    array_str = request.args['array']
    array = [*array_str]
    curr_turn = request.args['curr_turn']
    curr_node_key = request.args['curr_node']
    curr_node = nodeInstance[int(curr_node_key)]

    # ---------- human turn ----------
    human_input = dict[int(curr_turn)]
    for i in curr_node.child:
        if i.position == human_input:
            curr_node = i

    # ---------- checking game ends or not -------------
    if len(curr_node.child) == 0:
        if curr_node.value == 0:
            d['winner'] = 0
        
        if curr_node.value == -1:
            d['winner'] = 2
        return d

    # ----------- bot turn -----------

    bot_input = curr_node.child[curr_node.perfect_child].position
    bot_index = {i for i in dict if dict[i] == bot_input}.pop()

    curr_node = curr_node.child[np.argmax([i.value for i in curr_node.child])]
    array[bot_index] = str(1)

        # ---------- checking game ends or not -------------
    if len(curr_node.child) == 0:
        if curr_node.value == 1:
            d['winner'] = 1

    array_str = "".join(array)
    d['curr_node'] = curr_node.key
    d['array_str'] = array_str

    return d


if __name__ == '__main__':
    app.run(host='0.0.0.0')