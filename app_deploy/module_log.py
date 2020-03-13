#!/usr/bin/env python3.7
# -*- coding: utf-8 -*-
"""

- Contributors
Elliann Marks <elian.markes@gmail.com>

**- Version 1.0 - 13/03/2020**

"""

# libraries
import logging
from contextlib import closing
from datetime import datetime


class ModuleLog:

	def __init__(self):
		try:
			# configuration logging
			self.log_format = "%(asctime)s - %(name)s - %(levelname)s - %(message)s"
			self.log_file = None
			self.log_handler = None
			self.log_level = None
			self.log = None
			self.log_formatter = None
			# check type daemon
			self.log_file = "app_deploy_" + str(datetime.now().strftime('%d_%m_%Y')) + ".log"
			# get log level
			self.log_level = logging.INFO
			#configuration log
			self.log = logging.getLogger(__name__)
			self.log.setLevel(self.log_level)
			with closing(logging.FileHandler(self.log_file)) as self.log_handler:
				self.log_handler.setLevel(self.log_level)
				self.log_formatter = logging.Formatter(self.log_format)
				self.log_handler.setFormatter(self.log_formatter)
				self.log.addHandler(self.log_handler)

		except Exception as er:
			print("{} - {}".format(self.__class__.__name__, er))
			raise Exception("Error in instance ModuleLog")
