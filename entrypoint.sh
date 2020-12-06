#!/bin/bash

# The first commandline argument contains the folder which shall have the
# outputs of the export.
results_folder=${1:-/workdir}
mkdir -p ${results_folder}

# Unpack the example project that is delivered with Capella
pushd /opt/capella/samples
unzip IFE_samplemodel.zip
popd

# Import the project into the workspace and validate it
xvfb-run -s "-screen 0 1280x720x24" \
eclipse -nosplash -consoleLog \
-application org.polarsys.capella.core.commandline.core \
-appid org.polarsys.capella.core.validation.commandline \
-data /capella-workspace \
-import "/opt/capella/samples/In-Flight Entertainment System" \
-input "/In-Flight Entertainment System/In-Flight Entertainment System.aird" \
-outputfolder "/In-Flight Entertainment System/validation" \
-logfile ${results_folder}/log.html \
-forceoutputfoldercreation

# Export the model as HTML
# Note: It seems that Capella has a bug in this function that does not allow
# to use the import flag here.
xvfb-run -s "-screen 0 1280x720x24" \
eclipse -nosplash -consoleLog \
-application org.polarsys.capella.core.commandline.core \
-appid org.polarsys.kitalpha.doc.gen.business.capella.commandline \
-data /capella-workspace \
-filepath "/In-Flight Entertainment System/In-Flight Entertainment System.aird" \
-outputfolder "/In-Flight Entertainment System/html_export" \
-logfile ${results_folder}/log.html \
-forceoutputfoldercreation

# Copy the validation and html output to the ${results_folder}/ that is mapped as a volume
cp -r "/opt/capella/samples/In-Flight Entertainment System/html_export" ${results_folder}/html_export
cp -r "/opt/capella/samples/In-Flight Entertainment System/validation" ${results_folder}/validation

# Create index.html from stub
sed 's/model-name-to-replace/In-Flight Entertainment System/g' index_stub.html > ${results_folder}/index.html
