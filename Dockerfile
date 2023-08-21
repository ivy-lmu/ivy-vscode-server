FROM gitpod/openvscode-server:latest

ENV OPENVSCODE_SERVER_ROOT="/home/.openvscode-server"
ENV OPENVSCODE="${OPENVSCODE_SERVER_ROOT}/bin/openvscode-server"
ENV JENKINS_PREFIX="https://jenkins.ivyteam.io/job/vscode-extensions/job/master/lastSuccessfulBuild/artifact/vscode-extensions/"

SHELL ["/bin/bash", "-c"]
RUN \
    urls=(\
        ${JENKINS_PREFIX}config-editor/extension/vscode-config-editor-extension-11.2.0.vsix \
        ${JENKINS_PREFIX}inscription/extension/vscode-inscription-extension-11.2.0.vsix \
        ${JENKINS_PREFIX}process-editor/extension/vscode-process-editor-extension-11.2.0.vsix \
        ${JENKINS_PREFIX}project-explorer/extension/vscode-project-explorer-extension-11.2.0.vsix \
        ${JENKINS_PREFIX}engine/extension/vscode-engine-extension-11.2.0.vsix \
    )\
    && tdir=/tmp/exts && mkdir -p "${tdir}" && cd "${tdir}" \
    && wget "${urls[@]}" && \
    exts=("${tdir}"/*)\
    && for ext in "${exts[@]}"; do ${OPENVSCODE} --install-extension "${ext}"; done && \
    rm -rf "${tdir}"

USER root
RUN wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | tee /usr/share/keyrings/adoptium.asc && \
    echo "deb [signed-by=/usr/share/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list && \
    apt-get update && apt-get install -y temurin-17-jdk && \
    apt-get purge -y wget && \
    apt-get clean
USER openvscode-server
