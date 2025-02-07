build-ios:
	rm -rf output && fvm flutter build ios-framework --xcframework --output=output/ios
	$(MAKE) copy-kernel-blob
	$(MAKE) clean-dsym
	$(MAKE) copy-app-files

copy-kernel-blob:
	cp output/ios/Debug/App.xcframework/ios-arm64/App.framework/flutter_assets/kernel_blob.bin \
	   output/ios/Release/App.xcframework/ios-arm64/App.framework/flutter_assets/
	cp output/ios/Debug/App.xcframework/ios-arm64_x86_64-simulator/App.framework/flutter_assets/kernel_blob.bin \
	   output/ios/Release/App.xcframework/ios-arm64_x86_64-simulator/App.framework/flutter_assets/

copy-app-files:
	rm -rf output/ios/Release/App.xcframework
	cp -R output/ios/Debug/App.xcframework output/ios/Release/
	cp -R output/ios/Debug/Flutter.xcframework output/ios/Release/

clean-replace-sources:
	find ../spm/Sources/ -mindepth 1 ! -path '../spm/Sources/spm' ! -path '../spm/Sources/spm/spm.swift' -exec rm -rf {} +
	cp -rf output/ios/Release/* ../spm/Sources/

clean-dsym:
	rm -rf output/ios/Release/App.xcframework/ios-arm64/dSYMs/Flutter.framework.dSYM
	
asset:
	cd scripts && fvm dart gen_assets.dart

vm:
	cd scripts && fvm dart vm_gen.dart --open
	$(MAKE) routes

routes:
	cd scripts && fvm dart gen_routes.dart

gen:
	fvm flutter pub run build_runner build --delete-conflicting-outputs