from pygame import image
from math import hypot
import random
import uuid
from collections import deque


class Node:

    size = 30
    enabled = True
    particle_queue = []
    note = 40
    velocity = 127
    channel = 0
    playing = False
    muted = False
    latency = 0
    buffer_size = 4096
    midi_device = ''

    def __init__(self, position, midi_out):
        self.id = uuid.uuid4()
        self.position = position
        self.particle_queue = deque()
        self.node = image.load(
            'images/node.png').convert_alpha()

        self.active_node = image.load(
            'images/active_node.png').convert_alpha()

        self.muted_node = image.load(
            'images/muted_node.png').convert_alpha()

        self.eraser = image.load(
            'images/node_eraser.png').convert_alpha()

        self.midi_out = midi_out
        self.note = random.randint(0, 127)

    def draw(self, screen):
        if self.enabled:
            if self.playing:
                if self.muted:
                    screen.blit(self.muted_node, self.position)
                else:
                    screen.blit(self.active_node, self.position)
            else:
                screen.blit(self.node, self.position)
        else:
            # TODO: disabled_node.png
            pass

    def erase(self, screen):
        screen.blit(self.eraser, self.position)

    def detect_collision(self, position):
        distance = hypot(
            position[0] - self.position[0],
            position[1] - self.position[1])

        if distance <= 30:
            return True

        return False

    def queue_particle(self, particle_id):
        self.particle_queue.append(particle_id)

    def dequeue_particle(self, particle_id):
        self.particle_queue.remove(particle_id)

    def is_in_queue(self, particle_id):
        for pid in self.particle_queue:
            if pid == particle_id:
                return True
        return False

    def handle_collisions(self, particle):
        collided = self.detect_collision(particle.position)
        in_queue = self.is_in_queue(particle.id)
        if collided:
            if not in_queue:
                self.queue_particle(particle.id)
                self.note_on()
        else:
            if in_queue:
                self.dequeue_particle(particle.id)
                self.note_off()

    def note_on(self):
        self.playing = True
        if random.random() > 0.8:
            self.muted = False
            self.midi_out.send_message([0x90, self.note, 100])
        else:
            self.muted = True

    def note_off(self):
        # if self.playing and not self.muted:
        # self.midi_out.send_message([0x80, self.note, 100])
        self.playing = False
