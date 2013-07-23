from kivy.uix.gridlayout import GridLayout
from kivy.uix.scrollview import ScrollView
from kivy.uix.slider import Slider
from kivy.core.window import Window
from kivy.logger import Logger

class ControlPanel(GridLayout):

    status = 'hidden'
    slider_particle_count = ''

    def __init__(self, **kwargs):
        super(ControlPanel, self).__init__(**kwargs)

        self._width = 200
        self._height = 400

        self.medium = kwargs.get('medium', '')

        self.cols = 1
        scroll_view1 = ScrollView(size_hint=(None, None), size=(self._width, self._height/2))
        scroll_view2 = ScrollView(size_hint=(None, None), size=(self._width, self._height/2))
        content1 = GridLayout(cols=1, spacing=0, size_hint_y=None)
        content2 = GridLayout(cols=1, spacing=0, size_hint_y=None)

        content1.bind(minimum_height=content1.setter('height'))
        content2.bind(minimum_height=content2.setter('height'))

        # for i in range(7):
        #     # btn = Button(text=str(i), size_hint_y=None, height=40)
        #     # content1.add_widget(btn)
        #     btn = Button(text=str(i), size_hint_y=None, height=40)
        #     content2.add_widget(btn)

        self.slider = Slider(min=1, max=5, value=5, step=1)
        self.slider.bind(value=self.medium.on_slider_change)
        content1.add_widget(self.slider);

        
        scroll_view1.add_widget(content1)
        scroll_view2.add_widget(content2)
        self.add_widget(scroll_view1)
        self.add_widget(scroll_view2)
        self.size = (self._width, self._height)

        self.pos = (Window.width - self._width, 0)
        Window.bind(on_resize=self.on_window_resize)

    # Inbound events -------------------------------------------

    def on_window_resize(self, *args):
        Logger.debug("Window resized. Updating control panel's position")
        self.pos = (args[1] - self._width, 0)
        # self.pos = (1000, 0)

    def on_node_created(self, *args):
        Logger.debug("Node created: Update control panel.")
        # checkbox = CheckBox()
        # checkbox.node_id = args[1]  # Node ID
        # self.add_widget(checkbox)
        # 
