import uuid
import pygame

class Particle:

    def __init__(self, position, colour_index):
        self.position = position
        self.id = uuid.uuid4()
        self.ball = pygame.image.load('images/ball' + str(colour_index) + '.png').convert_alpha()
        self.eraser = pygame.image.load('images/eraser.png').convert_alpha()

    def update_position(self, position):
        self.position = position

    def draw(self, screen):
        screen.blit(self.ball, self.position)
        
    def erase(self, screen, position):
        screen.blit(self.eraser, position)
        