.PHONY: web apk

web:
	flutter build web --release --web-renderer html

webdev:
	flutter run -d chrome --web-renderer html --web-hostname 0.0.0.0

webpro:
	flutter run -d chrome --web-renderer html --web-hostname 0.0.0.0 --release

apk:
	flutter build apk --release