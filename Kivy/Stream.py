from kivy.uix.widget import Widget
from collections import deque
from kivy.clock import Clock
from Particle import Particle
from random import randint
import thread

class Stream(Widget):

    color = (1, 1, 1)
    queue = []
    stream_size = 400
    easing = ''
    particle_count = 5
    mouse_state = "up"
    head_position = ''
    path_index = 0
    path = []
    active = False
    ignore_touch = False

    def __init__(self, **kwargs):
        super(Stream, self).__init__(**kwargs)
        self.queue = deque()
        self.color = kwargs.get('color', randint(0, 3))
        self.active = kwargs.get('active', False)

        for i in range(self.particle_count):
            part = Particle(color=self.color)
            self.add_widget(part)

        thread.start_new_thread( self.schedule_flow, ())
        # Clock.schedule_interval(self.flow, 0)

    def schedule_flow(self, *args):
        Clock.schedule_interval(self.flow, 0)

    def flow(self, *obj):
        if self.active and not self.head_position == '':
            if self.mouse_state == "up":
                if len(self.path) > 0:
                    self.head_position = self.path[self.path_index]
                    self.advance_path_index()
            else:
                self.path.append(self.head_position)
                # Add points to the queue until it reaches the desired size.
                if len(self.queue) < self.stream_size:
                    self.queue.append(self.head_position)

            if self.easing == '':
                self.easing = self.head_position

            self.easing = self.calculate_easing(
                self.head_position,
                self.easing,
                0.08)
            self.queue[0] = self.easing
            self.queue.rotate(1)

            i = 1
            j = 0
            while i < len(self.queue):
                self.children[j].pos = self.queue[i]
                i += (self.stream_size / self.particle_count)
                j += 1

    def get_active(self):
        return self.active

    def set_active(self, active):
        self.active = active

    def enable_speed(self, enable):
        for particle in self.children:
            particle.enable_speed = enable

    def advance_path_index(self):
        self.path_index += 1
        if self.path_index >= len(self.path) - 1:
            self.path_index = 0

    def calculate_easing(self, position, easing, easing_factor):
        # Calculate easing
        dx = position[0] - easing[0]
        easing = (easing[0] + (dx * easing_factor), easing[1])

        dy = position[1] - easing[1]
        easing = (easing[0], easing[1] + (dy * easing_factor))

        return easing

    # Inbound events -------------------------------------------

    def on_touch_down(self, touch):
        if self.ignore_touch:
            return
        if self.active:
            self.head_position = (touch.x, touch.y)
            self.path = []
            self.path_index = 0
            self.path.append(self.head_position)
            self.mouse_state = "down"

    def on_touch_up(self, touch):
        if self.ignore_touch:
            return
        if self.active:
            self.mouse_state = "up"

    def on_touch_move(self, touch):
        if self.ignore_touch:
            return
        if self.active:
            self.head_position = (touch.x, touch.y)

    def on_ignore_touch(self, *args):
        self.ignore_touch = True

    def on_acknowledge_touch(self, *args):
        self.ignore_touch = False

    def on_mouse_state_changed(self, *args):
        self.mouse_state = args[1]

    
