import sqlite3
from Node import Node
from kivy.logger import Logger

class Store():
	def __init__(self, **kwargs):
		self.db = sqlite3.connect('example.db')
		self.cursor = self.db.cursor()

		self.create_db()

	def create_db(self):
		# self.cursor.execute('''CREATE TABLE nodes (id string primary key, x integer, y integer)''')
		pass

	def insert_node(self, node):
		id = node.id
		position = node.pos
		self.cursor.execute("""INSERT INTO nodes VALUES (?, ?, ?);""", (str(id), position[0], position[1]))
		self.db.commit()

	def select_nodes(self, midi_out):
		nodes = []
		for row in self.cursor.execute("""SELECT * FROM nodes"""):
			node = Node(midi_out=midi_out, do_rotation=False, do_scale=False)
			node.pos = (row[1], row[2])
			node.id = row[0]
			nodes.append(node)
		return nodes

	def update_node(self, node):
		id = str(node.id)
		x = node.pos[0]
		y = node.pos[1]
		Logger.debug("Updating node " + str(id) + " position:" + str(x) + " " + str(y))
		self.cursor.execute("""UPDATE nodes SET x = ?, y = ? WHERE id = ?""", (x, y, id))
		self.db.commit()