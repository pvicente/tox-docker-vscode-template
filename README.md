# Template for developing inside a docker container with VSCode and a tox based project

With the new [**remote development feature for VSCode**](https://code.visualstudio.com/blogs/2019/05/02/remote-development) you can create and spin up a complete development environment in a matter of seconds and start coding without any other setup in your machine. See info about [**developing inside a container**](https://code.visualstudio.com/docs/remote/containers).

If your IDE for python project is **VSCode** and your project is using tox this template project could help you to get a development environment ready for coding in a few seconds.

It setups a development container (based on **Ubuntu 18.04**) with the essential tools to run your **CI environments** inside the container with **VSCode**. A development environment is set up to work in **VSCode** to run/debug your code and tests. You can also run other CI environments and use them inside VSCode.

This setup works with [tox](https://github.com/tox-dev/tox) project cloned in the parent folder (**../tox** relative to this project) but it can be a template for any project using **tox for CI** or to create a **development environment**.

## Use cases:

- If your host machine is **MacOSX/Windows** but you needs to develop a feature for **Linux** and you don't have it up and running.
- If you need to investigate a problem in **Linux CI** and you need a specific version of python to debug it and you don't want to install it in your host machine.
- A standarised development environment for your team based on **VSCode** and **tox**.

## Requirements:

- [Docker](https://docs.docker.com/install/#supported-platforms)
- [Visual Studio Code Insiders v1.34.0](https://code.visualstudio.com/insiders/)
- [Remote Development Extension for VScode](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack)

After the extension is installed press F1 (Command Palette) ">Reload Window", VScode will prompt a message "Reopen Folder in Container" and it will build and set up the container in a matter of seconds. For more information see [remote container extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

> Note: First time it needs to build everything from scratch and it takes a few minutes (no more than 5 minutes in this example because it's setting up a bunch of python interpreters). The next time that you open this project again the setup will happen faster because the image is cached and your development environment will be up and running in seconds.

## Configuration files (inside .devcontainer folder)

- [Dockerfile](/Dockerfile) based on ubuntu:18.04 with python versions from [deadsnakes](https://github.com/deadsnakes). It's creating a non root user (**devuser**) and install [create_dev_env.bash](/create_dev_env.bash) which is used to create the development environment.

- [Docker-Compose](/docker-compose.yml) to mount your workspace with the source code of your project. Declared [.env file](/.env) by default **../tox**.

- [.devcontainer.json](/.devcontainer.json) with extensions needed for VSCode in the container and some configuration to work with Docker/Docker-compose.

- [settings.vscode.json](/settings.vscode.json) settings for vscode in remote container to use the development environment and configure python interpreters inside container.

See [devcontainer json file](https://code.visualstudio.com/docs/remote/containers#_creating-a-devcontainerjson-file) to get more information about this setup or [container advanced](https://code.visualstudio.com/docs/remote/containers-advanced) if you need a diferent setup.


## Actions you can do for now

- Run all CI environments available in tox in the vscode terminal.
  >Note: pypy is skipped at the moment not tested in CI for tox project.

- Run/Debug tests inside VS Code with any python virtual environment created by tox. By default **dev** environment is enabled, but you can choose **py27, py36, docs ...** if you've created them in the terminal.
  >Note: if you don't see them after create >Reload Window and they should be available at the bottom of your screen.

- Code linting (flake8) and formatting (black) using project configuration inside VS Code.

- See coverage inside code.
   
- Install more extensions inside container, like [Live Share](https://visualstudio.microsoft.com/services/live-share/).

## Notes

- Your tox project is mounted at **/workspace** inside the container. By default is using **../tox** in your host machine. Path can be changed with [.env file](/.env) through **TOX_PROJECT_DIR**

- If your host machine is **Linux** you'll probably hit some permissions problems with your workspace. See [.env file](/.env) and set UID with the id of your host user.

- Tox environments are generated inside the container **~/.tox** so they are installed and running faster not polluting the **.tox** folder in your workspace.

- Run **pytest in parallel inside VSCode** (**disabled by default**) is not compatible with debugging. If you want to enable it see commented [settings.vscode.json](/settings.vscode.json).

## VSCode extensions installed in container
- [ms-python.python](https://marketplace.visualstudio.com/items?itemName=ms-python.python)
- [eamodio.gitlens](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens)
- [bungcip.better-toml](https://marketplace.visualstudio.com/items?itemName=bungcip.better-toml)
- [ryanluker.vscode-coverage-gutters](https://marketplace.visualstudio.com/items?itemName=ryanluker.vscode-coverage-gutters)
- [mutantdino.resourcemonitor](https://marketplace.visualstudio.com/items?itemName=mutantdino.resourcemonitor),

