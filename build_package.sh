#!/bin/bash

python -m build --sdist --wheel ./
cd dist
unzip *.whl
cd ..

