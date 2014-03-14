from kivy.uix.stacklayout import StackLayout
from kivy.uix.togglebutton import ToggleButton
from kivy.uix.togglebutton import Button
from functools import partial

class ToolsPanel(StackLayout):

    btn_create_stream = ''
    btn_create_node = ''

    def __init__(self, **kwargs):
        super(ToolsPanel, self).__init__(**kwargs)

        self.medium = kwargs.get('medium', '')
        self.orientation = 'tb-lr'
        btn_size = "30px"

        self.btn_create_stream = ToggleButton(
            size=(btn_size, btn_size),
            size_hint=(None, None),
            background_normal='images/stream_up.png',
            background_down='images/stream_down.png',
            border=(0,0,0,0),
            group='tools',
            state='normal')

        self.btn_create_node = ToggleButton(
            size=(btn_size, btn_size),
            size_hint=(None, None),
            background_normal='images/node_up.png',
            background_down='images/node_down.png',
            border=(0,0,0,0),
            group='tools',
            state='normal')

        self.btn_create_link = ToggleButton(
            size=(btn_size, btn_size),
            size_hint=(None, None),
            background_normal='images/link_up.png',
            background_down='images/link_down.png',
            border=(0,0,0,0),
            group='tools',
            state='normal')

        self.btn_settings = Button(
            size=(btn_size, btn_size),
            size_hint=(None, None),
            background_normal='images/gear_up.png',
            background_down='images/gear_down.png',
            border=(0,0,0,0))

        # self.btn_multi_select = ToggleButton(
        #     size=(btn_size, btn_size),
        #     size_hint=(None, None),
        #     border=(0,0,0,0),
        #     group='tools',
        #     state='normal')

        self.add_widget(self.btn_create_stream)
        self.add_widget(self.btn_create_node)
        self.add_widget(self.btn_create_link)
        self.add_widget(self.btn_settings)
        # self.add_widget(self.btn_multi_select)

        self.spacing=(10, 10)
        self.padding=(10, 10)

        self.btn_create_stream.bind(on_release=partial(self.medium.on_btn_create_stream_released, self.btn_create_stream))
        self.btn_create_node.bind(on_release=partial(self.medium.on_btn_create_node_released, self.btn_create_node))
        self.btn_create_link.bind(on_release=partial(self.medium.on_btn_create_link_released, self.btn_create_link))
        self.btn_settings.bind(on_release=partial(self.medium.on_btn_settings_released, self.btn_settings))
        # self.btn_multi_select.bind(on_release=partial(self.medium.on_btn_multi_select_released, self.btn_multi_select))
