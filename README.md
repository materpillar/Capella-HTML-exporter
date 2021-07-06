# Capella model HTML exporter

A container image that allows automated exports of Capella models to HTML. The
image can be used for other commandline operations with Capella.

It is especially useful when integrating it into a CI that is connected to the
Git repository where you store your Capella model.

## Build

```bash
docker build -t capella-html-exporter .
```

## Use

By default, the container starts in the `/workdir` folder and executes
`./entrypoint.sh` at startup.

Map the folder where your model and your `entrypoint.sh` is located into the
`/workdir` folder of the container when running the image:

📦Capella-HTML-exporter
 ┗ 📂workdir
 ┃ ┣ 📂In-Flight Entertainment System
 ┃ ┃ ┣ 📜.project
 ┃ ┃ ┣ 📜In-Flight Entertainment System.afm
 ┃ ┃ ┣ 📜In-Flight Entertainment System.aird
 ┃ ┃ ┗ 📜In-Flight Entertainment System.capella
 ┃ ┗ 📜entrypoint.sh


```bash
docker run --init -v `pwd`/workdir:/workdir capella-html-exporter
```

### Entrypoint.sh

You must run eclipse in a virtual framebuffer as it requires a X server.
`Xvfb` is included in the docker image.

The first step needs to import your project into the Capella workspace.  
Note: It seems that Capella 1.4.2 and 5.0.0 have a bug in the
`org.polarsys.kitalpha.doc.gen.business.capella.commandline` function that does
not allow to use the `import` flag in there. Therefore, we use the `validation` app
first to import the project into the Capella workspace.

The `entrypoint.sh` could look like this:

```bash
# Import the project into the workspace and validate it
xvfb-run -s "-screen 0 1280x720x24" \
capella -nosplash -consoleLog \
-application org.polarsys.capella.core.commandline.core \
-appid org.polarsys.capella.core.validation.commandline \
-data /workspace \
-import "/workdir/In-Flight Entertainment System" \
-input "/In-Flight Entertainment System/In-Flight Entertainment System.aird" \
-outputfolder "/In-Flight Entertainment System/validation" \
-logfile /workdir/log.html \
-forceoutputfoldercreation

# Export the model as HTML
# Note: It seems that Capella has a bug in this function that does not allow
# to use the import flag here.
xvfb-run -s "-screen 0 1280x720x24" \
capella -nosplash -consoleLog \
-application org.polarsys.capella.core.commandline.core \
-appid org.polarsys.kitalpha.doc.gen.business.capella.commandline \
-data /workspace \
-filepath "/In-Flight Entertainment System/In-Flight Entertainment System.aird" \
-outputfolder "/In-Flight Entertainment System/html_export" \
-logfile /workdir/log.html \
-forceoutputfoldercreation
```

