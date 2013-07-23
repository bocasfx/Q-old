from collections import deque
import Static
import Particle
import logging
import random
# import pygame

log = logging.getLogger(__name__)


class Worm:

    queue = []
    position = (0, 0)
    easing = (0, 0)
    path = []
    leader = ""
    path_index = 0
    worm_size = 0
    worm_step = 0
    particle_count = 0
    particles = []
    colour_index = 0
    
    def __init__(self, worm_size, particle_count, id):
        self.particles = []
        self.colour_index = random.randint(0, 3)
        self.particle_count = particle_count
        self.worm_size = worm_size
        self.worm_step = int(self.worm_size / self.particle_count)
        self.queue = deque([(0, 0)] * worm_size)
        self.leader = "mouse"
        for i in range(self.particle_count):
            self.particles.append(Particle.Particle(self.position, self.colour_index))

    def update_position(self, position):
        if self.leader == "mouse":
            self.position = position
            self.path.append(position)

    def update(self):
        if self.leader == "path":
            self.position = self.path[self.path_index]
            self.advance_path_index()
            
    def advance_path_index(self):
        self.path_index += 1
        if self.path_index >= len(self.path) - 1:
            self.path_index = 0

    def reset(self):
        self.path = []
        self.path_index = 0

    def erase(self, screen):

        i = 0
        for particle in self.particles:
            particle.erase(screen, self.queue[i])
            i += self.worm_step

    def draw(self, screen):
        self.queue.rotate(-1)
        self.easing = self.calculate_easing(self.position, self.easing, Static.Static.easing_factor)
        self.queue[self.worm_size - 1] = self.easing

        for node in Static.Static.nodes:
            i = 0
            for particle in self.particles:
                particle.update_position(self.queue[i])
                particle.draw(screen)
                node.handle_collisions(particle)
                i += self.worm_step

        # if len(self.path) > 1:
        #     pygame.draw.aalines(screen, (60, 60, 60), False, self.path)

    def calculate_easing(self, position, easing, easing_factor):
        # Calculate easing
        dx = position[0] - easing[0]
        easing = (easing[0] + (dx * easing_factor), easing[1])

        dy = position[1] - easing[1]
        easing = (easing[0], easing[1] + (dy * easing_factor))

        return easing
