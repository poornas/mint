#!/bin/bash
#
#  Mint (C) 2017 Minio, Inc.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#

# install java dependencies.
install() {
    # these packages are required to install dotnetcore below
    apt-get install -y dirmngr apt-transport-https

# dotnetcore install commands
    sh -c 'echo "deb [arch=amd64] https://apt-mo.trafficmanager.net/repos/dotnet-release/ xenial main" > /etc/apt/sources.list.d/dotnetdev.list'
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 417A0893
    apt-get update
    apt-get install -y dotnet-dev-1.0.4 nuget
}

installPkgs() {
    ## Execute all scripts present in dotnet/* other than `install.sh`
    for i in $(echo /mint/build/dotnet/*.sh | tr ' ' '\n' | grep -v install.sh); do
        $i
    done
}

# remove dotnet dependencies.
cleanup() {
    #TODO - build .exe so dependencies can be cleaned up.
}

main() {
    install

    installPkgs

    cleanup
}

main

