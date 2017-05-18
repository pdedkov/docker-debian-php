#!/bin/bash

docker run -it --rm -v $(pwd):/app pdedkov/php-cli "$@"
