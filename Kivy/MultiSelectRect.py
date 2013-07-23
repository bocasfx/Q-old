from kivy.uix.widget import Widget
from kivy.graphics import Color, Quad


class MultiSelectRect(Widget):

    def __init__(self, **kwargs):
        super(MultiSelectRect, self).__init__(**kwargs)
        self.size = (0, 0)
        self.pos = kwargs.get('pos', (0, 0))

        self.bind(size=self.on_size_change)

    def on_size_change(self, *args):
        with self.canvas:
            Color(1, 1, 1)
            Quad(points=[self.pos[0], self.pos[1], self.pos[0] + self.width, self.pos[1] + self.height])
