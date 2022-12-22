# Capella model HTML exporter

A container image that allows automated exports of Capella models to HTML. The
image can also be used for other command line operations with Capella.

It is especially useful when integrating it into a CI that is connected to the
Git repository where you store your Capella model.

## Usage

By default, the container starts in the `/workdir` folder and executes
`./entrypoint.sh` at startup. This `entrypoint.sh` file must contain all the
commands that are executed inside the container.

Capella must be run in a virtual framebuffer as it requires a X server. `Xvfb`
is included in the docker image for this purpose.

Clone this repository, change into the repository workspace and build the
Container

```bash
docker build -t capella-html-exporter .
```

Map the folder where your model (in a subfolder) and your customized
`entrypoint.sh` is located into the `/workdir` folder inside the container when
running the image:

```bash
docker run -v `pwd`/model:/workdir capella-html-exporter
```

## Github Actions

This repository contains a Github action that can be used for models stored in
Github repositories.

You can use the action in your own worflow:

```
    - name: Automate Capella HTML export
      uses: materpillar/capella-html-exporter@v6
      with:
        entrypoint: model/entrypoint.sh
        model-name: capella-automations
        path-model-folder: model/capella-automations
```

This assumes the following folder strucutre of your model repository:  
(Note that the `.gitignore`, `index_stub.html` and `README.md` are just exemplary)

```
📂 model-repo
┣ 📂 capella-automations
┃ ┣ 📜.project
┃ ┣ 📜capella-automations.afm
┃ ┣ 📜capella-automations.aird
┃ ┗ 📜capella-automations.capella
┣ 📜entrypoint.sh
┣ 📜.gitignore
┣ 📜index_stub.html
┗ 📜README.md
```

See the provided `entrypoint.sh` in the `model` subfolder for an example.
