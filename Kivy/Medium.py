from Stream import Stream
from Node import Node
from kivy.clock import Clock
from rtmidi_python import MidiOut
from kivy.core.window import Window
from kivy.uix.widget import Widget
from random import randint
from kivy.graphics import Line, Color
from kivy.logger import Logger
from MultiSelectRect import MultiSelectRect
from NodeSettings import NodeSettings
from MainSettings import MainSettings
from Store import Store
import thread

class Medium(Widget):

    streams = []
    nodes = []
    selected_nodes = []
    selected_tool = ''
    show_grid = True
    play_status = True

    def __init__(self, **kwargs):
        super(Medium, self).__init__(**kwargs)

        self.store = Store()
        self.midi_out = MidiOut()

        # available_ports = self.midi_out.get_ports()
        # if available_ports:
        #     self.midi_out.open_port(0)
        # else:
        #     self.midi_out.open_virtual_port('QMidi')

        self.midi_out.open_port(0)

        self.register_event_type('on_ignore_touch')
        self.register_event_type('on_acknowledge_touch')
        self.register_event_type('on_mouse_state_changed')

        self.node_settings = NodeSettings()
        self.main_settings = MainSettings()

        thread.start_new_thread(self.schedule_calculate_collisions, ())
        # Clock.schedule_interval(self.calculate_collisions, 0)
        self.size = Window.size

        if self.show_grid:
            self.toggle_grid(True)

        self.nodes = self.store.select_nodes(self.midi_out)
        for elem in self.nodes:
            self.initialize_node(elem)

        Window.bind(on_resize=self.on_window_resize)

        self.multi_select_rect = MultiSelectRect()

    def schedule_calculate_collisions(self, *args):
        Clock.schedule_interval(self.calculate_collisions, 0)

    def initialize_node(self, node):
        self.add_widget(node)
        node.bind(on_node_selected=self.on_node_selected)
        node.bind(on_node_deselected=self.on_node_deselected)

    def calculate_collisions(self, extra):
        for stream in self.streams:
            for particle in stream.children:
                for node in self.nodes:
                    node.handle_collisions(particle)

    def create_node(self, position):
        node = Node(midi_out=self.midi_out, do_rotation=False, do_scale=False)
        self.nodes.append(node)
        self.initialize_node(node)
        node.pos = (position[0] - 15, position[1] - 15)
        Logger.debug('Node: ' + str(node.id))
        self.store.insert_node(node)

    def create_stream(self, position):
        stream = Stream(color=randint(0, 3))
        self.streams.append(stream)
        self.add_widget(stream)
        self.bind(on_ignore_touch=stream.on_ignore_touch)
        self.bind(on_acknowledge_touch=stream.on_acknowledge_touch)
        self.bind(on_mouse_state_changed=stream.on_mouse_state_changed)
        stream.head_position = (position[0], position[1])
        stream.active = True
        stream.ignore_touch = False

    def toggle_grid(self, visible):
        with self.canvas:
            if visible:
                Color(0.15, 0.15, 0.15)
                x = 50
                while x < self.width:
                    width = 1.5 if (x % 200 == 0) else 1
                    Line(points=[x, 0, x, self.height], width=width)
                    x += 50
                y = 50
                while y < self.height:
                    width = 1.5 if (y % 200 == 0) else 1
                    Line(points=[0, y, self.width, y], width=width)
                    y += 50
                Color(None)
            else:
                self.canvas.clear()

    def clear(self):
        self.clear_widgets()
        self.nodes = []
        self.streams = []
        self.selected_nodes = []

    # Inbound events -------------------------------------------

    def on_window_resize(self, *args):
        self.size = Window.size
        if self.show_grid:
            Logger.debug('Removing Widgets: ' + str(self.children))
            for node in self.nodes:
                self.remove_widget(node)
            for stream in self.streams:
                self.remove_widget(stream)

            Logger.debug('Toggle grid')
            self.toggle_grid(False)
            self.toggle_grid(True)

            Logger.debug('Adding widgets: ' + str(self.children))
            for node in self.nodes:
                self.add_widget(node)
            for stream in self.streams:
                self.add_widget(stream)

            Logger.debug('Added widgets: ' + str(self.children))

    def on_node_selected(self, obj):
        self.dispatch('on_ignore_touch')
        self.selected_nodes.append(obj.id)
        Logger.debug('Selected nodes: ' + str(self.selected_nodes))

    def on_node_deselected(self, obj):
        if obj.id in self.selected_nodes:
            self.selected_nodes.remove(obj.id)

    def on_touch_down(self, touch):
        if touch.is_double_tap:
            for node in self.nodes:
                if node.collide_point(touch.x, touch.y):
                    self.node_settings.show(node)
        else:
            if self.selected_tool == 'node':
                collided = False
                for node in self.nodes:
                    if node.collide_point(touch.x, touch.y):
                        collided = True
                        break
                if not collided:
                    self.create_node((touch.x, touch.y))
            elif self.selected_tool == 'stream':
                self.create_stream((touch.x, touch.y))
            elif self.selected_tool == 'multi':
                self.multi_select_rect.pos = (touch.x, touch.y)

            for item in self.children:
                item.on_touch_down(touch)

    def on_touch_up(self, touch):
        for item in self.children:
            if item.collide_point(touch.x, touch.y):
                if item.position_changed:
                    self.store.update_node(item)
                    item.on_touch_up(touch)

        if self.selected_tool == 'stream':
            self.dispatch('on_ignore_touch')
            self.dispatch('on_mouse_state_changed', 'up')

    def on_touch_move(self, touch):
        for item in self.children:
            item.on_touch_move(touch)
        pass

    def on_btn_create_stream_released(self, *args):
        state = args[1].state
        self.selected_tool = None
        if (state == 'down'):
            self.selected_tool = 'stream'
        self.dispatch('on_ignore_touch')

    def on_btn_create_node_released(self, *args):
        state = args[1].state
        self.selected_tool = None
        if (state == 'down'):
            self.selected_tool = 'node'
        self.dispatch('on_ignore_touch')

    def on_btn_create_link_released(self, *args):
        state = args[1].state
        self.selected_tool = None
        if (state == 'down'):
            self.selected_tool = 'link'
        self.dispatch('on_ignore_touch')

    def on_btn_settings_released(self, *args):
        Logger.debug("Streams: " + str(self.streams))
        self.main_settings.show(self.streams)
        pass

    def toggle_play_status(self, *args):
        self.play_status = not self.play_status
        Logger.debug('Setting streams active to: ' + str(self.play_status))
        for stream in self.streams:
            stream.active = self.play_status

    # Outbound events -------------------------------------------

    def on_ignore_touch(self, *args):
        pass

    def on_acknowledge_touch(self, *args):
        pass

    def on_mouse_state_changed(self, *args):
        pass