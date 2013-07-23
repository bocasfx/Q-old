import logging
import pygame
import Static


log = logging.getLogger(__name__)


class Environment:

    screen = ""
    width = 0
    canvas_width = 0

    def __init__(self, (width, height), bg_colour, title, control_panel):
        self.width = width
        self.height = height
        self.bg_colour = bg_colour

        self.screen = pygame.display.set_mode((width, height))
        pygame.display.set_caption(title)

        Static.Static.selected_worm = 0
        self.fill()
        self.control_panel = control_panel
        self.control_panel.draw(self.screen)

        self.canvas_width = self.width - self.control_panel.width

    def add_worm(self, worm):
        Static.Static.worms.append(worm)

    def add_node(self, node):
        Static.Static.nodes.append(node)

    def fill(self):
        self.screen.fill(self.bg_colour)

    def flip(self):
        pygame.display.flip()

    def handle_mouse_down_event(self, position):
        # The mouse pointer leads the worm
        Static.Static.worms[Static.Static.selected_worm].leader = "mouse"
        Static.Static.worms[Static.Static.selected_worm].reset()
        Static.Static.worms[Static.Static.selected_worm].update_position(position)

    def handle_mouse_motion_event(self, position, dragging):
        Static.Static.worms[Static.Static.selected_worm].update_position(position)

    def handle_mouse_up_event(self):
        # The worms follow the drawn paths
        Static.Static.worms[Static.Static.selected_worm].leader = "path"

        # TODO: once control panel is complete this should be removed
        # Select the next worm
        Static.Static.selected_worm += 1
        if Static.Static.selected_worm > len(Static.Static.worms) - 1:
            Static.Static.selected_worm = 0

    def draw(self):
        # Erase all worms first to avoid superposition artifacts
        for worm in Static.Static.worms:
            worm.erase(self.screen)

        for node in Static.Static.nodes:
            node.erase(self.screen)

        for node in Static.Static.nodes:
            node.draw(self.screen)

        # Once everything is cleared draw the worms
        for worm in Static.Static.worms:
            worm.update()
            worm.draw(self.screen)
