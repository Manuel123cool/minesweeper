#!/usr/bin/python3

import random
import arcade
import pdb

SCREEN_WIDTH = 600
SCREEN_HEIGHT = 600
SCREEN_TITLE = "Minsweeper"

class Minesweeper:
    def __init__(self):
        self.minList = []
        for i in range(0, 169):
            self.minList.append(0)
        self.realMinPos = []
    def layBombs(self):
        for i in range(0, 20):
            randNum = random.randrange(0, 169)                      
            if self.minList[randNum] != -1:
                self.minList[randNum] = -1
                self.realMinPos.append(randNum)
    def testPos(self, pos, num):
        if self.minList[pos + num] >= 0:
            self.minList[pos + num] += 1
    def setNumberTiles(self):
        #pdb.set_trace()
        for x, pos in enumerate(self.realMinPos):
            if pos == 156:
                self.testPos(pos, 1)
                self.testPos(pos, -12) 
                self.testPos(pos, -13)
                self.realMinPos.pop(x)
            if pos == 0:
                self.testPos(pos, 1)
                self.testPos(pos, 14)
                self.testPos(pos, 13)
                self.realMinPos.pop(x)
            if pos == 12:
                self.testPos(pos, -1)
                self.testPos(pos, 12)
                self.testPos(pos, 13)
                self.realMinPos.pop(x)
            if pos == 168:
                self.testPos(pos, -1)
                self.testPos(pos, -14)
                self.testPos(pos, -13)
                self.realMinPos.pop(x)
        for j in range(0,156, 13):
            for i, pos in enumerate(self.realMinPos):
                if pos == j:
                    #left side
                    self.testPos(pos, 1)
                    self.testPos(pos, -12)
                    self.testPos(pos, -13)
                    self.testPos(pos, +13)
                    self.testPos(pos, +14)
                    self.realMinPos.pop(i)
        for j in range(0, 13):
            for i, pos in enumerate(self.realMinPos):
                if pos == j:
                    #under side
                    self.testPos(pos, +1)
                    self.testPos(pos, -1)
                    self.testPos(pos, +12)
                    self.testPos(pos, +13)
                    self.testPos(pos, +14)
                    self.realMinPos.pop(i)
        for j in range(12, 168, 13):
            for i, pos in enumerate(self.realMinPos):
                if pos == j:
                    #right sight
                    self.testPos(pos, -1)
                    self.testPos(pos, +12)
                    self.testPos(pos, +13)
                    self.testPos(pos, -13)
                    self.testPos(pos, -14)
                    self.realMinPos.pop(i)
        for j in range(156, 169):
            for i, pos in enumerate(self.realMinPos):
                if pos == j:
                    #upper side
                    self.testPos(pos, +1)
                    self.testPos(pos, -1)
                    self.testPos(pos, -13)
                    self.testPos(pos, -14)
                    self.testPos(pos, -12)
                    self.realMinPos.pop(i)
        for i, pos in enumerate(self.realMinPos):
            self.testPos(pos, +1)
            self.testPos(pos, -1)
            self.testPos(pos, +14)
            self.testPos(pos, -14)
            self.testPos(pos, +13)
            self.testPos(pos, -13)
            self.testPos(pos, +12)
            self.testPos(pos, -12)

minesweeper = Minesweeper()
minesweeper.layBombs()
minesweeper.setNumberTiles()

class Game:
    def __init__(self):
        self.showList = []
        for i in range(0, 169):
            self.showList.append(False)
    def getIndex(self, x, y):
        xRow = 0
        yRow = 0
        count = 0
        for i in range(0, 13):
            if i * 45 - x < xRow:
                xRow = count    
                count += 1

        count1 = 0 
        for i in range(0, 13):
            if i * 45 - y < yRow:
                yRow = count1
                count1 += 1
        
        index = yRow * 13 + xRow
        return index        
    def gameOver(self):
        for i in range(0, len(minesweeper.minList)):
            minesweeper.minList[i] = 0
        for i in range(0, len(minesweeper.realMinPos)):
            minesweeper.realMinPos.pop()
        for i in range(0, len(self.showList)):
            self.showList[i] = False
        minesweeper.layBombs()
        minesweeper.setNumberTiles()
    def mousePressed(self, x, y):
        index = self.getIndex(x, y)
        self.showList[index] = True
        if minesweeper.minList[index] == -1:
             self.gameOver()

game = Game()

def on_draw(delte_time):
    arcade.start_render()
    count = 0
    for i in range(0, 13):
        for j in range(0, 13):
            arcade.draw_rectangle_filled(25+j*45, 25+45*i, 
                    40, 40, arcade.color.BLUSH)

            if game.showList[count]:
                arcade.draw_rectangle_filled(25+j*45, 25+45*i, 
                    40, 40, arcade.color.GREEN)

                if minesweeper.minList[count] == -1:
                    arcade.draw_circle_filled(25+j*45, 25+45*i, 10,  
                        arcade.color.GREEN) 
                if minesweeper.minList[count] > 0:
                    arcade.draw_text(str(minesweeper.minList[count]), 
                        17+j*45, 13+45*i, arcade.color.BLACK, 20)
            count += 1
    
class MyGame(arcade.Window):
    def __init__(self, width, height, title):
        super().__init__(width, height, title)
        arcade.set_background_color(arcade.color.ASH_GREY)
    def on_key_press(self, key, modifiers):
        pass
    def on_mouse_press(self, x, y, button, modifiers):
        if button == arcade.MOUSE_BUTTON_LEFT:
            game.mousePressed(x, y)
 
arcade.schedule(on_draw, 1 / 80)
MyGame(SCREEN_WIDTH, SCREEN_HEIGHT, SCREEN_TITLE)
arcade.run()
