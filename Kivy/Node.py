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

    def __init__(self, **kwargs):
        super(Node, self).__init__(**kwargs)
        self.size = kwargs.get('size', (30, 30))
        self.active_image = kwargs.get('active_image', 'images/active_node.png')
        self.inactive_image = kwargs.get('inactive_image', 'images/node.png')
        self.muted_image = kwargs.get('muted_image', 'images/muted_node.png')
        self.selected_image = kwargs.get('selected_image', 'images/selected_node.png')
        self.midi_out = kwargs.get('midi_out')
        self.particle_queue = deque()
        self.note = kwargs.get('note', randint(60, 80))
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

    def note_on(self, velocity):
        self.midi_out.send_message([0x90, self.note, velocity])

    def note_off(self):
        self.midi_out.send_message([0x80, self.note, 0])

    def handle_collisions(self, particle):
        collided = self.collide_widget(particle)
        in_queue = True if particle.id in self.particle_queue else False
        if collided:
            if not in_queue:
                self.particle_queue.append(particle.id)
                if len(self.particle_queue) == 1:
                    if random() >= 0.7:
                        self.status = 'active'
                        self.redraw(self.status)
                        self.note_on(particle.speed * 127)
                    else:
                        self.status = 'muted'
                        self.redraw(self.status)
        else:
            if in_queue:
                self.particle_queue.remove(particle.id)
                if len(self.particle_queue) == 0:
                    self.status = 'inactive'
                    self.redraw(self.status)
                self.note_off()

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
