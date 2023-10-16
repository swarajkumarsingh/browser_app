run:
	flutter run

build:
	flutter build apk --target-platform android-arm64 --analyze-size

split_build:
	flutter build apk --split-per-abi --no-shrink 