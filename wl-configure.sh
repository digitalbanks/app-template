#!/bin/bash

# ------------------------------------------------------------------------------
# VARIABLES
# ------------------------------------------------------------------------------

WL_APP_NAME=app-template
WL_DIR_NAME=app-template
unset WL_THEME
unset WL_CONFIG

# ------------------------------------------------------------------------------
# PRINT HELP
# ------------------------------------------------------------------------------

help() {
	echo "Coming Soon..."
}

# ------------------------------------------------------------------------------
# PARSE ARGUMENTS
# ------------------------------------------------------------------------------

# If help (-h) found, print help and interrupt script
while getopts ':h:a:t:c:' arg; do
	case $arg in
		h) help && exit 0     ;;
		a) WL_CONFIG=$OPTARG  ;;
		t) WL_THEME=$OPTARG   ;;
		c) WL_CONFIG=$OPTARG  ;;
	esac
done

if [ "${WL_APP_NAME}" != "app-template" ]; then
	WL_DIR_NAME="app-${WL_APP_NAME}"
fi

# ------------------------------------------------------------------------------
# WRONG ARGUMENT ERRORS
# ------------------------------------------------------------------------------

# Missing mandatory parameters
if [ -z "$WL_THEME" ];   then echo ERROR: No theme provided;   exit 0; fi
if [ -z "$WL_CONFIG" ];  then echo ERROR: No config provided;   exit 0; fi

if [ ! -d "${WL_DIR_NAME}" ]; then
	echo "Directory ${WL_DIR_NAME} doesn't exists"
	exit 0
fi

# ------------------------------------------------------------------------------
# 1. GENERATE config/imageconfig
# ------------------------------------------------------------------------------

WL_THEME_FILE="./${WL_DIR_NAME}/src/config/imageConfig.js"

echo "> Generate ${WL_THEME_FILE}"
echo "const imageConfig = require('./${WL_CONFIG}/ImageConfig').default;"> $WL_THEME_FILE
echo "" >> $WL_THEME_FILE
echo "export default imageConfig;" >> $WL_THEME_FILE

# ------------------------------------------------------------------------------
# 2. GENERATE theme/index.js
# ------------------------------------------------------------------------------

# const styles = require('./theme').default;
#
# module.exports = fileName => styles[fileName] || {};
#

WL_THEME_FILE="./${WL_DIR_NAME}/src/config/index.js"

echo "> Generate ${WL_THEME_FILE}"

echo "const styles = require('./${WL_THEME}').default;"> $WL_THEME_FILE
echo "" >> $WL_THEME_FILE
echo "module.exports = fileName => styles[fileName] || {};" >> $WL_THEME_FILE

# ------------------------------------------------------------------------------
# 3. GENERATE theme/config
# ------------------------------------------------------------------------------

WL_THEME_FILE="./${WL_DIR_NAME}/src/config/config.js"

echo "> Generate ${WL_THEME_FILE}"
echo "const config = require('./${WL_CONFIG}/Config').default;"> $WL_THEME_FILE
echo "" >> $WL_THEME_FILE
echo "export default config;" >> $WL_THEME_FILE

# ------------------------------------------------------------------------------
# 4. GENERATE app.json
# ------------------------------------------------------------------------------

WL_THEME_FILE="./${WL_DIR_NAME}/app.json"

echo "> Generate ${WL_THEME_FILE}"

echo { '"expo"': { '"name"': "\"${WL_CONFIG}\"", '"slug"': "\"${WL_CONFIG}-template\"", '"version"': '"1.0.0"', '"orientation"': '"portrait"', '"icon"': "\"./src/config/${WL_CONFIG}/images/${WL_CONFIG}.icon.png\"", '"splash"': { '"image"': "\"./src/config/${WL_CONFIG}/images/${WL_CONFIG}.splash.png\"", '"resizeMode"': '"contain"', '"backgroundColor"': '"#ffffff"' }, '"updates"': { '"fallbackToCacheTimeout"': 0 }, '"assetBundlePatterns"': [ '"**/*"' ], '"ios"': { '"supportsTablet"': true }, '"android"': { '"adaptiveIcon"': { '"foregroundImage"': "\"./src/config/${WL_CONFIG}/images/${WL_CONFIG}.adaptive-icon.png\"", '"backgroundColor"': '"#FFFFFF"' } } } } > $WL_THEME_FILE
