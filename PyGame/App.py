import Environment
import Controller
import ControlPanel
import Worm
import Node
import pygame
import rtmidi_python as rtmidi


class App:

    running = True
    midi_device = 0

    def __init__(self, **kargs):

        """ Constructor - Initializes the environment, the controller and the control panel."""

        size = kargs.get('size', (800, 600))
        bg_colour = kargs.get('bg_colour', (140, 40, 240))
        title = 'Coatl 0.1 alpha'

        self.control_panel = ControlPanel.ControlPanel(size)
        self.environment = Environment.Environment(size, bg_colour, title, self.control_panel)

        worm_size = 200
        particle_count = 10

        pygame.init()
        self.midi_out = rtmidi.MidiOut()
        self.midi_out.open_port(0)

        self.environment.add_node(Node.Node((85, 85), self.midi_out))
        self.environment.add_node(Node.Node((185, 185), self.midi_out))
        self.environment.add_node(Node.Node((285, 285), self.midi_out))
        self.environment.add_node(Node.Node((385, 385), self.midi_out))
        self.environment.add_node(Node.Node((485, 485), self.midi_out))
        self.environment.add_node(Node.Node((585, 585), self.midi_out))

        self.environment.add_worm(Worm.Worm(worm_size, particle_count, 0))
        self.environment.add_worm(Worm.Worm(worm_size, particle_count, 1))
        self.environment.add_worm(Worm.Worm(worm_size, particle_count, 2))
        self.environment.add_worm(Worm.Worm(worm_size, particle_count, 3))

        self.controller = Controller.Controller(
            self,
            self.environment,
            self.control_panel)

    def loop(self):
        """ Application's main loop. """

        clock = pygame.time.Clock()
        while self.running:
            clock.tick(30)
            self.controller.handle_events()
            self.environment.draw()
            self.environment.flip()
        pygame.quit()
