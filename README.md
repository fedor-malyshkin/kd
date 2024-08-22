# README


## Requirements

* python3
* pip
* venv
* docker (https://docs.docker.com/desktop/mac/install/)
* java (for Plant UML, https://plantuml.com)


### Create + activate virtual environment

```sh
python -m venv venv
. venv/bin/activate
````

### Install dependencies

```sh
. venv/bin/activate
pip install -r requirements.txt
````

### Generated images
```shell
cd kartera-api-doc/puml
./convert.sh
```

### Generated site
```shell
. venv/bin/activate
cd kartera-api-doc
mkdocs build
```

### Generated live-reload server

Will be accessible at n http://127.0.0.1:8000/

```shell
. venv/bin/activate
cd kartera-api-doc
mkdocs serve
```