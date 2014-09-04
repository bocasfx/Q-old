from kivy.uix.widget import Widget
from kivy.graphics import Rectangle
from uuid import uuid4
from time import time
from math import hypot
from kivy.logger import Logger


class Particle(Widget):

    enable_speed = True

    def __init__(self, **kwargs):
        super(Particle, self).__init__(**kwargs)
        self.size = kwargs.get('size', (10, 10))
        self.pos = kwargs.get('pos', (0, 0))
        self.color = kwargs.get('color', 0)
        self.id = str(uuid4())
        self.prev_pos = self.pos
        self.prev_time = 0
        self.speed = 0
        self.max_speed = 400
        with self.canvas:
            self.rect = Rectangle(
                pos=self.pos,
                size=self.size,
                source='images/ball' + str(self.color) + '.png')

        self.bind(pos=self.on_position_changed)

    def on_position_changed(self, *args):
        self.calculate_speed()
        self.normalize_speed()
        self.rect.pos = self.pos
        self.prev_pos = self.rect.pos

    def calculate_speed(self):
        if self.enable_speed:
            elapsed_time = time() - self.prev_time

            dx = self.prev_pos[0] - self.pos[0]
            dy = self.prev_pos[1] - self.pos[1]

            distance = hypot(dx, dy)

            self.speed = distance / elapsed_time
            self.prev_time = time()

            # Max speed can be calculated from the particle's history
            # if self.speed > self.max_speed:
            #     self.max_speed = self.speed
        else:
            self.speed = 1

    def normalize_speed(self):
        self.speed = (self.speed / self.max_speed)
        if self.speed > 1:
            self.speed = 1
