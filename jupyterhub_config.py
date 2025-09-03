import subprocess
from jupyterhub.auth import Authenticator
from jupyterhub.spawner import LocalProcessSpawner
import requests

class MyLdapAuthenticator(Authenticator):
    def authenticate(self, handler, data):
        # return "admin"
        username = data['username']
        password = data['password']

        try:
            resp = requests.post(
                "http://10.40.20.81:8000/auth",
                json={"uid": username, "password": password},
                timeout=5
            )
            # Auth API resp: 200, body={"status":"success","uid":"f3030137"}
            self.log.info(f"Auth API resp: {resp.status_code}, body={resp.text}") 
            if resp.status_code == 200:
                return "admin"
                # return username
            else:
                return None
        except Exception as e:
            self.log.error(f"Auth API error: {e}")
            return None
        
c = get_config()

# MyLdapAuthenticator
c.JupyterHub.authenticator_class = MyLdapAuthenticator
c.Authenticator.allow_all = True

# LocalProcessSpawner
c.JupyterHub.spawner_class = LocalProcessSpawner

c.Spawner.cmd = ['jupyterhub-singleuser']
c.Spawner.default_url = '/lab'
c.LocalProcessSpawner.notebook_dir = 'Desktop/ROOT_HOME/'

# bind every interface
c.ConfigurableHTTPProxy.command = '/usr/local/bin/configurable-http-proxy' # set an absolute path to fix error when using crontab
c.JupyterHub.bind_url = 'http://0.0.0.0:8000'

# cookies
c.JupyterHub.cookie_max_age_days = 2/24

# to run jupyter hub, you can use "jupyterhub -f $HOME/Desktop/jupyterhub_config.py"
