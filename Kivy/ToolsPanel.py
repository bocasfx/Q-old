from kivy.uix.stacklayout import StackLayout
from kivy.uix.togglebutton import ToggleButton
from functools import partial

class ToolsPanel(StackLayout):

    btn_create_stream = ''
    btn_create_node = ''

    def __init__(self, **kwargs):
        super(ToolsPanel, self).__init__(**kwargs)

        self.medium = kwargs.get('medium', '')
        self.orientation = 'tb-lr'
        btn_size = 0.05

        self.btn_create_stream = ToggleButton(
            size_hint=(btn_size, btn_size),
            text='S',
            group='tools',
            state='normal')

        self.btn_create_node = ToggleButton(
            size_hint=(btn_size, btn_size),
            text='N',
            group='tools',
            state='normal')

        self.btn_multi_select = ToggleButton(
            size_hint=(btn_size, btn_size),
            text='M',
            group='tools',
            state='normal')

        self.add_widget(self.btn_create_stream)
        self.add_widget(self.btn_create_node)
        self.add_widget(self.btn_multi_select)

        self.btn_create_stream.bind(on_release=partial(self.medium.on_btn_create_stream_released, self.btn_create_stream))
        self.btn_create_node.bind(on_release=partial(self.medium.on_btn_create_node_released, self.btn_create_node))
        self.btn_multi_select.bind(on_release=partial(self.medium.on_btn_multi_select_released, self.btn_multi_select))
