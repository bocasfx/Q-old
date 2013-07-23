import pygame
import pygame.font


class ControlPanel:

    width = 300
    bg_colour = (30, 30, 30)
    cp_font = ""

    def __init__(self, screen_size):

        self.size = (self.width, screen_size[1])
        self.origin = (screen_size[0] - self.width, 0)
        self.surface = pygame.Surface(self.size, pygame.SRCALPHA)

        pygame.font.init()

        self.cp_font = pygame.font.Font('fonts/pf_arma_five.ttf', 8)
        self.text = self.cp_font.render('Control Panel', False, (200, 200, 200))

    def draw(self, screen):
        self.surface.fill(self.bg_colour)
        self.surface.blit(self.text, (20, 10))
        screen.blit(self.surface, self.origin)
