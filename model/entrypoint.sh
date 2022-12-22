#!/bin/bash

# The first commandline argument contains the folder which shall have the outputs
MODEL_NAME=${1}
MODEL_FOLDER=${2}
RESULTS_FOLDER=${3:-/workdir}
mkdir -p ${RESULTS_FOLDER}

# Import the Capella project into the workspace and export the model as HTML
xvfb-run -s "-screen 0 1280x720x24" \
capella -nosplash -consoleLog \
-application org.polarsys.capella.core.commandline.core \
-appid org.polarsys.kitalpha.doc.gen.business.capella.commandline \
-data /tmp/capella-workspace \
-import "${MODEL_FOLDER}" \
-input "/${MODEL_NAME}/${MODEL_NAME}.aird" \
-outputfolder "/${MODEL_NAME}/html_export" \
-logfile "${RESULTS_FOLDER}/log.html" \
-forceoutputfoldercreation

sleep 5

# Also perform the model validation here
xvfb-run -s "-screen 0 1280x720x24" \
capella -nosplash -consoleLog \
-application org.polarsys.capella.core.commandline.core \
-appid org.polarsys.capella.core.validation.commandline \
-data /tmp/capella-workspace \
-input "/${MODEL_NAME}/${MODEL_NAME}.aird" \
-outputfolder "/${MODEL_NAME}/validation" \
-logfile "${RESULTS_FOLDER}/log.html" \
-forceoutputfoldercreation

# Copy the HTML output and the validation results to the ${RESULTS_FOLDER}/ that
# is mapped as a volume to this container
mv "${MODEL_FOLDER}/html_export" ${RESULTS_FOLDER}/html_export
mv "${MODEL_FOLDER}/validation" ${RESULTS_FOLDER}/validation

# Create index.html from stub
sed "s/model-name-to-replace/${MODEL_NAME}/g" ${MODEL_FOLDER}/../index_stub.html > ${RESULTS_FOLDER}/index.html
