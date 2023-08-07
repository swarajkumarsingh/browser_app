#!/bin/zsh

set -e

declare -A STATIONS=(
  ["dev"]="dev"

  ["anuppur"]="anuppur"
  ["dhar"]="dhar"
  ["mandsaur"]="mandsaur"
  ["meerut"]="meerut"
  ["moradabad"]="moradabad"
  ["neemuch"]="neemuch"
  ["rajgarh"]="rajgarh"
  ["ratlam"]="ratlam"
  ["rewa"]="rewa"
  ["saharanpur"]="saharanpur"
  ["satna"]="satna"
  ["shahdol"]="shahdol"
  ["shajapur"]="shajapur"
  ["sidhi"]="sidhi"
  ["singrauli"]="singrauli"
)

build_flavor() {
    generate_launcher_icons "$1"
    MAIN_PATH="lib/flavors/$1.dart"

    if [[ "$1" == "dev" ]]; then
      BUILD_TYPE=apk
      SENTRY_ENVIRONMENT="dev"
      SHAR_BASE_URL="https://shar.radiorocket.dev"
    else
      BUILD_TYPE=appbundle
      SENTRY_ENVIRONMENT="production"
      SHAR_BASE_URL="https://shar.radiorocket.in"
    fi
    flutter build $BUILD_TYPE --flavor "$1" -t "$MAIN_PATH" \
     --dart-define SENTRY_DSN="$SENTRY_DSN" \
     --dart-define SENTRY_ENVIRONMENT="$SENTRY_ENVIRONMENT" \
     --dart-define WEBENGAGE_KEY="$WEBENGAGE_KEY" \
     --dart-define SHAR_BASE_URL="$SHAR_BASE_URL"
}

generate_launcher_icons() {
     flutter pub run flutter_launcher_icons:main -f "launcher_icons/$1.yaml"
}

check_sentry_key() {
    if [[ -z $SENTRY_DSN ]]; then
      echo "SENTRY_DSN is not set"
      exit 1
    fi
}

check_webengage_key() {
    if [[ -z $WEBENGAGE_KEY ]]; then
      echo "WEBENGAGE_KEY is not set"
      exit 1
    fi
}

check_env() {
  check_sentry_key
  check_webengage_key
}

build_all () {
  for station in "${STATIONS[@]}"; do
    build_flavor "$station"
  done
}

generate_all_icons() {
  for station in "${STATIONS[@]}"; do
    generate_launcher_icons "$station"
  done
}

validate_stations() {
  valid=true
  for station in "${@:1}"; do
    if [[ ! -v STATIONS["$station"] ]]; then
      valid=false
      echo "Invalid station: $station"
    fi
  done
  if [[ $valid == "false" ]]; then
    exit 1
  fi
}

cmd_icons() {
  if [[ -z $1 || $1 == "all" ]]; then
    generate_all_icons
  else
    validate_stations "${@:1}"
    for station in "${@:1}"; do
      generate_launcher_icons "$station"
    done
  fi
}

cmd_build() {
  check_env
  if [[ -z $1 || $1 == "all" ]]; then
    build_all
  else
    validate_stations "${@:1}"
    for station in "${@:1}"; do
      build_flavor "$station"
    done
  fi
}

if [[ -z $1 ]]; then
  echo "Invalid arguments"
  exit 1
elif [[ $1 == "icons" ]]; then
  cmd_icons "${@:2}"
elif [[ $1 == "build" ]]; then
  cmd_build "${@:2}"
else
  cmd_build "${@:1}"
fi
