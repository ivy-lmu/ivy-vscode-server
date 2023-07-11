based on https://github.com/gitpod-io/openvscode-server
`docker build -t axonivy/vscode-server .`
`docker run -it --init -p 3000:3000 -v "$(pwd)/vscode-workspace:/home/workspace:cached" axonivy/vscode-server`