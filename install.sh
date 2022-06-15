#!/bin/bash

ROOT_DIR=`dirname "$0"`

function install {
    echo "Installing $1..."
    cd $ROOT_DIR/$1
    bash "install.sh"
    cd $ROOT_DIR
    echo "Installed $1"
}

install "nvim"
