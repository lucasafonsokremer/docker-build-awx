Created by Lucas Afonso Kremer

https://www.linkedin.com/in/lucasafonsokremer

Requirements
------------

* Docker already installed and running

Dockerfile informations
-----------------------

* The Dockerfile creates a AWX image with one virtual environment properly configured

* Inside the folder Dockerfile_requirements you will see an variables file with specific versions of libs for this Virtual Environment.

* You must preserve the libs file standard name. Ex.: "awx15.0.0_ansible2.11"

* After replace this image on your environment, you must add the new virtual environment path on the AWX CLI:

```
## Access:
Settings >> System

## On "Custom Virtual Environment Paths:
/opt/custom_venv

## Click Save 
```

AWX Doc
-------

```
https://github.com/ansible/awx/blob/14.1.0/docs/custom_virtualenvs.md
```
