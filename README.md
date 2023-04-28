# Capella model HTML exporter

A container image and Github Actions that automates the export of Capella models
to HTML. The image can also be used for other command line operations with
Capella.

It is especially useful when integrating it into a CI that is connected to the
Git repository where you store your Capella model.

## Use the capella-html-exporter container

By default, the container starts in the `/workdir` folder and executes
`./entrypoint.sh` at startup. This `entrypoint.sh` file must contain all the
commands that are executed inside the container.

To build the image execute:

```bash
docker build -t capella-html-exporter .
```

To export a model to HTML using the image, mount the folder that contains your
model subfolder and your customized `entrypoint.sh` into the `/workdir` folder
inside the container. So if your folder structure looks like this:

```
📂 /some/path/
┗ 📂 model-git-repository/
   ┣ 📂 .git/
   ┣ 📂 capella-automations/
   ┃ ┣ 📜.project
   ┃ ┣ 📜capella-automations.afm
   ┃ ┣ 📜capella-automations.aird
   ┃ ┗ 📜capella-automations.capella
   ┗ 📜entrypoint.sh
```

you should mount the `model-git-repository` folder to `/workdir` inside the container.

You need to pass the name of the `.aird` file as a parameter:

```bash
docker run --rm -v /some/path/model-git-repository:/workdir capella-html-exporter capella-automations
```

If the file is located in a folder with a different name, also pass the path to this folder as a second argument. Imagine the following folder structure:
```
📂 /some/path/
┗ 📂 model-git-repository/
   ┣ 📂 .git/
   ┣ 📂 model-in-capella/
   ┃  ┣ 📜.project
   ┃  ┣ 📜capella-automations.afm
   ┃  ┣ 📜capella-automations.aird
   ┃  ┗ 📜capella-automations.capella
   ┗ 📜entrypoint.sh
```
the command is: `docker run --rm -v /some/path/model-git-repository:/workdir capella-html-exporter capella-automations model-in-capella`

> This repository contains a model and `entrypoint.sh` inside the `model` folder.
  So for this repository the command is:  
  `docker run --rm -v `pwd`/model:/workdir capella-html-exporter capella-automations`

## Github Actions

This repository contains a Github action that can be used for models stored in
Github repositories.

You can use the action in your own worflow:

```
    - name: Automate Capella HTML export
      uses: materpillar/capella-html-exporter@v6.1.0
      with:
        model-name: capella-automations
```

Github Actions changes the workdir inside the container to `/github/workspace/`
and the repository will automatically be checked out there.

The action passes 3 parameters to `entrypoint.sh` as arguments:
1. `model-name`: The name of the model as in `<model-name>.aird`
2. `path-model-folder` *optional*: The folder in which the `.aird` file is
   stored. Capella by default stored the `.aird` file in a folder with the same
   name. Therefore this parameter is optional and defaults to the name of the
   `.aird` file. Adjust, if the model is located in a different subfolder.
3. `output-folder` *optional*: The folder where the outputs of HTML export and validation
   shall be stored as an absolute path. This is by default `/github/workspace/artifacts`.

The `entrypoint.sh` is by default exptected to be in the root folder of the repository. If this is
not the case in your repository, you can manually set the relative path to your
`entrypoint.sh`:

```
    - name: Automate Capella HTML export
      uses: materpillar/capella-html-exporter@v6.1.0
      with:
        model-name: capella-automations
        path-model-folder: model/capella-automations
        entrypoint: model/entrypoint.sh
```

See the provided `entrypoint.sh` in the `model` subfolder for an example on what
the `entrypoint.sh` for your own repo should look like to use this action.
