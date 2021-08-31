#!/bin/bash
echo "Generating $1"

wp i18n make-pot . $1
