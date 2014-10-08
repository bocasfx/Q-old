from kivy.uix.scatter import Scatter
from kivy.graphics import Rectangle
from collections import deque
from random import randint, random
from uuid import uuid4
from kivy.logger import Logger


class Node(Scatter):

    particle_queue = []
    selected = True
    status = 'inactive'
    enabled = True
    velocity = 127
    channel = 0x0
    probability = 0

    def __init__(self, **kwargs):
        super(Node, self).__init__(**kwargs)
        self.size = kwargs.get('size', (30, 30))
        self.active_image = kwargs.get('active_image', 'images/active_node.png')
        self.inactive_image = kwargs.get('inactive_image', 'images/node.png')
        self.muted_image = kwargs.get('muted_image', 'images/muted_node.png')
        self.selected_image = kwargs.get('selected_image', 'images/selected_node.png')
        self.midi_out = kwargs.get('midi_out')
        self.particle_queue = deque()
        dminor = [50, 52, 53, 55, 57, 59, 60, 62, 64, 65, 67, 69, 71, 72]
        index = randint(0, 13)
        self.note = kwargs.get('note', dminor[index])
        self.register_event_type('on_node_selected')
        self.register_event_type('on_node_deselected')
        self.id = str(uuid4())
        self.canvas.clear()
        with self.canvas:
            Rectangle(
                size=self.size,
                source=self.inactive_image,
                mipmap=True)
        self.position_changed = False

    def set_probability(self, probability):
        self.probability = probability

    def get_probability(self):
        return self.probability

    def set_channel(self, channel):
        self.channel = channel

    def get_channel(self):
        return self.channel

    def set_velocity(self, velocity):
        self.velocity = velocity

    def set_enabled(self, enabled):
        self.enabled = enabled

    def set_note(self, note):
        self.note = int(note, 16)

    def note_on(self, velocity):
        status = "0x90"
        status = self.add_hex(status, self.channel)
        self.midi_out.send_message([status, self.note, velocity])

    def note_off(self):
        status = "0x80"
        status = self.add_hex(status, self.channel)
        self.midi_out.send_message([status, self.note, 0])

    def add_hex(self, hex1, hex2):
        result = int(str(hex1), 16) + int(str(hex2), 16)
        return result

    def handle_collisions(self, particle):
        collided = self.collide_widget(particle)
        in_queue = True if particle.id in self.particle_queue else False
        if collided:
            if not in_queue:
                self.particle_queue.append(particle.id)
                if len(self.particle_queue) == 1:
                    if random() >= self.probability and self.enabled:
                        self.status = 'active'
                        self.redraw(self.status)
                        velocity = particle.speed * self.velocity
                        self.note_on(velocity)
                    else:
                        self.status = 'muted'
                        self.redraw(self.status)
        else:
            if in_queue:
                self.particle_queue.remove(particle.id)
                if len(self.particle_queue) == 0:
                    self.status = 'inactive'
                    self.redraw(self.status)
                # self.note_off()

    def redraw(self, status):
        self.canvas.clear()
        with self.canvas:
            if status == 'active':
                Rectangle(
                    size=self.size,
                    source=self.active_image,
                    mipmap=True)
            elif status == 'muted':
                Rectangle(
                    size=self.size,
                    source=self.muted_image,
                    mipmap=True)
            else:
                Rectangle(
                    size=self.size,
                    source=self.inactive_image,
                    mipmap=True)
            if self.selected:
                Rectangle(
                    size=self.size,
                    source=self.selected_image,
                    mipmap=True)

    # Inbound events -------------------------------------------

    def on_touch_down(self, touch):
        # If touch falls on me, then I'm selected
        if self.collide_point(touch.x, touch.y):
            self.dispatch('on_node_selected')
            self.selected = True
        else:
            self.selected = False

        self.redraw('normal')
        return super(Node, self).on_touch_down(touch)

    def on_touch_up(self, touch):
        self.dispatch('on_node_deselected')
        self.position_changed = False
        return super(Node, self).on_touch_up(touch)

    def on_touch_move(self, touch):
        self.position_changed = True
        return super(Node, self).on_touch_move(touch)

        
    # Outbound events -------------------------------------------

    def on_node_selected(self, *args):
        pass

    def on_node_deselected(self, *args):
        pass
