# Laravel zero downtime deployment

## Quick guide

Copy the contents of this repo to the vhost root folder.<br/>
Edit `deploy.sh` and change the following:<br/>

```
GIT_REMOTE_URL = The url to your repo (ssh://github.com/awesome-project/repo.git)
BASE_DIR = The vhost root folder location (/home/laravel/domains/awesome-project.io)
```

Copy your `.env` to `{root-folder}/shared/`.<br/>
Copy the `storage` folder to `{root-folder}/shared/`.

Make sure the apache/nginx vhost folder is pointing to: `{root-folder}/www/public`<br/>

## Running the deployment

Make a new tag in your repo to deploy, for example: v1.0.0<br/>
Than run the deployment:<br/>

```
./deplosh.sh v1.0.0
```

## Rollback

If a release with a given tag already exists in the releases folder.<br/>
The deployment will be rolled back to the given tag.<br/>
In this case only the Laravel cache will be cleared.<br/>

# Alternatives

**Laravel Envoyer**<br/>
https://envoyer.io/

**Deployer**<br/>
https://github.com/lorisleiva/laravel-deployer