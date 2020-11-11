# deploy

## Deploy / Update Site
```bash
# set server
SERVER_IP=

# set site.name / domain - located on the server in /var/www
# must match sites/config/site.name.sh
# must match sites/env/site.name.env
SITE=

# set repository branch name
BRANCH=

# deploy updates
. src/deploy.sh
```

#### Example
```bash
SERVER_IP=123.44.55.678
SITE=www.makehappen.dev
BRANCH=releases/0.4
. src/deploy.sh
```

### Get Server SSH KEY
```bash
SERVER_IP=
. src/server/get-ssh-key.sh
```
