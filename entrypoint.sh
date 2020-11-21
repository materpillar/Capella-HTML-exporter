#!/bin/bash

# Unpack the example project that is delivered with Capella
pushd /opt/capella/samples
unzip IFE_samplemodel.zip
popd

# Import the project into the workspace and validate it
xvfb-run -s "-screen 0 1280x720x24" \
eclipse -nosplash -consoleLog \
-application org.polarsys.capella.core.commandline.core \
-appid org.polarsys.capella.core.validation.commandline \
-data /workspace \
-import "/opt/capella/samples/In-Flight Entertainment System" \
-input "/In-Flight Entertainment System/In-Flight Entertainment System.aird" \
-outputfolder "/In-Flight Entertainment System/validation" \
-logfile /workdir/log.html \
-forceoutputfoldercreation

# Export the model as HTML
# Note: It seems that Capella has a bug in this function that does not allow
# to use the import flag here.
xvfb-run -s "-screen 0 1280x720x24" \
eclipse -nosplash -consoleLog \
-application org.polarsys.capella.core.commandline.core \
-appid org.polarsys.kitalpha.doc.gen.business.capella.commandline \
-data /workspace \
-filepath "/In-Flight Entertainment System/In-Flight Entertainment System.aird" \
-outputfolder "/In-Flight Entertainment System/html_export" \
-logfile /workdir/log.html \
-forceoutputfoldercreation

# Copy the validation and html output to the /workdir that is mapped as a volume
cp -r "/opt/capella/samples/In-Flight Entertainment System/html_export" /workdir/html_export
cp -r "/opt/capella/samples/In-Flight Entertainment System/validation" /workdir/validation

# Create index.html from stub
sed 's/model-name-to-replace/In-Flight Entertainment System/g' index_stub.html > /workdir/index.html
