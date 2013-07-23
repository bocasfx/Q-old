import logging
import pygame

log = logging.getLogger(__name__)


class Controller:

    environment = ""
    app = ""
    dragging = False
    mouse_state = "up"
    action = "path_edit"

    def __init__(self, app, environment, control_panel):
        self.environment = environment
        self.app = app
        self.control_panel = control_panel

    def restrict_position(self, position):

        new_position = position

        if position[0] > self.environment.canvas_width - 10:
             new_position = (self.environment.canvas_width - 10, new_position[1])

        if position[1] > self.environment.height - 10:
             new_position = (new_position[0], self.environment.height - 10)

        return new_position

    def handle_events(self):

        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                self.app.running = False

            elif event.type == pygame.KEYDOWN:
                if event.key == pygame.K_q:
                    self.app.running = False

            elif event.type == pygame.MOUSEMOTION:
                if self.mouse_state == "down":
                    if self.action == 'path_edit':
                        # Limit movement of worms to the size of the canvas.
                        position = self.restrict_position(event.pos)
                        # Mouse state is 'down' so we must be dragging.
                        self.dragging = True
                        self.environment.handle_mouse_motion_event(
                            position, self.dragging)

            elif event.type == pygame.MOUSEBUTTONDOWN:
                self.mouse_state = "down"
                if self.action == 'path_edit':
                    # Limit movement of worms to the size of the canvas.
                    position = self.restrict_position(event.pos)

                    self.environment.handle_mouse_down_event(
                        position)

            elif event.type == pygame.MOUSEBUTTONUP:
                self.mouse_state = "up"
                if self.action == 'path_edit':
                    self.environment.handle_mouse_up_event()
