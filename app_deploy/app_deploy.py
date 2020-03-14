#!/usr/bin/env python3.7
# -*- coding: utf-8 -*-
"""

- Contributors
Elliann Marks <elian.markes@gmail.com>

**- Version 1.0 - 13/03/2020**

"""

# libraries
from flask import Flask, request
from module_ansible import ModuleAnsible
from module_log import ModuleLog
import os

# instance flask and active debug
app = Flask(__name__)
app.config["DEBUG"] = True

# instance ModuleLog
module_log = ModuleLog()

@app.route("/app_deploy", methods=["POST"])
def app_deploy():
    # check if key header exists
    if request.headers.get("Key-Deploy") is not None and \
        request.headers.get("Application-Deploy") is not None and \
        request.headers.get("Server-Deploy") is not None and \
        request.headers.get("Key-Deploy") == os.environ.get("KEYDEPLOY"):
        module_ansible = ModuleAnsible(module_log.log)
        flag_rollback = os.environ.get("PWD") + "flags/rollback"
        if os.path.exists(flag_rollback):
            os.remove(flag_rollback)
        extra_vars = dict(app_name=request.headers.get("Application-Deploy"))
        server_ip = request.headers.get("Server-Deploy")
        summary_ansible = module_ansible.execute(extra_vars, server_ip)
        if summary_ansible is False and \
            os.path.exists(flag_rollback):
            return "Deploy failed, rollback executed."
        elif summary_ansible is False:
            return "Deploy failed."
        else:
            return "Deploy completed."

    else:
        return "Invalid headers."

if __name__ == '__main__':
    app.run()
